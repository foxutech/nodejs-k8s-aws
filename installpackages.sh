#!/bin/bash
sudo apt update
sudo apt install -y awscli git unzip

## Installing Terraform
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip -d /usr/local/bin

## installing kops
curl -LO https://github.com/kubernetes/kops/releases/download/1.9.1/kops-linux-amd64
chmod +x kops-linux-amd64
mv ./kops-linux-amd64 /usr/local/bin/kops

## installing Kubectl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list 
sudo apt update
sudo apt install -y kubelet kubeadm kubectl kubernetes-cni

## brfore start create a user, we need to expose the Access key and secret key of your account
printf "Enter your AWS access key"
read accesskey

printf "Enter your AWS secret key"
read secretKey

export AWS_ACCESS_KEY_ID=$accessKey
export AWS_SECRET_ACCESS_KEY=$secretKey

# create IAM user, group and roles
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops

aws iam create-user --user-name kops
aws iam add-user-to-group --user-name kops --group-name kops
