s3 pre signed url
https://docs.aws.amazon.com/AmazonS3/latest/userguide/ShareObjectPreSignedURL.html
this can be done via gui but can be done via cli or sdk
aws s3 presign s3://amzn-s3-demo-bucket/mydoc.txt --expires-in 604800

==================================================================================================================================================================================================================
s3 select and glacier select
example you have large csv or json or parquet file which contains milions of records, now you only need some portion or only specific records from this file, then instead of downloading full file you can query this file directly on s3 and when records are found you can download them. this will reduce network out cost for you

https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-select.html

==================================================================================================================================================================================================================

Demo Multi Region S3 Access points Steps:-
https://github.com/acantril/learn-cantrill-io-labs/tree/master/00-aws-simple-demos/aws-s3-multi-region-access-point

==================================================================================================================================================================================================================

Using EC2 Instance Roles
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0011-aws-associate-ec2-instance-role/A4L_VPC_PUBLICINSTANCE_ROLEDEMO.yaml&stackName=IAMROLEDEMO   ............> this will install ec2, attach the role to this create to ec2 and access s3

create a role with full s3 access and attach that role to ec2 instance

go to ec2 instance and run below commands:-

aws s3 ls

curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

curl http://169.254.169.254/latest/meta-data/iam/security-credentials/yourrolenamehere

==================================================================================================================================================================================================================

Parameter Store

# CREATE PARAMETERS

/my-cat-app/dbstring        db.allthecats.com:3306
/my-cat-app/dbuser          bosscat
/my-cat-app/dbpassword      amazingsecretpassword1337 (encrypted)  #here use SecureString and MyCurrentAccount
/my-dog-app/dbstring        db.ifwereallymusthavedogs.com:3306
/rate-my-lizard/dbstring    db.thisisprettyrandom.com:3306

# GET PARAMETERS (if using cloudshell)
aws ssm get-parameters --names /rate-my-lizard/dbstring 
aws ssm get-parameters --names /my-dog-app/dbstring 
aws ssm get-parameters --names /my-cat-app/dbstring 
aws ssm get-parameters-by-path --path /my-cat-app/ 
aws ssm get-parameters-by-path --path /my-cat-app/ --with-decryption

==================================================================================================================================================================================================================

Logging and Metrics with CloudWatch Agent
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0013-aws-associate-ec2-cwagent/A4L_VPC_PUBLIC_Wordpress_AL2023.yaml&stackName=CWAGENT

steps:-
# IAM ROLE
Create an IAM role
Type : EC2 Role
Add Managed Policy `CloudWatchAgentServerPolicy`
And `AmazonSSMFullAccess`
Call the role `CloudWatchRole`

Attach the above role to ec2

sudo dnf install amazon-cloudwatch-agent

Attach the role to the EC2 instance created by the 1-click deployment.

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# Accept all defaults, until default metrics .. pick advanced.

when it ask for agent use root not cwagent

# then when asking for log files to monitor

# 1 /VAR/LOG/SECURE
/var/log/secure
/var/log/secure
(Accept default instance ID)
Accept the default retention option

# 2 /var/log/httpd/access_log
/var/log/httpd/access_log
/var/log/httpd/access_log
(Accept default instance ID)
Accept the default retention option

# 3 /var/log/httpd/error_log
/var/log/httpd/error_log
/var/log/httpd/error_log
(Accept default instance ID)
Accept the default retention option

Answer no to any more logs
Save config into SSM
Use the default name.

# Config will be stored in /opt/aws/amazon-cloudwatch-agent/bin/config.json and stored in SSM


sudo mkdir -p /usr/share/collectd/
sudo touch /usr/share/collectd/types.db

# Load Config and start agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux -s


# CLEANUP

Delete the CFN stack
You can leave the SSM parameter store value
Delete the CwLog Groups for /var/log/secure, /var/log/httpd/access_log & /var/log/httpd/error_log
Delete the CloudWatchRole instance role you created.

==================================================================================================================================================================================================================

RDS Demo:-
Splitting Wordpress Monolith => APP & DB
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0014-aws-associate-rds-dbonec2/A4L_WORDPRESS_ALLINONE_AND_EC2DB_AL2023.yaml&stackName=MONOLITHTOEC2DB

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0014-aws-associate-rds-dbonec2/lesson_commands.txt

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0014-aws-associate-rds-dbonec2/blog_images.zip


Migrating EC2 DB into RDS - Demo
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/A4L_WORDPRESS_AND_EC2DB_AL2023.yaml&stackName=MIGRATE2RDS

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/lesson_commands.txt

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/blog_images.zip

**delete the default inbound rule from rds security group and readd which allows instance security group to communicate with RDS**

==================================================================================================================================================================================================================















