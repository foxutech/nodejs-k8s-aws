#!/bin/bash

## before start create a user, we need to expose the Access key and secret key of your account
read -rep "Enter your AWS accesskey: \n" accessKey

read -rep "Enter your AWS accesskey: \n" secretKey

export AWS_ACCESS_KEY_ID=$accessKey
export AWS_SECRET_ACCESS_KEY=$secretKey

# create IAM user, group and roles
read -rep "Enter your AWS user: \n" user

aws iam create-group --group-name $user

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name $user
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name $user
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name $user
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name $user
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name $user

aws iam create-user --user-name $user
aws iam add-user-to-group --user-name kops --group-name $user
