#!/bin/bash


# Check if the script is run as root, if not, switch to root
if [ "$(id -u)" -ne 0 ]; then
    echo "You are not root. Switching to root..."
    "$0" "$@"
    exit 0
fi


# Update apt and install necessary dependencies
apt update
apt install -y fontconfig openjdk-17-jre

# Add Jenkins repository and install Jenkins
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y jenkins

# Download and install Apache Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
tar -xvzf apache-maven-3.9.9-bin.tar.gz -C /opt
mv /opt/apache-maven-3.9.9-bin.tar.gz /opt/maven

# Add Docker's official GPG key:
apt-get update -y
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Install Ansible
apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible


# Add Jenkins user to the Docker group and restart Jenkins
usermod -aG docker jenkins
service jenkins restart

# Allow Jenkins user to run without a password
echo -e 'jenkins  ALL=(ALL)  NOPASSWD:  ALL' | tee /etc/sudoers.d/jenkins > /dev/null

# Install Containerd
wget https://raw.githubusercontent.com/lerndevops/labs/master/scripts/installContainerd.sh -P /tmp
bash /tmp/installContainerd.sh
systemctl restart containerd.service

# Install Kubernetes
wget https://raw.githubusercontent.com/lerndevops/labs/master/scripts/installK8S.sh -P /tmp
bash /tmp/installK8S.sh

# Initialize Kubernetes cluster
kubeadm init --ignore-preflight-errors=all
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Apply Calico CNI for Kubernetes
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml

echo "MAVEN_HOME=\"/opt/maven\"" >> /etc/profile
echo "PATH=\$MAVEN_HOME/bin:\$PATH" >> /etc/profile
echo "JAVA_HOME=\"/usr/lib/jvm/java-17-openjdk-amd64\"" >> /etc/profile
echo "PATH=\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$PATH" >> /etc/profile
source /etc/profile
echo $JAVA_HOME
echo $MAVEN_HOME

echo "Installation complete!"
