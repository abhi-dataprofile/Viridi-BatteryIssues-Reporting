from configparser import ConfigParser
import sys
import os


try:
    environment = sys.argv[1].upper()
    #environment = 'PRD'
except:
    environment = 'LOCAL'

print("Environment=",environment)

try:
    # if os.path.isfile('config/config.ini'):
    #     print('True')
    # parser = ConfigParser()
    # parser.read('config/config.ini') 
    # snowflake_username = parser.get(environment, "snowflake_username")
    # snowflake_password = parser.get(environment, "snowflake_password")
    # sf_account = parser.get(environment,"sf_account")
    # sf_warehouse = parser.get(environment,"sf_warehouse")
    # sf_database = parser.get(environment, "sf_database")
    # sf_schema = parser.get(environment, "sf_schema")

    snowflake_username = '$$SNOWFLAKE_USER$$'
    snowflake_password = '$$SNOWFLAKE_PASSWORD$$'
    #sf_authenticator='externalbrowser'
    sf_account = '$$SNOWFLAKE_ACCOUNT$$'
    sf_warehouse = '$$SNOWFLAKE_WAREHOUSE$$'
    sf_database = '$$SNOWFLAKE_DB$$'
    sf_schema = '$$SNOWFLAKE_SCHEMA$$'
    sf_role= '$$SNOWFLAKE_ROLE$$'

except Exception as e:
    print("Error",e)