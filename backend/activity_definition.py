import snowflake.connector
import os
import pandas as pd

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
def determine_activity_status(row):
    TOLERANCE = 0.1
    vehicle_speed = row['VEHICLE_SPEED']
    charger_power = row['CHARGER_POWER']
    power_traction = row['POWER_1_TRACTION']
    power_compressor = row['POWER_COMPRESSOR']
    errors = row["ERRORS"]



    if errors != '[]':
        return 'Störung'
    elif power_compressor > TOLERANCE:
        return 'Arbeit'
    elif charger_power > TOLERANCE and abs(power_traction) <= TOLERANCE:
        return 'Laden'
    elif abs(vehicle_speed) > TOLERANCE and abs(power_traction) <= TOLERANCE:
        return 'Nichts' # Vorher hatten wir 'Passiv'
    elif abs(vehicle_speed) > TOLERANCE and abs(power_traction) > TOLERANCE:
        return 'Arbeit'
    elif abs(vehicle_speed) <= TOLERANCE and abs(charger_power) <= TOLERANCE and abs(power_traction) <= TOLERANCE and abs(power_compressor) <= TOLERANCE:
        return 'Nichts'
    else :
        return 'Ungültig'



if __name__ == "__main__":
    days = 7
    cur = setup()
    query = f"""
        SELECT VEHICLE_ID, TIMESTAMP_KAFKA, VEHICLE_SPEED, CHARGER_POWER, POWER_1_TRACTION, POWER_COMPRESSOR, ERRORS
        FROM SBB_EAP_BIENEDATA_HACK4RAIL_SHARE.SERVING.BATTERIELOK_DATA 
        WHERE TIMESTAMP_KAFKA >= CURRENT_TIMESTAMP() - INTERVAL '{days} days'
        -- WHERE VEHICLE_ID = '99 85 9236 024-7'
        -- ORDER BY RANDOM()
        -- LIMIT 500000
            
"""

    cur.execute(query)
    results = cur.fetchall()
    df = pd.DataFrame(results, columns=[col[0] for col in cur.description])

    # Apply the function to create the new column
    df['ACTIVITY_STATUS'] = df.apply(determine_activity_status, axis=1)

    summary = df.groupby(["VEHICLE_ID", "ACTIVITY_STATUS"])["ACTIVITY_STATUS"].count().unstack(fill_value=0)

    print(df.head())

    seconds_elapsed = pd.to_timedelta(max(pd.to_datetime(df['TIMESTAMP_KAFKA'])) - min(pd.to_datetime(df['TIMESTAMP_KAFKA']))).total_seconds()
    print(f"Total seconds elapsed: {seconds_elapsed}")

    summary["Fehlendes Signal"] = (seconds_elapsed - summary.sum(axis=1)).astype(int)

    print(summary)


