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
===============================================================
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
================================================================


https://docs.aws.amazon.com/ec2/latest/instancetypes/ec2-nitro-instances.html  > supported instances types
for EBS multi Attach Select only applicable vms like m5dn family type
then attach the same volume multiple times to all instances one by one
lsblk
sudo mkfs -t xfs /dev/xvdd
sudo mkdir /data
sudo mount /dev/xvdd /data

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

https://aws.amazon.com/blogs/storage/scaling-data-access-with-amazon-s3-access-grants/

https://github.com/staleycyn #this is for Azure practicals

aws Notes : https://github.com/Ernyoke/certified-aws-solutions-architect-associate/tree/main

aws notes : https://github.com/keenanromain/AWS-SAA-C02-Study-Guide

instance store volumes
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/adding-instance-storage-instance.html

https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/quickcreate?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0004-aws-associate-ec2-ebs-demo/A4L_VPC_3PUBLICINSTANCES_AL2023.yaml&stackName=EBSDEMO

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0004-aws-associate-ec2-ebs-demo/lesson_commands_AL2023.txt #this is for ebs mapping and restore


Only the used EBS is charged, like if the ebs volume is of 10 gb but the data inside it is 5 gb, so you will be charged for 5 gb only

Instance Store data will be gone after you stop the server then start the server. you will have to create the filesystem again

wordpress yml 
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0006-aws-associate-ec2-wordpress-on-ec2/A4L_VPC_PUBLICINSTANCE_AL2023.yaml&stackName=WORDPRESS


manual wordpress
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0006-aws-associate-ec2-wordpress-on-ec2/lesson_commands_AL2023.txt

blog images folder for wordpress
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0006-aws-associate-ec2-wordpress-on-ec2/blogimages.zip

AMI yml
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0007-aws-associate-ec2-ami-demo/A4L_VPC_PUBLICINSTANCE_AL2023.yaml&stackName=AMIDEMO

steps on ec2
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0007-aws-associate-ec2-ami-demo/lesson_commands_AL2023.txt

Instance status checks and recovery : https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0022-aws-associate-ec2-statuschecksandterminateprotection/A4L_VPC_PUBLICINSTANCE.yaml&stackName=STATUSCHECKSANDPROTECT

what will be lost and saved when does auto recovery :
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html
