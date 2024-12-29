import boto3
from email.mime.multipart import MIMEMultipart, MIMEBase
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
import sys
import os
from datetime import datetime
from os import environ
import zipfile

spark_output_location=sys.argv[1]

job_name="Battery-Data-Reports"
from_email_id=sys.argv[2]
recipients=sys.argv[3]
cc_email=sys.argv[4]
region_name=sys.argv[5]

zip_filename='Battery-Data-Reports.zip'
folder_path=spark_output_location

# with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zip_file:
#     for root, dirs, files in os.walk(folder_path):
#         for file in files:
#             file_path = os.path.join(root, file)
#             zip_file.write(file_path, arcname=file)

def callSuccessEmailNotification(
                                    job_name=None,
                                    from_email_id='viridiservice@viridi.com',
                                    recipients=None,
                                    cc_email=None,
                                    report_path=spark_output_location,
                                    aws_region="us-west-2"
                                ):
    try:
        print("I am in Success Email Notification")
        print('job_name :', job_name)
        print('from_email_id :', from_email_id)
        print('recipients :', recipients)
        print('cc_email :', cc_email)
        print('report_path :', report_path)

        ses = boto3.client('sesv2', region_name=aws_region)
        msg = MIMEMultipart('mixed')
        recipients = recipients.split(",")
        cc_email = cc_email.split(",")
        msg['From'] = from_email_id
        msg.preamble = 'Multipart message.\n'
        with open('/home/hadoop/scripts/python/successEmailTemplate.html', 'r', encoding='utf-8') as file:
            today = datetime.today()
            date_time_string = today.strftime("D:%Y/%m/%d   H:%H")
            successEmailHtml = file.read()
            successEmailHtml = successEmailHtml.replace(
                'job_name_string', job_name)
            successEmailHtml = successEmailHtml.replace('time_of_run_string', date_time_string)
            msg_body = MIMEMultipart('alternative')
            htmlpart = MIMEText(successEmailHtml, 'html', "utf-8")
            msg_body.attach(htmlpart)
            msg.attach(msg_body)
            with open(report_path+'.zip', 'rb') as f:
                attachment = MIMEApplication(f.read(), _subtype='zip')
                attachment.add_header('Content-Disposition', 'attachment', filename='battery-reports.zip')
                msg.attach(attachment)
            print('Send Regular Email')
            msg['Subject'] = job_name
            msg['To'] = ', '.join(recipients)
            result = ses.send_email(
                FromEmailAddress=msg['From'],
                Destination={'ToAddresses': recipients,'CcAddresses': cc_email},
                Content={'Raw': {'Data': msg.as_string()}})
            print(result)
    except Exception as e:
        raise e

callSuccessEmailNotification(
                                job_name,
                                from_email_id,
                                recipients,
                                cc_email,
                                spark_output_location,
                                region_name
                            )
                            