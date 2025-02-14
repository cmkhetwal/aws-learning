Lamda
1-Click Deployment
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0024-aws-associate-lambda-eventdrivenlambda/twoec2instances.yaml&stackName=TWOEC2

Create LamdaRole with start and stop ec2 services -- create new role and select lambda server then create
now add the inline policy mentioned below to this role

permission:-
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Start*",
                "ec2:Stop*"
            ],
            "Resource": "*"
        }
    ]
}
===============



https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0024-aws-associate-lambda-eventdrivenlambda/lambdarole.json

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0024-aws-associate-lambda-eventdrivenlambda/
01_lambda_instance_stop.py

create a lamda function to stop the servers and add the code mentioned below:
then add both ec2 id in variable
then do test
it will stop the servers

Stop.py code:-
======
import boto3
import os
import json

region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    instances=os.environ['EC2_INSTANCES'].split(",")
    ec2.stop_instances(InstanceIds=instances)
    print('stopped instances: ' + str(instances))
======

https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0024-aws-associate-lambda-eventdrivenlambda/02_lambda_instance_start.py

Here so the same as above but to start just keep the first ec2 id in variable
start.py code:-
=============
import boto3
import os
import json

region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    instances=os.environ['EC2_INSTANCES'].split(",")
    ec2.start_instances(InstanceIds=instances)
    print('started instances: ' + str(instances))
==============


https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0024-aws-associate-lambda-eventdrivenlambda/03_lambda_instance_protect.py

Now create the protect function, which will not let first server to be stopped, so when the server is stopped it will auto start the server by this function

protect.py code :-
=============
import boto3
import os
import json

region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    instances=[ event['detail']['instance-id'] ]
    ec2.start_instances(InstanceIds=instances)
    print ('Protected instance stopped - starting up instance: '+str(instances))

=============

Now at amazon event bridge create a rule to start the first ec2 when that instance is stopped.
event source - AWS events or EventBridge partner events
use pattern form 
event source - aws service
aws service - ec2
event type - state change notification
specified state - stopped
specific instance - first server id


target type - aws service
select a target - lambda function
target this account
select the function - protect-ec2
click create a rule

==============

second rule to stop all ec2 at specific time
ec2 stop rule
and selct schedule
schedule patter reccuring
target detail - lamda
lamda function- stop-ec2
in role - select create a new role

=====================================
