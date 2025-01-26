#!/bin/bash

# DBName=database name for wordpress
# DBUser=mariadb user for wordpress
# DBPassword=password for the mariadb user for wordpress
# DBRootPassword = root password for mariadb

# STEP 1 - Configure Authentication Variables
DBName='a4lwordpress'
DBUser='a4lwordpress'
DBPassword='4n1m4l$L1f3'
DBRootPassword='4n1m4l$L1f3'

# STEP 2 - Install system software - including Web and DB
echo "Installing required packages..."
sudo dnf install wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel -y

# STEP 3 - Web and DB Servers Online - and set to startup
echo "Enabling and starting Apache and MariaDB..."
sudo systemctl enable httpd
sudo systemctl enable mariadb
sudo systemctl start httpd
sudo systemctl start mariadb

# STEP 4 - Set Mariadb Root Password
echo "Setting MariaDB root password..."
sudo mysqladmin -u root password $DBRootPassword

# STEP 5 - Install WordPress
echo "Downloading and extracting WordPress..."
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .
sudo rm -R wordpress
sudo rm latest.tar.gz

# STEP 6 - Configure WordPress
echo "Configuring WordPress..."
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php   
sudo chown apache:apache * -R

# STEP 7 - Create WordPress DB
echo "Creating WordPress database..."
echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup

# STEP 8 - Final Instructions
echo "WordPress setup complete!"
echo "Browse to http://your_instance_public_ipv4_ip to complete WordPress installation."

# STEP 9 - Install cowsay and configure MOTD
echo "Installing cowsay..."
sudo dnf install -y cowsay

# Display a cow message
cowsay "oh hi"

# Creating custom MOTD with cowsay
echo "Creating custom MOTD with cowsay..."
echo -e "#!/bin/sh\ncowsay \"Amazon Linux 2023 AMI - Animals4Life\"" | sudo tee /etc/update-motd.d/40-cow > /dev/null

# Set appropriate permissions for the script
sudo chmod 755 /etc/update-motd.d/40-cow

# Update MOTD
sudo update-motd

# Reboot the system
echo "Rebooting the system..."
sudo reboot

# STEP 10 - Create AMI
# Note: You would need to manually create an AMI in the AWS Console or via AWS CLI after the instance is set up.
echo "AMI Creation: You can create an AMI from this instance using the AWS Management Console or AWS CLI after reboot."

# STEP 11 - Launch New Instance Using AMI
# Note: You can launch a new EC2 instance from the created AMI using the AWS Console or AWS CLI.
echo "To launch a new EC2 instance using the created AMI, you can use the AWS Console or AWS CLI."

# End of script
