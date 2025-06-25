from typing import Any
import dataclasses
import json

import numpy as np
import snowflake.connector
import os
import pandas as pd
from configs import ActivityStatus, HistoricalData, Fleet, RollingStock, Vehicle

# Constants definition
TOLERANCE = 0.01  # Tolerance for determining activity status
DAYS = 7  # Default number of days for historical data

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


def calculate_vehicle_information(vehicle_df: pd.DataFrame, seconds_elapsed: float, days: int) -> Vehicle:
    vehicle_id = vehicle_df['VEHICLE_ID'].unique()[0]
    last_soh = vehicle_df.loc[vehicle_df['TIMESTAMP_KAFKA'].idxmax(), 'BATTERY_SOH']

    summary = vehicle_df.groupby([ "ACTIVITY_STATUS"], observed=False)[["ACTIVITY_STATUS"]].count().unstack(fill_value=0)
    summary[("ACTIVITY_STATUS", ActivityStatus.signal_absent.value)] = (seconds_elapsed - len(vehicle_df))

    activity_summed = summary.sum()
    activity_distribution = summary.div(activity_summed.sum(), axis=0)

    previous_data: HistoricalData = HistoricalData(
        period_in_days=days,
        activity_status=activity_distribution[ "ACTIVITY_STATUS"].to_dict()
    )
    return Vehicle(
        id=vehicle_id,
        previous_data=previous_data,
        last_soh=last_soh

    )



if __name__ == "__main__":
    days = DAYS
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
    enum_categories = [e.value for e in ActivityStatus]
    cat_dtype = pd.CategoricalDtype(categories=enum_categories, ordered=True)

    # Apply the function to create the new column
    df['ACTIVITY_STATUS'] = df.apply(determine_activity_status, axis=1)
    df = df.assign(ACTIVITY_STATUS=df['ACTIVITY_STATUS'].astype(cat_dtype))
    seconds_elapsed = pd.to_timedelta(max(pd.to_datetime(df['TIMESTAMP_KAFKA'])) - min(pd.to_datetime(df['TIMESTAMP_KAFKA']))).total_seconds()

    vehicles: dict[str,Vehicle] = {}
    for vehicle_id, vehicle_df in df.groupby('VEHICLE_ID'):
        vehicle = calculate_vehicle_information(vehicle_df, seconds_elapsed, days)
        vehicles[vehicle.id] = vehicle

    vehicle_ids_per_fleet : dict[str, list[str]] = df.groupby('FLOTTE')['VEHICLE_ID'].apply(lambda x : list(x.unique())).to_dict()

    fleet = []
    for fleet_id, vehicle_ids in vehicle_ids_per_fleet.items():


        fleet_vehicles : list[Vehicle] = [vehicles[vehicle_id] for vehicle_id in vehicle_ids if vehicle_id in vehicles]

        last_soh_avg = np.mean([vehicle.last_soh for vehicle in fleet_vehicles ])


        determine_activity_status_summary: dict[ActivityStatus, float]= { status: 0.0 for status in ActivityStatus}
        for vehicle in fleet_vehicles:
            for activity_status,value in vehicle.previous_data.activity_status.items():
                determine_activity_status_summary[activity_status] += value

        for activity_status, value in determine_activity_status_summary.items():
            determine_activity_status_summary[activity_status]  = value / len(fleet_vehicles)
        fleet_entry = Fleet(
            fleet_id=fleet_id,
            vehicles = fleet_vehicles,
            previous_data=HistoricalData(
                period_in_days=days,
                activity_status=determine_activity_status_summary
            ),
            last_soh = last_soh_avg
        )
        fleet.append(fleet_entry)

    fleet_overview = RollingStock(fleet_overview=fleet)
    fleet_per_category = {"Infrastructure": fleet_overview}

    json_data =  json.dumps(fleet_per_category, cls=DataclassEncoder, indent=4)
    with open("fleet_overview.json", "w") as f:
        f.write(json_data)


