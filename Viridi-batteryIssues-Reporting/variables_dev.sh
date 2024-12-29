export env='dev'
export deployment_bucket="s3://dev-emr-pipeline/s/d/p/dev/battery-data-reports"

# Step Function Variables
export Project_Name="battery-data-reports" # tf Json
export EMR_ServiceRole="arn:aws:iam::xxxxxxxxxxxxx:role/Discovery-EMR-Default-Role" #"EMR_DefaultRole" # ~ ROLE 
export EMR_JobFlowRole="arn:aws:iam::xxxxxxxxxxxxx:instance-profile/Discovery-EMR-Default-Resource-Role" #"EMR_EC2_DefaultRole" # ~ RESOURCEROLE ~ IAM role for instance profile
export EMR_LogUri="s3://dev-emr-pipeline/s/d/deployment/stepfunction/battery-data-reports/dev/logs/"
export EMR_CLUSTER_MASTER_NODE_TYPE='m5.xlarge'
export EMR_CORE_INSTANCE_TYPE='m5.xlarge'
export EMR_CORE_INSTANCE_COUNT='1'
export EMR_CLUSTER_VERSION='emr-5.36.0'
export S3_BOOTSTRAP_PATH=$deployment_bucket'/artifacts/bootstrapActions/bootstrap.sh'
export S3_BOOTSTRAP_SCRIPT_ARG1=$deployment_bucket'/artifacts/scripts/'
export S3_BOOTSTRAP_SCRIPT_ARG2='/home/hadoop/scripts'
export SF_role_arn="arn:aws:iam::xxxxxxxxxxxxx:role/service-role/StepFunctions-Default-role-fb8d1f0c" # tf # yet to be created manually 
export SF_log_destination_arn="arn:aws:logs:us-west-2:xxxxxxxxxxxxx:log-group:battery-data-reports:*" 
export EMR_SUBNET_ID="subnet-xxxxxxxx"
export EMR_START_SCRIPT_LOCATION="/home/hadoop/scripts/shell/trigger.sh"
export TopicArn="arn:aws:sns:us-west-2:xxxxxxxxxxxxx:battery-data-reports"  
export S3_BOOTSTRAP=$deployment_bucket'/artifacts/bootstrapActions/'
export SCHEDULE_EXPRESSION="cron(00 03 ? * 2#1 *)"
export role_arn="arn:aws:iam::xxxxxxxxxxxxx:role/CasePredictRole" # yet to be created manually 

# Script Variables 
export s3virididlwest=$deployment_bucket"/devicedata_patched_batterys_ranked"
export s3__device_data_event="s3://prod/data/p/_device_data_event"

export spark_output_location="/home/hadoop/battery-report"
export from_email_id="viridicommerceservice@viridi.com"
export recipients="prat@viridi.com"
export cc_email="abhishek.jadhav@viridi.com"
export region_name="us-west-2"


export s3_case_report_staging="s3://team/case_report_staging/"
export s3_viridi_work_order=$deployment_bucket'/battery-printcycle/results/'


#Snowflake
export SNOWFLAKE_USER=$SNOWFLAKE_USER
export SNOWFLAKE_PASSWORD=$SNOWFLAKE_PASSWORD
export SNOWFLAKE_ACCOUNT=""
export SNOWFLAKE_WAREHOUSE=""
export SNOWFLAKE_DB=""
export SNOWFLAKE_SCHEMA=""
export SNOWFLAKE_ROLE=""
export SNOWFLAKE_INPUT=""
export SNOWFLAKE_TABLE_NAME=""



