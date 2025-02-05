Creating 'container of cats' Docker Image
CFN link :- https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0030-aws-associate-ec2docker/ec2docker_AL2023.yaml&stackName=EC2DOCKER
Docker commands to be used:-
# Install Docker Engine on EC2 Instance
sudo dnf install docker
sudo service docker start
sudo usermod -a -G docker ec2-user

LOGOUT and login

sudo su - ec2-user

# Build Docker Image
cd container
docker build -t containerofcats .
docker images --filter reference=containerofcats

# Run Container from Image
docker run -t -i -p 80:80 containerofcats

# Upload Container to Dockerhub (optional)
docker login --username=YOUR_USER
docker images
docker tag containerofcats cmkh/testing-repo:containerimage
docker push cmkh/testing-repo:containerimage
docker stop runningcontainerid or name
docker system prune -a
press y

now the images are gone which you have created by dockerfile
go and check in dockerhub if the image is pushed

now we will not build the image from dockerfile, instead we will use the same image which we pushed
docker run -d -p 80:80 cmkh/testing-repo:containerimage
access the public ip and check

=========================================================================================================================================================================================================================

https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html

https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_TaskDefinition.html
=========================================================================================================================================================================================================================

=============================================================================================================
Amazon Elastic Container Service using Fargate - steps

go to ecs
then create cluster first
if first time it fails do the same thing again, becuase when you use ecs first time it goes for authorization at the backend to aws
then create the task defination :-

put any name for ( Task definition family) example allthecats
infrastructure requirement use aws fargate which is auto selected
then choose linux 64 , cpu = .5 and memory = 1gb

on the container details name:
name = allthecatscontainer
image = your public image pushed to dockerhub ------------> cmkh/testing-repo:containerimage
leave port as it is becuase we are just using plain 80 request. if your image is exposed to some other port then choose that
uncheck Use log collection
and then scroll down and click create

now go to your cluster
click on tasks
run new task
Compute options = launch type
Launch type = fargate and platform version = latest
Deployment configuration .......> Application type..............> task
Family = select the family from drop down which you have created in the task defination
revision = 1
then in networking choose the new SG and add port 80 to allow from anywhere
keep the public ip turned on
and then hit create
now if you have selecte 4 number in containers then 4 container will come up with the same image
now go and check the public ip of any container and browse, you image will load

after demo - delete all the resources

=============================================================================================================
https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html

https://docs.aws.amazon.com/eks/latest/userguide/fargate.html

=============================================================================================================
Bootstrapping Wordpress - 
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0010-aws-associate-ec2-bootstrapping-with-userdata/A4L_VPC.yaml&stackName=BOOTSTRAP

script for EC2 user data:-
=======
#!/bin/bash -xe

# STEP 1 - Setpassword & DB Variables
DBName='a4lwordpress'
DBUser='a4lwordpress'
DBPassword='4n1m4l$4L1f3'
DBRootPassword='4n1m4l$4L1f3'

# STEP 2 - Install system software - including Web and DB
dnf install wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel cowsay -y
# STEP 3 - Web and DB Servers Online - and set to startup
systemctl enable httpd
systemctl enable mariadb
systemctl start httpd
systemctl start mariadb
# STEP 4 - Set Mariadb Root Password
mysqladmin -u root password $DBRootPassword
# STEP 5 - Install Wordpress
wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz
cp -rvf wordpress/* .
rm -R wordpress
rm latest.tar.gz
# STEP 6 - Configure Wordpress
cp ./wp-config-sample.php ./wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
# Step 6a - permissions 
usermod -a -G apache ec2-user   
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
# STEP 7 Create Wordpress DB
echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup
# STEP 8 COWSAY
echo "#!/bin/sh" > /etc/update-motd.d/40-cow
echo 'cowsay "Amazon Linux 2023 AMI - Animals4Life"' >> /etc/update-motd.d/40-cow
chmod 755 /etc/update-motd.d/40-cow
update-motd
=======
lesson commands:
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/user-data/

https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0010-aws-associate-ec2-bootstrapping-with-userdata/A4L_VPC_PUBLICINSTANCE_AL2023.yaml&stackName=BOOTSTRAPCFN       ...............> **view this template where in template itself we are providing the user data**

=============================================================================================================

**CFN-INIT and CFN Creation Policies**
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0033-aws-associate-cfninit/A4L_VPC_v2.yaml&stackName=A4LVPC

https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0033-aws-associate-cfninit/A4L_EC2_CFNINITWordpress_AL2023.yaml&stackName=A4LEC2CFNINIT

lesson commands:-
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/user-data/


=============================================================================================================
