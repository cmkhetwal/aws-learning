links:-
https://docs.vultr.com/how-to-install-apache-tomcat-on-ubuntu-24-04

https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html?icmpid=docs_amazons3_console

{
  "Id": "Policy1737294797159",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1737294793765",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::myfirstwebhostingstatic",
      "Principal": "*"
    }
  ]
}


https://docs.aws.amazon.com/AmazonS3/latest/userguide/HostingWebsiteOnS3Setup.html


https://www.ubuntumint.com/install-apache-in-linux/

===================================================================================================================================================================================================================================================================
for efs map:-
sudo apt update -y
sudo apt install nfs-common -y
mkdir efs
then the mapping command

EBS:-
https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html

mount EBS volume
lsblk
sudo mkfs -t xfs /dev/xvdd
sudo mkdir /data
sudo mount /dev/xvdd /data
===================================================================================================================================================================================================================================================================

===================================================================================================================================================================================================================================================================
Snapshot Practical
create and attach volume to second instance
add some file on this volume
take snapshot of this volume
create a volume out of this snapshot and make it available for other instance in diffrent AZ
once volume is ready, attach it to second instance
run lsblk to see device id
run mount command to mount the volume, no need to make file system becuase it will already have a file system
sudo mkdir /data
sudo mount /dev/xvdd /data
check the old data and verify
===================================================================================================================================================================================================================================================================


===================================================================================================================================================================================================================================================================
Multi EBS Practical
https://docs.aws.amazon.com/ec2/latest/instancetypes/ec2-nitro-instances.html  > supported instances types
for EBS multi Attach Select only applicable vms like m5dn family type
then attach the same volume multiple times to all instances one by one
lsblk
sudo mkfs -t xfs /dev/xvdd
sudo mkdir /data
sudo mount /dev/xvdd /data
===================================================================================================================================================================================================================================================================

===================================================================================================================================================================================================================================================================
making bucket public or object public
{
  "Id": "Policy1737358641738",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1737358640487",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::firstbucketmakepublicfile/test/*", #this will only make test folder public, rest not
      "Principal": "*"
    }
  ]
}

if you do arn:aws:s3:::firstbucketmakepublicfile/* then all files and folders are public in s3

https://aws.amazon.com/s3/faqs/
===================================================================================================================================================================================================================================================================


https://aws.amazon.com/blogs/storage/scaling-data-access-with-amazon-s3-access-grants/

https://github.com/staleycyn #this is for Azure practicals

aws Notes : https://github.com/Ernyoke/certified-aws-solutions-architect-associate/tree/main

aws notes : https://github.com/keenanromain/AWS-SAA-C02-Study-Guide

===================================================================================================================================================================================================================================================================
instance store volumes
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/adding-instance-storage-instance.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/adding-instance-storage-instance.html
Only Specified Machine types will have Instance Store Option
such as C1, C3, M1, M2, M3, R3, D2, H1, I2, X1, and X1e
===================================================================================================================================================================================================================================================================



================================================================================================================================================================================================================================================================
**This will create 3 ec2 instance for ebs and efs practical**
https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/quickcreate?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0004-aws-associate-ec2-ebs-demo/A4L_VPC_3PUBLICINSTANCES_AL2023.yaml&stackName=EBSDEMO

These are the commands used to perform ebs and efs demo
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0004-aws-associate-ec2-ebs-demo/lesson_commands_AL2023.txt #this is for ebs mapping and restore
=================================================================================================================================================================================================================================================================


Only the used EBS is charged, like if the ebs volume is of 10 gb but the data inside it is 5 gb, so you will be charged for 5 gb only

Instance Store data will be gone after you stop the server then start the server. you will have to create the filesystem again


=================================================================================================================================================================================================================================================================
**wordpress yml, this will create an ec2 on which you will install wordpress**
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0006-aws-associate-ec2-wordpress-on-ec2/A4L_VPC_PUBLICINSTANCE_AL2023.yaml&stackName=WORDPRESS

wordpress installation steps
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0006-aws-associate-ec2-wordpress-on-ec2/lesson_commands_AL2023.txt
=================================================================================================================================================================================================================================================================



=================================================================================================================================================================================================================================================================
AMI yml, this will create an ec2 instance in public networj and we will install wordpress and motd login banner with below commands
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0007-aws-associate-ec2-ami-demo/A4L_VPC_PUBLICINSTANCE_AL2023.yaml&stackName=AMIDEMO

steps on ec2
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0007-aws-associate-ec2-ami-demo/lesson_commands_AL2023.txt
================================================================================================================================================================================================================================================================


================================================================================================================================================================================================================================================================
**Instance status checks and recovery, this will create an ec2 instance, where you can confugure instance status checks in cloudwatch, so that if instance fails what could be done, like terminate,reboot,recovery**
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0022-aws-associate-ec2-statuschecksandterminateprotection/A4L_VPC_PUBLICINSTANCE.yaml&stackName=STATUSCHECKSANDPROTECT

what will be lost and saved when does auto recovery :
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html
=================================================================================================================================================================================================================================================================

Create Website / ADD Load balancer / Map Domain to LB as Alias / Add SSL / create Autoscale by hit counts

add apache2 and add website content
Steps for Apache and website:-
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo mkdir /var/www/mountain-site
sudo chown -R $USER:$USER /var/www/mountain-site
sudo chmod -R 755 /var/www/mountain-site
sudo apt install php libapache2-mod-php -y
sudo systemctl restart apache2
vim /var/www/mountain-site/index.php
====
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Mountain Site</title>
    <style>
        body {
            background-image: url('https://images.pexels.com/photos/1324803/pexels-photo-1324803.jpeg');
            background-size: cover;
            background-position: center;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
        }
        h1 {
            background-color: rgba(0, 0, 0, 0.5);
            padding: 20px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <h1>Welcome from <?php echo gethostname(); ?></h1>
</body>
</html>
======
sudo vim /etc/apache2/sites-available/mountain-site.conf
===
<VirtualHost *:80>
    ServerAdmin webmaster@your-domain.com
    DocumentRoot /var/www/mountain-site
    ServerName mountains.infomofighters.xyz
    ServerAlias www.mountains.infomofighters.xyz

    <Directory /var/www/mountain-site>
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
===
sudo a2ensite mountain-site.conf
sudo systemctl reload apache2
Test the Website with public ip

check if the website is running
add load balancer and in target group add intance first 80 then 443 rule after certificate issued
certificate from aws are free
now from route53 point the website to lb
check the website is running
for opening the website in https, add https allow from 0.0.0.0 in LB security group
now check with https url or the website will auto go to https only

Create image of this EC2 instance
Once Image is Ready, Use this same image to create launch template
then via this launch template create auto scaling group
put limit of 10 in request for per ec2
put warm time to 60 seconds
once the desired configuration don in scaling group, let it come in ready state

now run the curl request in loop with mentioned command
while true; do   seq 1 200 | xargs -n 1 -P 200 curl -s -o /dev/null -w "%{http_code}\n" "https://mountains.infomofighters.xyz"; done
This curl will keep hiting you LB and give response to you , now wait until 15 minutes , then you can check new ec2 instances are launched
once launched you can press ctrl c to stop while loop, again wait for 15 minutes and see if the instances are terminated


