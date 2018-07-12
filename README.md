# nodejs-k8s-aws
Here is complete setup steps followed, 

 Before start, please make sure you have installed, GIT, Terraform, kops and kubectl in the box. if not please follow Pre-steps:


# Pre-steps:
To Install required packages, either clone the repo or copy this script and run it.
https://github.com/foxutech/nodejs-k8s-aws/blob/master/installpackages.sh

Once it done, then run https://github.com/foxutech/nodejs-k8s-aws/blob/master/awsenv.sh
to setup aws environment keys and create a IAM user. 

# Step1: Clone the repository

Use git clone to clone the repository

$ git clone https://github.com/foxutech/nodejs-k8s-aws.git

 Once you cloned succuessfully, go to repo directory using 'cd'
 
$ cd nodejs-k8s-aws/aws-infra

Configure AWS credentials using, aws configure command, before run this be prepare with accesskey and secretkey and zone.

$ aws configure


# Step2: Lets Get.Plan.Apply

Once you have all the files in the place, run a "terraform get" to get all the missing modules. 

$ terraform get

then start the plan to make sure, you code and good to go, if any error, it will list it, you can fix before got live. 

$ terraform plan

it will ask the your required region, by default us-east-1. If you can you can change it. Now lets apply

$ terraform apply

Once its succuessful, lets export some environment variables which requireds for setting up kubernetes. and meantime, if you are using public domain don't forget to update NS records on your domain provider like godaddy, bigrock.. 

export NAME=$(terraform output cluster_name)

export KOPS_STATE_STORE=$(terraform output state_store)

export ZONES=us-west-2a,us-west-2b


# Step3: Lets Deploy kubernetes with kops

before start create local ssh key for kops, if there is not any keyfile

$ sudo ssh-keygen

$ sudo kops create cluster --name=stagingxyz.enplaylist.com --master-zones $ZONES --node-count=2 --node-size=t2.micro --zones $ZONES --networking weave --topology private --dns-zone $(terraform output public_zone_id) --vpc $(terraform output vpc_id) --target=terraform --out=. --yes

where, 

     - master-zones: tell Kops that we want one Kubernetes master in each zone in $ZONES. If you are using the default configuration in this post, that will be 3 masters — one each in us-west-2a, us-west-2b, and us-west-2c.
     - zones: tells Kops that our Kubernetes nodes will live in those same availability zones.
     - topology: tells Kops that we want to use a private network topology. Our Kubernetes instances will live in private subnets in each zone.
     - dns-zone: specifies the zone ID for the domain name we registered in Route53. In this example, this is populated from our Terraform output but you can specify the zone ID manually if necessary.
     - networking: we are using weave for our cluster networking in this example. Since we are using a private topology, we cannot use the default kubenet mode.
     - vpc: tells Kops which VPC to use. This is populated by a Terraform output in this example.
     - target: tells Kops that we want to generate a Terraform configuration (rather than its default mode of managing AWS resources directly).
     - out: specifies the output directory to write the Terraform configuration to. In this case, we just want to use the current directory.

What happens, when you this command?

    - Its populate the KOPS_STATE_STORE to S3 bucket with the Kubernetes cluster configuration.
    - Creates several record sets in the Route53 hosted zone for your domain (for Kubernetes APIs and etcd).
    - Create IAM policy files, user data scripts, and an SSH key in the ./data directory.
    - Generating a Terraform configuration for all of the Kubernetes resources. This will be saved in a file called kubernetes.tf.
	
 if you want to deploy kubernetes in your exising subnet, before run 'terraform apply', edit the kubernetes.tf file using kops. mention your existing subnet details. 
 
$ kops edir cluster ${name}
 
Note: There should be one Private type subnet and one Utility (public) type subnet in each availability zone and For the Private subnets, we also need to specify our NAT gateway ID in an egress key.

$ kops update cluster --out=. --target=terraform ${name}

Now, you can goahead and run 

create a new folder and copy kubernetes.tf and data folder to new folder and run following commands

$ sudo mkdir kubernetes

$ terraform init

$ Terraform plan

$ terraform apply

Once its ran succuessfully, in few minutes your kubernetes cluster will be ready. if you get any subnet conflict, make sure there is no IP overlap, to make sure, the range of IP, please use https://www.ipaddressguide.com/cidr, to calculate the IP range.

You can run 

$ kops validate cluster --name ${name}
to check the status of the cluster, once it ready, you can deploy the kubernetes dashboard using following command,

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

to login dashboard, you need login details, to get the login details run, 

$ kops get secrets admin -oplaintext

and to get login URL, 

$ kubectl cluster-info

this will give master and DNS url, use master url with ui extention, will route to the dashboard. 

ex: http://((kubernetes-master-hostname))/ui

Now, you can maintain your cluster using kubernetes dashboard. passwork u can take from kops get secret command. and token too. 

Now, Kubernetes environment is ready. 

# step4: Create docker image

Change to directory 

$ cd Docker-image

lets build a doocker image, 

$ docker build -t nodeapp .

tag and push the docker image to your repo. (you can login to your repo using $docker login)

$ docker tag nodeapp motoskia/nodetodoapp

$ docker push motoskia/nodetodoapp

# step5: Deploy the application

Change to k8s direcoty, and start create the services using following command with each .yaml file. 

$ kubectl create -f mongo-service.yaml

$ kubectl create -f mongo-controller.yaml

$ kubectl create -f web-controller.yaml

$ kubectl create -f web-service.yaml

to make sure run following command, 

$ kubectl get services

$ kubectl get pods
