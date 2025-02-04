Cloudtrail 

AWS CloudTrail features : https://aws.amazon.com/cloudtrail/features/
CloudTrail Pricing : https://aws.amazon.com/cloudtrail/pricing/
CloudWatch Logs Pricing : https://aws.amazon.com/cloudwatch/pricing/

Steps:-
Search for cloudtrail
click on hamberger lines in left top and select trails
click create trail
create a name for it
slect Enable for all accounts in my organization
storage location create new bucket
give name for bucket which is unique globbaly or else put random numbers at the end of predefined name
untick encryption # this we do next time
click on enable cloudwatch logs
and click on new
keep the name as it is
iam role choose new, give a name for the role mycloudtrail_logs_role
On the Events by default management events is selected, which is for like creaing ec2 instnace or any service, deletion of ec2 or any service
when you click on data events then you can filter out for which application you the data events for, but for this we are not choosing any
then click on next and then create trail
wait for some time to get it created
open the new cloudtrail s3 bucket and go inside cloudtrail folder, and explore, here it will take some time to push data so wait

**Cloudtrail is not like real time delivery of logs, it can take 5 minutes to 15 minutes to show the logs**
go to ec2 and create one ec2
then go to cloudwatch
select the latest trail log, and see if you find ec2 event when we created the ec2
you can also do this same when you click the log and select view in logs insight
then click on generate query and type ec2 created, then click on generate, this will generate a query for you
then click on run
it will show which user and what ec2 has been created.
then stop loging the cloudtrail and delte the cloudtrail to stop new charges
and also clean cloudwatch log group and s3

By Default Cloudtrail events can be seen in Cloudtrail then click on Event history
===========================================================================================================================================================================================================================================================================

===========================================================================================================================================================================================================================================================================
S3
Bucket Policy Examples : https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html
S3 Pricing : https://aws.amazon.com/s3/pricing/

s3 static website demo
download the files from 
Demo Files (download and extract) https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0042-aws-mixed-s3-static-website/static_website_hosting.zip
create a bucket with name whateveryoulike.domainname you purchased example:= top10.infomofighters.xyz
upload the files given from above link
remove block public access from the bucket
attach given bucket policy in bucket policy from the downloaded files
go to properties tab then go at the end of scroll and enable static hosting
then go to route53 and create a record to point as an alias to this bucket
now visit the site with dns name or site name
==============================================================================================================================================================

Object versioning in S3
required file : https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0046-aws-mixed-s3versioning/s3_versioning.zip
create the same static website again but this time without adding it to route53, so choose random name globally unique
enable versioning
remove public access check
add bucket policy
add files given above
now access the image online by static web url
now upload the same name file from version 2 folder
now access the website and see the changes
now delete the current version
your data is gone
now enable the show versions
delete the delete marker
now access the website and see the changes
now if you want the older version
click on show version and delete the current file and marker
you will see the older image now
==============================================================================================================================================================

s3 acceleration command diffrence

To test this install aws cli on local machine by following steps
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

Common url to check the online result : https://s3-accelerate-speedtest.s3-accelerate.amazonaws.com/en/accelerate-speed-comparsion.html

aws s3 cp sublime_text_build_4192_x64_setup.exe s3://mytestbucket34234 --profile personal  #this is without acceleration

aws s3 cp sublime_text_build_4192_x64_setup.exe s3://mytestbucket34234 --endpoint-url https://mytestbucket34234.s3-accelerate.amazonaws.com --profile personal  #this is acclerated speed url


observe the diffrence
==============================================================================================================================================================

KMS-demo
go to AWS Key Management Service
create key
choose Symmetric and Encrypt and decrypt then next
put alias as catrobot
choose key management user iamadmin and key usage admin iamadmin the next next and create

For this we are using aws cloudshell , so click on aws cloudshell
once you are in cloudshell run the below commands

echo "find all the doggos, distract them with the yumz" > battleplans.txt

aws kms encrypt \
    --key-id alias/catrobot \
    --plaintext fileb://battleplans.txt \
    --output text \
    --query CiphertextBlob \
    | base64 --decode > not_battleplans.enc 
    
aws kms decrypt \
    --ciphertext-blob fileb://not_battleplans.enc \
    --output text \
    --query Plaintext | base64 --decode > decryptedplans.txt
