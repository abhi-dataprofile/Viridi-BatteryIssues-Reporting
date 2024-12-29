from pyspark.sql import SparkSession
import pandas as pd
from sql_metadata import Parser



class BaseClass:

    def __init__(self, rundate,SNOWFLAKE_TABLE_NAME):
        self.sparkSession = SparkSession.builder.getOrCreate()
        
        self.usage_query = f'''select * from {SNOWFLAKE_TABLE_NAME}
                        where date(LAST_MODIFIED_DATE_TIME__C) >= '{rundate}' ;
                        '''
