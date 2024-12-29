import snowflake.connector

class SnowflakeConnector:

    def __init__(self, user,password, account, warehouse, database, schema, role):
        self.conf = snowflake.connector.connect(
            user=user,
            #authenticator=authenticator,
            password=password,
            account=account,
            role=role,
            
        )
        self.warehouse = warehouse
        self.schema = schema
        self.database = database
        
        self.cursor = self.conf.cursor()
        


    def query_executor(self,query):
        self.cursor.execute("USE WAREHOUSE {}".format(self.warehouse))
        self.cursor.execute("USE DATABASE {}".format(self.database))
        self.cursor.execute("USE SCHEMA {}".format(self.schema))
        self.cursor.execute(query)
        return self.cursor

    def cursor_close(self):
        self.cursor.close()