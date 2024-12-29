-- Battery-Data-Reports
DROP TABLE IF EXISTS `default._device_data_event`;

CREATE TABLE `default._device_data_event`(
  `event_timestamp` string,
  `customer_id` string,
  `device_id` string, 
  `device_type` string, 
  `device_status` string,
  `battery_level` string,
  `battery_health` string,
  `operational_mode` string,
  `energy_output` string,
  `location_id` string,
  `firmware_version` string,
  `job_day` date
)
PARTITIONED BY ( 
  `job_month` date, 
  `country_code` string, 
  `device_category` string
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.SequenceFileInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat'
LOCATION
  '${hiveconf:s3__device_data_event}';

msck repair table default._device_data_event;

CREATE TABLE `default.case_report_staging`
( 
  `case_id` string PRIMARY KEY,
  `origin` string,
  `issue_type` string,
  `description` string,
  `status` string DEFAULT 'Open',
  `assigned_worker_id` string,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `closed_at` TIMESTAMP,
  `customer_id` string,
  `device_id` string,
  `location_id` string
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\001'  
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
LOCATION '${hiveconf:s3_case_report_staging}';

msck repair table default.case_report_staging;

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `default.viridi_work_order`;

CREATE TABLE `default.viridi_work_order`(
  `work_order_id` string PRIMARY KEY,
  `case_id` string,
  `assigned_worker_id` string,
  `start_date` TIMESTAMP,
  `end_date` TIMESTAMP,
  `status` string,
  `worker_availability` BOOLEAN,
  `worker_location` string,
  `details` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES(
  "separatorChar" = ",",
  "quoteChar"     = "\""
)
LOCATION '${hiveconf:s3_viridi_work_order}';

msck repair table `default.viridi_work_order`;

-- ======== 1st of Month ==========

DROP TABLE IF EXISTS sbr.devicedata_patched_batterys;
CREATE DATABASE IF NOT EXISTS sbr;
CREATE TABLE sbr.devicedata_patched_batterys AS 
SELECT device_id, max(event_timestamp) as last_event
FROM default._device_data_event
GROUP BY device_id;

DROP TABLE IF EXISTS sbr.devicedata_patched_batterys_ranked;
CREATE TABLE sbr.devicedata_patched_batterys_ranked LOCATION '${hiveconf:s3virididlwest}' AS 
SELECT *, ROW_NUMBER() OVER (PARTITION BY device_id ORDER BY last_event DESC) as rank
FROM sbr.devicedata_patched_batterys;