==============================================================================================================================================================

S3 Object Encryption CSE/SSE # client side encryption and serve side encryption

with sse-s3 which is applied default to s3, here anyone who has full control over s3 in your organization , can see the data and do whatever he wants, also you dont have have the access 
to keys used to encrypt and decrypt, because its managed by aws s3 itself

Instead of this we can use SSE-KMS, where we are creating the key to be used in s3, and we have the permission who can access this key to see the data
KMS key can encrypt data up to 4KB in size
When you try to encrypt data larger than 4 KB with KMS, you'll typically need to use a method like envelope encryption.

With envelope encryption, you:

    Use KMS to generate a data encryption key (DEK).
    Use the DEK to encrypt the large data (this can be done with a symmetric encryption algorithm, like AES-256).
    Encrypt the DEK itself using your KMS key and store it alongside the encrypted data.

This approach ensures that you can handle large datasets while taking advantage of KMS for key management.

https://docs.aws.amazon.com/AmazonS3/latest/user-guide/default-bucket-encryption.html

https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html

https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingKMSEncryption.html

https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerSideEncryptionCustomerKeys.html


==============================================================================================================================================================
In this [DEMO] lesson we create an S3 bucket, and upload 3 images to the bucket using different encryption methods.

After adjusting the permissions of the IAMADMIN user we review what access changes occur, and why.

This DEMO focusses on the role separation aspect of S3 encryption using KMS.

Demo Files (Download and Extract) https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0043-aws-mixed-s3-object-encryption/object_encryption.zip

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Deny",
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}

steps:-
create a random bucket
create a kms key without adding any key administrator and key usage permission 
put objects from downloaded folder 1 by 1 and add encryption key as mentioned in the filename
check and see if you can open these files in the browser
now add kms deny policy to iamadmin account from the above json
now refresh the bucket page and check if you can access the file in browser which has kms key attached for encryption. you wont be able to see that, 
also you wont be able to download it to local
you can also attach this kms key which you have created to whole bucket also
==============================================================================================================================================================

S3 Bucket Keys
https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html

s3 Bucket key Demo
https://docs.aws.amazon.com/AmazonS3/latest/userguide/configuring-bucket-key.html

==============================================================================================================================================================

S3 Object Storage Classes

https://aws.amazon.com/s3/pricing/

https://aws.amazon.com/s3/storage-classes/

S3 LifeCycle Rule Demo

Objects move to Standard-IA - 30
Objects move to One Zone-IA - 60
Objects move to Glacier Flexible Retrieval (formerly Glacier) - 90
Objects move to Glacier Deep Archive - 180

==============================================================================================================================================================

S3 Replication

S3 has two replication features which allow objects to be replicated between SOURCE and DESTINATION buckets in the same or different AWS accounts

================================================
Cross-Region Replication (CRR) is the process used when Source and Destination are in different AWS regions
Demo:-
create 2 buckets in different region
disable public access check box
add bucket policy to allow everyone access the bucket objects
bucket policy
======
{
  "Id": "Policy1738325190613",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1738325189568",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::sourcebucket/*",
      "Principal": "*"
    }
  ]
}
======
enable bucket versioning
enable static site hosting
once this is done, go to Source bucket and add replication Rule to for replicating data to Destination bucket
while rule creation for manifest file location of job choose the source bucket
now add the index.html and image file in source bucket from the downloaded files
wait for some time and see if the data is replicated to Destination bucket

================================================

Same-Region Replication (SRR) is used when the buckets are in the same region.

This lesson introduces the theory, features and limitations of both of these methods.

https://docs.aws.amazon.com/AmazonS3/latest/dev/replication-what-is-isnot-replicated.html

Lesson Links

https://docs.aws.amazon.com/AmazonS3/latest/dev/replication.html

https://aws.amazon.com/about-aws/whats-new/2019/11/amazon-s3-replication-time-control-for-predictable-replication-time-backed-by-sla/

Demo on replication in same AWS account with different Region

Demo On replication between aws accounts pending
https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-configure.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html#object-lock-overview
https://repost.aws/knowledge-center/s3-cross-account-replication-object-lock


==============================================================================================================================================================