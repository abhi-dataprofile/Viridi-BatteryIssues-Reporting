import os

#replace values for terraform vars
with open("./modules/StepFunction/code/definition.json", "r") as files:
    content = files.read()
content=content.replace("$$Project_Name$$", os.environ['Project_Name'])
content=content.replace("$$EMR_ServiceRole$$", os.environ['EMR_ServiceRole'])
content=content.replace("$$EMR_CLUSTER_VERSION$$", os.environ['EMR_CLUSTER_VERSION'])
content=content.replace("$$EMR_JobFlowRole$$", os.environ['EMR_JobFlowRole'])
content=content.replace("$$EMR_LogUri$$", os.environ['EMR_LogUri'])
content=content.replace("$$EMR_CLUSTER_MASTER_NODE_TYPE$$", os.environ['EMR_CLUSTER_MASTER_NODE_TYPE'])
content=content.replace("$$EMR_CORE_INSTANCE_COUNT$$", os.environ['EMR_CORE_INSTANCE_COUNT'])
content=content.replace("$$EMR_CORE_INSTANCE_TYPE$$", os.environ['EMR_CORE_INSTANCE_TYPE'])
content=content.replace("$$S3_BOOTSTRAP_PATH$$", os.environ['S3_BOOTSTRAP_PATH'])
content=content.replace("$$S3_BOOTSTRAP_SCRIPT_ARG1$$", os.environ['S3_BOOTSTRAP_SCRIPT_ARG1'])
content=content.replace("$$S3_BOOTSTRAP_SCRIPT_ARG2$$", os.environ['S3_BOOTSTRAP_SCRIPT_ARG2'])
content=content.replace("$$EMR_SUBNET_ID$$", os.environ['EMR_SUBNET_ID'])
content=content.replace("$$EMR_START_SCRIPT_LOCATION$$", os.environ['EMR_START_SCRIPT_LOCATION'])
content=content.replace("$$TopicArn$$", os.environ['TopicArn'])

with open("./modules/StepFunction/code/definition.json", "w") as files:
    files.write(content)

#replace values for terraform main config file
with open("./config/main.tf", "r") as files:
    content = files.read()
content=content.replace("$$Project_Name$$", os.environ['Project_Name'])
content=content.replace("$$env$$", os.environ['env'])
content=content.replace("$$SCHEDULE_EXPRESSION$$", os.environ['SCHEDULE_EXPRESSION'])
content=content.replace("$$role_arn$$", os.environ['role_arn'])
content=content.replace("$$SF_role_arn$$", os.environ['SF_role_arn'])
content=content.replace("$$SF_log_destination_arn$$", os.environ['SF_log_destination_arn'])

with open("./config/main.tf", "w") as files:
    files.write(content)

# replace values for Master.sh
with open("./scripts/shell/master.sh", "r") as files:
    content = files.read()
content=content.replace("$$s3virididlwest$$", os.environ['s3virididlwest'])
content=content.replace("$$s3__device_data_event$$", os.environ['s3__device_data_event'])
content=content.replace("$$spark_output_location$$", os.environ['spark_output_location'])
content=content.replace("$$from_email_id$$", os.environ['from_email_id'])
content=content.replace("$$recipients$$", os.environ['recipients'])
content=content.replace("$$cc_email$$", os.environ['cc_email'])
content=content.replace("$$region_name$$", os.environ['region_name'])
content=content.replace("$$TopicArn$$", os.environ['TopicArn'])
content=content.replace("$$s3_case_report_staging$$", os.environ['s3_case_report_staging'])
content=content.replace("$$s3_viridi_work_order$$", os.environ['s3_viridi_work_order'])

content=content.replace("$$SNOWFLAKE_TABLE_NAME$$", os.environ['SNOWFLAKE_TABLE_NAME'])

with open("./scripts/shell/master.sh", "w") as files:
    files.write(content)

with open("./scripts/spark/util/config_parser.py","r") as files:
    content = files.read()
content=content.replace("$$SNOWFLAKE_USER$$",os.environ['SNOWFLAKE_USER'])
content=content.replace("$$SNOWFLAKE_PASSWORD$$",os.environ['SNOWFLAKE_PASSWORD'])
content=content.replace("$$SNOWFLAKE_ACCOUNT$$",os.environ['SNOWFLAKE_ACCOUNT'])
content=content.replace("$$SNOWFLAKE_WAREHOUSE$$",os.environ['SNOWFLAKE_WAREHOUSE'])
content=content.replace("$$SNOWFLAKE_DB$$",os.environ['SNOWFLAKE_DB'])
content=content.replace("$$SNOWFLAKE_SCHEMA$$",os.environ['SNOWFLAKE_SCHEMA'])
content=content.replace("$$SNOWFLAKE_ROLE$$",os.environ['SNOWFLAKE_ROLE'])

with open("./scripts/spark/util/config_parser.py", "w") as files:
    files.write(content)
    