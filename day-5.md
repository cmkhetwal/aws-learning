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

**when it ask for agent use root not cwagent**

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
****Instruction for Event Notofication via SNS ( For any Application )**
Go to the CloudWatch Console:

Navigate to CloudWatch in the AWS Management Console.
Navigate to Logs:

In the left-hand menu, click Logs.
Select the log group where your Apache access logs are being pushed.
like : /var/log/access.log
next to Anomaly detection select Metric filters
Create a Metric Filter:

Under Log Streams, select the log stream that contains your Apache logs.
Click Create Metric Filter.
Define the Filter Pattern:

Enter the following filter pattern:

"103.93.115.84|103.99.14.194"


103.93.115.84  #here i am taking only one ip as an attacker ip , so this goes high i should be notified

This pattern will match either 103.93.115.84 or 103.99.14.194 in your logs.
Create the Metric:

After defining the filter pattern, assign a Metric Name (e.g., MatchedIPsCount).
Set the Metric Namespace (e.g., MyAppNamespace).
Set the Metric Value to 1.
Create the Metric Filter:

Click Create Filter.

Set Up a CloudWatch Alarm

go to /var/log/httpd/access_log log group
next to Anomaly detection select Metric filters and select the metric you have create and then click on create alarm with this metric

**then set the sns email if not set already otherwise use the already topic**

==================================================================================================================================================================================================================

RDS Demo:-
Splitting Wordpress Monolith => APP & DB
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0014-aws-associate-rds-dbonec2/A4L_WORDPRESS_ALLINONE_AND_EC2DB_AL2023.yaml&stackName=MONOLITHTOEC2DB -------> **The application db is installed on the same wordpress machine, need to shift db to db instance**

Download files to put in blog page of wordpress
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0014-aws-associate-rds-dbonec2/blog_images.zip

Once the images are pushed then publish 

Now the data is in server db  ...............>

Now we will move the db backup to db instance from below steps
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0014-aws-associate-rds-dbonec2/lesson_commands.txt


Migrating EC2 DB into RDS - Demo
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/A4L_WORDPRESS_AND_EC2DB_AL2023.yaml&stackName=MIGRATE2RDS ----> **here application and db are on diffrent machines, install rds manually from GUI and then push the db backup to RDS**

RDS Steps:-
Go to rds and create subnet group first
now create the rds with following details

DBName
a4lwordpress
-
DBPassword
4n1m4ls4L1f3

DBUser
a4lwordpress

Initial db name should be same or whatever you want, here we are using same db name as **a4lwordpress**

Once ready change delete the rule in rds security group and add ec2 security group to allow

**delete the default inbound rule from rds security group and readd which allows instance security group to communicate with RDS**

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/lesson_commands.txt

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/blog_images.zip




Migrating EC2 DB into RDS - Demo
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/A4L_WORDPRESS_AND_EC2DB_AL2023.yaml&stackName=MIGRATE2RDS

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/lesson_commands.txt

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0015-aws-associate-rds-migrating-to-rds/blog_images.zip


https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/quickcreate?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0035-aws-associate-rds-snapshot-and-multiaz/A4L_WORDPRESS_AND_RDS_AL2023.yaml&stackName=RDSMULTIAZSNAP&param_DBVersion=8.0.32

Once the ec2 has loaded, launch the wordpress from it and create a blog page with images
use the below link to download images
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0035-aws-associate-rds-snapshot-and-multiaz/blog_images.zip

upload these images in wordpress blog and publish

now check the blog page

take the snaphot of rds
CALL YOUR SNAPSHOT : "a4lwordpress-with-cat-post-mysql-8032"

After you deploy RDS first we will enable multi region az support only  #this will take some time so wait
do not change the identifier name in the upcoming page
just select multi az and click on submit
Once multi AZ is ready test by rebooting
to test multi region support , we can do reboot of current rds and choose reboot with failover
in failover the current standby rds will become active and the current one will go to standby

when you do this you can refresh the page and see , until the new rds is not shifted till then the page will not load

RDS shanpshot restore Demo:-
Note:- you wont be able to restore this snapshot in same rds instance, Snapshot restore will always create the new rds instance, of which name you need to change in your application once it is ready

You application will running with connection to old rds instance, on rds you are just changing the pointing

But if you dont want to make rds instance again and agin, then setup a backup script on the server, which will be taking backups of your rds , and storing it where you want, like s3 or local server

https://repost.aws/knowledge-center/restore-rds-instance-from-snapshot # this is the amazon link where it is mentioned that we wont be able to restore this snapshot in same rds instance

restore steps:-
go to snapshot, and select the snapshot, you want to restore and click on actions then restore snapshot
Availability and durability = select whateve you want to select as per business needs
DB instance identifier = whatever-you-want-to-call-it
select vpc and security group which are created or create new
rest leave at it default until you want to
click on restore db instance
Once the new rds instance is ready , copy its cname value and paste it in your application, like in ours we are doing it for wordpress application
login to ec2
run
sudo vim /var/www/html/wp-config.php
replace the value in dbhost
:wq! to save the file
now refresh the page you will get the old data which was there in snapshot

==================================================================================================================================================================================================================















