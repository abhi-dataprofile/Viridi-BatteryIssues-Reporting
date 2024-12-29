# !/bin/bash

# Input Data Location 
export current_date=$(date +'%Y-%m-%d')
export s3virididlwest=$$s3virididlwest$$/$current_date
export s3__device_data_event=$$s3__device_data_event$$
export spark_output_location=$$spark_output_location$$
export from_email_id=$$from_email_id$$
export recipients=$$recipients$$ 
export cc_email=$$cc_email$$ 
export region_name=$$region_name$$
export SNS_ARN=$$TopicArn$$
export SNOWFLAKE_USER=$$SNOWFLAKE_USER$$
export SNOWFLAKE_PASSWORD=$$SNOWFLAKE_PASSWORD$$
export SNOWFLAKE_ACCOUNT=$$SNOWFLAKE_ACCOUNT$$
export SNOWFLAKE_WAREHOUSE=$$SNOWFLAKE_WAREHOUSE$$
export SNOWFLAKE_DB=$$SNOWFLAKE_DB$$
export SNOWFLAKE_SCHEMA=$$SNOWFLAKE_SCHEMA$$
export SNOWFLAKE_ROLE=$$SNOWFLAKE_ROLE$$
export s3_case_report_staging=$$s3_case_report_staging$$
export s3_viridi_work_order=$$s3_viridi_work_order$$
export SNOWFLAKE_TABLE_NAME=$$SNOWFLAKE_TABLE_NAME$$

python3 /home/hadoop/scripts/spark/snowflake_to_local.py $SNOWFLAKE_TABLE_NAME
OUT=$?
if [ $OUT -eq 0 ];then
   echo "snowflake_to_local executed successfully!"
else
   SUBJECT="Step Function - Spark Script Failed"
   MESSAGE="snowflake_to_local.py Script Failed."$(date +%Y-%m-%d\ %H:%M:%S)
   region="us-west-2"
   aws sns publish \
      --topic-arn "$SNS_ARN" \
      --subject "$SUBJECT" \
      --message "$MESSAGE" \
      --region "$region"
   echo "snowflake_to_local Failed"
   exit 1
fi

aws s3 cp /home/hadoop/monthly.csv $s3_viridi_work_order


# Executing Data_preprocessing_case_pred Script
hive -f /home/hadoop/scripts/hive/Battery-Data-Reports.sql --hiveconf s3virididlwest=$s3virididlwest  --hiveconf s3__device_data_event=$s3__device_data_event --hiveconf s3_case_report_staging=$s3_case_report_staging --hiveconf s3_viridi_work_order=$s3_viridi_work_order
OUT=$?
if [ $OUT -eq 0 ];then
   echo "Battery-Data-Reports.sql executed successfully!"
else
   SUBJECT="Step Function - Hive Script Failed"
   MESSAGE="Battery-Data-Reports.sql Script Failed."$(date +%Y-%m-%d\ %H:%M:%S)
   region="us-west-2"
   aws sns publish \
      --topic-arn "$SNS_ARN" \
      --subject "$SUBJECT" \
      --message "$MESSAGE" \
      --region "$region"
   echo "Battery-Data-Reports.sql Script Failed !"
   exit 1
fi

spark-submit /home/hadoop/scripts/spark/spark_script.py $spark_output_location
OUT=$?
if [ $OUT -eq 0 ];then
   echo "spark_script executed successfully!"
else
   SUBJECT="Step Function - Spark Script Failed"
   MESSAGE="spark_script.py Script Failed."$(date +%Y-%m-%d\ %H:%M:%S)
   region="us-west-2"
   aws sns publish \
      --topic-arn "$SNS_ARN" \
      --subject "$SUBJECT" \
      --message "$MESSAGE" \
      --region "$region"
   echo "spark_script Failed"
   exit 1
fi

mkdir $spark_output_location

hadoop fs -get ${spark_output_location}/BatteryDataLastMonth.csv ${spark_output_location}/
hadoop fs -get ${spark_output_location}/AggregatedBatteryData.csv ${spark_output_location}/

cd /home/hadoop
cd ${spark_output_location}
zip -r ${spark_output_location}.zip BatteryDataLastMonth.csv AggregatedBatteryData.csv

# cd /home/hadoop
# zip -r $spark_output_location.zip battery-report/

python3 /home/hadoop/scripts/python/email_script.py $spark_output_location $from_email_id $recipients $cc_email $region_name
OUT=$?
if [ $OUT -eq 0 ];then
   echo "spark_script executed successfully!"
else
   SUBJECT="Step Function - Email Script Failed"
   MESSAGE="email_script.py Script Failed."$(date +%Y-%m-%d\ %H:%M:%S)
   region="us-west-2"
   aws sns publish \
      --topic-arn "$SNS_ARN" \
      --subject "$SUBJECT" \
      --message "$MESSAGE" \
      --region "$region"
   echo "email_script Failed"
   exit 1
fi