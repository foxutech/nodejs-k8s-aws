#!/bin/bash
sudo apt update
sudo apt install -y awscli git unzip
curl -LO https://github.com/kubernetes/kops/releases/download/1.9.1/kops-linux-amd64
chmod +x kops-linux-amd64
mv ./kops-linux-amd64 /usr/local/bin/kops

## Installing Terraform
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip -d /usr/local/bin


## installing Kubectl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list 
sudo apt update
sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
