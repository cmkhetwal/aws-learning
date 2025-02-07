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

comands:-
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0013-aws-associate-ec2-cwagent/lesson_commands_AL2023.txt

==================================================================================================================================================================================================================

















