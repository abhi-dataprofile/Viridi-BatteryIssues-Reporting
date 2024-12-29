from pyspark.sql import SparkSession, functions as F
from datetime import datetime, timedelta
import sys

spark_output_location = sys.argv[1]

# Initialize Spark Session
spark = SparkSession.builder \
    .master('yarn') \
    .appName('BatteryDataAnalysis') \
    .enableHiveSupport() \
    .getOrCreate()

# Function to calculate date ranges
def get_date_range():
    today = datetime.today()
    last_month = today.replace(day=1) - timedelta(days=1)
    first_day_last_month = last_month.replace(day=1).strftime('%Y-%m-%d')
    return first_day_last_month

# Fetch data from sbr.devicedata_patched_batterys_ranked based on the case creation date
first_day_last_month = get_date_range()

# Query to fetch the latest battery data for cases created in the last month using ranked data
battery_data_query = f"""
SELECT b.case_id, b.created_at, d.*
FROM default.case_report_staging b
JOIN sbr.devicedata_patched_batterys_ranked d ON b.device_id = d.device_id
WHERE b.created_at >= '{first_day_last_month}'
AND b.status = 'Open'  -- Assuming we are only interested in open cases
AND d.rnk = 1  -- Ensuring only the most recent records are used
"""

# Execute the query and get the DataFrame
df_battery_data = spark.sql(battery_data_query)

# Save the DataFrame to a location
key_loc = f"{spark_output_location}/BatteryDataLastMonth.csv"
df_battery_data.coalesce(1).write.option("header", "true").format("csv").save(key_loc, mode="overwrite")

# Example additional processing: Aggregate data by device type and status
df_aggregated = df_battery_data.groupBy("device_type").agg(
    F.count("device_id").alias("count"),
    F.avg("battery_health").alias("average_battery_health")
)

# Save the aggregated data
agg_key_loc = f"{spark_output_location}/AggregatedBatteryData.csv"
df_aggregated.coalesce(1).write.option("header", "true").format("csv").save(agg_key_loc, mode="overwrite")

spark.stop()