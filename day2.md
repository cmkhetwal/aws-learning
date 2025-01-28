=======================================================================================================
IAM

Explicit deny always win. suppose same policy has allow and deny then deny will be applied.

5000 iam users per account

iam user can be a member of 10 groups

for like internet application where we have millions of users there we use identity fedration services, login with google,facebook,twitter

fedration links:-
https://aws.amazon.com/identity/federation/

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html



==============================================================================================================================================================================================================================================================================
**Simple Identity Permissions in AWS demo**

first demo manually for creating user and giving permission

cloudformation for iam user and permission
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0052-aws-mixed-iam-simplepermissions/demo_cfn.yaml&stackName=IAM

files and permission for below demo
https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0052-aws-mixed-iam-simplepermissions/simpleidentitypermissions.zip
For Deny permission steps:-
click on add permission
click on add permission
click on attach policies directly
filter type choose customer managed
select AllowAllS3ExceptCats permission which is created by Cloudformation and apply
Now go and check wether sally can access cats buckets


first attach full s3 access then check the upload and delete

then remove full permission and attach the policy created by cloudformation which is AllowAllS3ExceptCats

then cats bucket is denied and other buckets are allowed

before stack deletion empty the buckets and remove attached policy from the user

==============================================================================================================================================================================================================================================================================


all 5000 users can be part of a single group

we can not have nested groups in aws, only one group and assign permissions to it

we assign direct permissions to a group, it can not be refrenced in any service or policy, like if a attach a policy in s3, in that s3 policy i can not refrence group,  like i can refrence user with its arn

==============================================================================================================================================================================================================================================================================
**Permissions control using IAM Groups Demo:-**
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0023-aws-associate-iam-groups/groupsdemoinfrastructure.yaml&stackName=IAMGROUPS

demo file link : https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0023-aws-associate-iam-groups/permissionsgroups.zip

steps:-
first attach the permission direct to sally
then check the permissions on s3
upload the files from downloaded zip
then remove the direct permission from sally
then create a group called developers
then attach the same policy to this group
then add sally to this group

cleaning
remove the policy from group
remove the group
empty the buckets

=====================================================================================================================================
roles:-
service linked roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html

for service linked role practical:-
create an ec2 instance
create s3 bucket and put some data in it
create a role for ec2 to have full s3 access
attach this role to ec2 machine
install aws cli to ec2 instance

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

run aws s3 ls command to check if we can access the bucket

to create bucket via this role
aws s3api create-bucket --bucket my-dumy-bucket-for-training-10131013 --region us-east-1 
above command will create the bucket

this time we have not configured any aws credentials in ec2, ec2 is accessing the s3 by service linked role
==================================================================================================================================
organisation accounts : https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html

for this we join many aws accounts to single master account
this can be used like if our finance departments wants to clear all payments for our 100 aws account, they do not want to login to each account and pay the payment.
so here they will login once in master then access all other accounts within this account

for this first login to devops account using iam user iamadmin
then go to aws organizations
select existing aws account
add prod account id and send invite

then go to prod aws account and go to aws organizations
accept the invitation
then go to iam and create role for aws account with full administrator access
in the role add account id of devops account and permission to full administrator

now go back to iamadmin account of devops/master aws account
from the right top select switch role
add the account id of prod-aws account
add ( OrganizationAccountAccessRole ) in the role block
name the account whatever you wish to call
choose the color
then click on switch role

now you are in prod-aws account with full permissions
test and verify you can do whatever you want
then click on switch back from the right top menu to go back to iamadmin account of master account
========================================================================================================================================

Service Control Policies- demo

first add the aws account in your organization like above
then select the root check box and click on actions then click create new OU
name it like prod
then select the check box of prod account then click on actions and then click on move
now select the prod ou to confirm the move

now select policies from left and click on service control policies
now click on enable service control policies
then create new policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
save it
then click on aws prod account and click on policies
click on attach policy that you have created and remove the previous attached policy

now switch role to prod account and you will not be able to do anything in s3
==========================================================================================================







