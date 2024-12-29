from util.config_parser import *
from util.snowflakeconnector import *
from sparkCode.sparkclass import BaseClass

from datetime import datetime, timedelta
from pyspark.sql.functions import split, explode
import pandas as pd
import boto3
from io import StringIO
from datetime import date
from pyspark.sql.functions import split, when
import pyspark.sql.functions as F
from pyspark.sql.functions import current_timestamp
from pyspark import SparkConf, SparkContext

from pyspark.sql.functions import col
from pyspark.sql.functions import col, count, lit
from datetime import date

from pyspark.sql.functions import col
import boto3
import sys

SNOWFLAKE_TABLE_NAME=sys.argv[1]

# Create a SparkConf object to configure the Spark application
conf = SparkConf()
conf.set("spark.executor.memory", "4g")  # Set executor memory
conf.set("spark.driver.memory", "2g")  # Set driver memory
conf.set("spark.executor.memoryOverhead", "1g")  # Set executor memory overhead
conf.set("spark.driver.memoryOverhead", "1g")  # Set driver memory overhead
conf.set("spark.memory.fraction", "0.6")  # Set fraction of JVM heap used for Spark memory
conf.set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
# Create a SparkContext with the configured SparkConf
sc = SparkContext(conf=conf)

# Your PySpark code goes here

now = datetime.now()
first_day_of_current_month = now.replace(day=1)
last_day_of_previous_month = first_day_of_current_month - timedelta(days=1)
rundate = last_day_of_previous_month.replace(day=1)
print(rundate)


try:
    spark = BaseClass(rundate,SNOWFLAKE_TABLE_NAME)
except Exception as e:
    print(f'Error while creating pyspark session: {e}')

try:
    snowflake = SnowflakeConnector(snowflake_username,snowflake_password,sf_account,sf_warehouse,sf_database,sf_schema,sf_role)
    print("Snowflake connection succeed.")
except Exception as e:
    print(f'Snowflake Connection Failed. Error: {e}')

snowflake.query_executor(spark.usage_query)
print("query done")
#rows = snowflake.cursor.fetchall()
rows= [list(row) for row in snowflake.cursor.fetchall()]
print("r d")
if rows:
    column_names = [desc[0] for desc in snowflake.cursor.description]
    print("c d")
    pandas_df = pd.DataFrame(rows, columns=column_names)
    print(pandas_df)
else:
    print("rows is empty")

#spark_df.show()
current_date = date.today()

#partition_columns = ['database__name', 'start__date']
s3_output_path = "/home/hadoop/tables"

output_path = "/home/hadoop/monthly.csv"
pandas_df.to_csv(output_path, index=False)
print('DataFrame successfully uploaded to S3 bucket with partitions.')

sc.stop()

