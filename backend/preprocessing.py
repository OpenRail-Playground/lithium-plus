import snowflake.connector
import os

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
query = "SELECT * FROM SBB_EAP_BIENEDATA_HACK4RAIL_SHARE.SERVING.BATTERIELOK_DATA LIMIT 5000000"

cur.execute(query)
results = cur.fetchall()

print(results)

