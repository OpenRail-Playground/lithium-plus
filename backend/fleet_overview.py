from traceback import print_tb
from typing import Any
import dataclasses
import json

import numpy as np
import snowflake.connector
import os
import pandas as pd
from configs import ActivityStatus, HistoricalData, CurrentStatus, Fleet, RollingStock, \
    VehicleStatus


# Custom JSON encoder for dataclasses
class DataclassEncoder(json.JSONEncoder):
    def default(self, obj: Any) -> Any:
        if dataclasses.is_dataclass(obj):
            return dataclasses.asdict(obj)
        elif isinstance(obj, np.ndarray):
            return list(obj)  # Convert numpy arrays to lists
        return super().default(obj)
def setup():
    conn = snowflake.connector.connect(
        user=os.environ["SNOWFLAKE_USER"],
        password=os.environ["SNOWFLAKE_PASSWORD"],
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        warehouse=os.environ["SNOWFLAKE_WAREHOUSE"],
        database=os.environ["SNOWFLAKE_DATABASE"],
        schema=os.environ["SNOWFLAKE_SCHEMA"],
        role=os.environ["SNOWFLAKE_ROLE"]
    )

    cur = conn.cursor()
    return cur

# Function to determine activity_status
def determine_activity_status(row) -> ActivityStatus:
    TOLERANCE = 0.01
    vehicle_speed = row['VEHICLE_SPEED']
    charger_power = row['CHARGER_POWER']
    power_traction = row['POWER_1_TRACTION']
    power_compressor = row['POWER_COMPRESSOR']
    errors = row["ERRORS"]
    power_4 = row["POWER_4"]

    sum_power = abs(power_4) +  abs(power_traction)

    if errors != '[]':
        return ActivityStatus.malfunction
    elif abs(power_compressor) > TOLERANCE:
        return ActivityStatus.utilization
    elif abs(charger_power) > TOLERANCE and sum_power <= TOLERANCE:
        return ActivityStatus.charging
    elif abs(vehicle_speed) > TOLERANCE and sum_power <= TOLERANCE:
        return ActivityStatus.idle # Vorher hatten wir 'Passiv'
    elif abs(vehicle_speed) > TOLERANCE and sum_power > TOLERANCE:
        return ActivityStatus.utilization
    elif abs(power_4) > TOLERANCE:
        return ActivityStatus.utilization
    elif abs(vehicle_speed) <= TOLERANCE and abs(charger_power) <= TOLERANCE and sum_power <= TOLERANCE and abs(power_compressor) <= TOLERANCE:
        return ActivityStatus.idle
    else :
        return ActivityStatus.invalid



if __name__ == "__main__":
    days = 7
    cur = setup()
    query = f"""
        SELECT veh.FLOTTE, bat.VEHICLE_ID, bat.TIMESTAMP_KAFKA, bat.VEHICLE_SPEED, bat.CHARGER_POWER, bat.POWER_1_TRACTION, bat.POWER_COMPRESSOR, bat.ERRORS, bat.BATTERY_SOH, bat.POWER_4
        FROM SBB_EAP_BIENEDATA_HACK4RAIL_SHARE.SERVING.BATTERIELOK_DATA bat
        LEFT JOIN SBB_EAP_BIENEDATA_HACK4RAIL_SHARE.SERVING.VEHICLES veh
        on veh.UIC_NUMMER = bat.VEHICLE_ID
        WHERE TIMESTAMP_KAFKA >= CURRENT_TIMESTAMP() - INTERVAL '{days} days'
        -- WHERE VEHICLE_ID = '99 85 9236 024-7'
        -- ORDER BY RANDOM()
        -- LIMIT 500000
            
"""

    cur.execute(query)
    results = cur.fetchall()
    df = pd.DataFrame(results, columns=[col[0] for col in cur.description])
    state_of_health = df['BATTERY_SOH'].mean()
    df.drop(columns=['BATTERY_SOH'], inplace=True)
    enum_categories = [e.value for e in ActivityStatus]
    cat_dtype = pd.CategoricalDtype(categories=enum_categories, ordered=True)

    # Apply the function to create the new column
    df['ACTIVITY_STATUS'] = df.apply(determine_activity_status, axis=1)
    df = df.assign(ACTIVITY_STATUS=df['ACTIVITY_STATUS'].astype(cat_dtype))

    summary = df.groupby(["FLOTTE", "VEHICLE_ID", "ACTIVITY_STATUS"], observed=False)["ACTIVITY_STATUS"].count().unstack(fill_value=0)

    print(df.head())

    vehicles_per_fleet = df.groupby("FLOTTE")["VEHICLE_ID"].unique()

    seconds_elapsed = pd.to_timedelta(max(pd.to_datetime(df['TIMESTAMP_KAFKA'])) - min(pd.to_datetime(df['TIMESTAMP_KAFKA']))).total_seconds()
    print(f"Total seconds elapsed: {seconds_elapsed}")

    summary[ActivityStatus.signal_absent.value] = (seconds_elapsed - summary.sum(axis=1)).astype(int)

    activity_summed = summary.groupby(["FLOTTE"]).sum()
    activity_distribution = activity_summed.div(activity_summed.sum(axis=1), axis=0)
    rolling_stock = []
    for fleet_name, fleet_data in activity_distribution.iterrows():
        vehicles_ids = vehicles_per_fleet[fleet_name]
        previous_data: HistoricalData = HistoricalData(
            period_in_days=days,
            activity_status=fleet_data.to_dict())
        current_state = CurrentStatus(
            state_of_health=state_of_health, # Placeholder value, adjust as needed
            availability={vehicle_id: VehicleStatus.available for vehicle_id in vehicles_ids},
            percentage_of_available_vehicles=100
            )
        fleet_data = Fleet(
            fleet_id = fleet_name,
            vehicle_ids = vehicles_ids,
            previous_data=previous_data,
            current_state=current_state
        )
        rolling_stock.append(fleet_data)

    fleet_overview = RollingStock(fleet_overview=rolling_stock)
    fleet_per_category = {"Infrastructure": fleet_overview}

    json_data =  json.dumps(fleet_per_category, cls=DataclassEncoder, indent=4)
    with open("fleet_overview.json", "w") as f:
        f.write(json_data)


