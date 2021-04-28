Terraform and Ansible code for create ec2 instance with ubuntu 20.04 and deploy nginx.

Terraform create AWS resources:

* VPC
* Internet_gateway
* LAN
* Subnet
* Route table association
* Security group
* ec2 instance
* s3 to save server state & save server state

After check instance connection- start ansible playbook (~/deploy_nginx/playbook.yml)

Ansible deploy web-server:

1. install Nginx
2. copy config file
 * you can change destination folder in ~/deploy_nginx/defaults
 * source file in ~/deploy_nginx/files


To start:
 set vars in ~/variables.tf to correct creation you AWS resources
run:
 terraform init
 terraform apply

* in the end of build app show you instance IP
