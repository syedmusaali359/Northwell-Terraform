# AWS Infrastructure Service README

This repository contains the infrastructure as code (IAC) definitions and configurations to set up an Amazon ECS cluster with the Fargate launch type, ensuring a serverless container deployment model that doesn't require managing underlying EC2 instances. The infrastructure includes a Virtual Private Cloud (VPC) as the networking foundation, hosting an Amazon Elastic Container Service (ECS) cluster that orchestrates the containerized application nginx. An Application Load Balancer (ALB) serves as a front-facing entry point, distributing incoming traffic to ECS Fargate tasks while maintaining high availability. Security Groups (SG) control traffic flows to and from ECS tasks, maintaining robust security measures. 

## Table of Contents

1. **Infrastructure Overview**
2. **Prerequisites**
3. **Setup Instructions**
4. **Usage**
5. **Cleaning Up**
6. **Resources**

## Infrastructure Overview

The infrastructure in this repository is designed to provide a scalable and reliable environment for hosting a containerized application. It includes the following components:

- **VPC:** A Virtual Private Cloud to isolate the application resources and control networking settings.

- **ECS Cluster:** An ECS cluster to manage and orchestrate containerized applications.

- **ALB:** An Application Load 4. Amazon CloudWatch Documentation Balancer to distribute incoming traffic to the ECS tasks.

- **Security Groups:** Security groups to define inbound and outbound traffic rules for the ECS instances and ALB.


## General Prerequisites:

Before you begin, ensure you have the following prerequisites:

- An AWS account with appropriate permissions to create the required resources.
- AWS Command Line Interface (CLI) installed and configured with your AWS credentials.
- Basic knowledge of AWS services, ECS, ALB and VPC.

## Additional Prerequisites for Advanced Configurations:

- An OIDC Connect Provider set up to enable identity federation and authentication.

- **ROLE TRUST RELATIONSHIPS**
   ```bash
   {
      "Version": "2012-10-17",
      "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Federated": "arn:aws:iam::991108593442:oidc-provider/token.actions.githubusercontent.com"
               },
               "Action": "sts:AssumeRoleWithWebIdentity",
               "Condition": {
                   "StringEquals": {
                       "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                  },
                  "StringLike": {
                       "token.actions.githubusercontent.com:sub": "repo:SkyOps-Dev/*:*"
                  }
               }
            }
      ]
   }

- Assume role configuration for GitHub Action pipeline to securely deploy resources in your AWS environment. Ensure that the   appropriate permission policies are attached to the IAM roles used by your GitHub Actions. These policies should include permissions for:

    - Amazon ECS (ecs:*): Permissions to create and manage ECS clusters, tasks, and services.

    - Amazon VPC (ec2:*): Permissions to create and manage Virtual Private Cloud resources, including subnets and security groups.

    - Elastic Load Balancer (elbv2:*): Permissions to configure and manage Application Load Balancers.

- An Amazon S3 bucket to save the backend state for Terraform or other infrastructure as code (IAC) tools, ensuring state management and collaboration within your infrastructure provisioning process. Permissions for S3 should be appropriately configured for your GitHub Actions pipeline to interact with this bucket. Typically, these permissions include S3 (s3:ListBucket, s3:GetObject, s3:PutObject) for read and write access to the state file.

Make sure that these permission policies are fine-tuned to adhere to the principle of least privilege, granting only the necessary permissions required for your specific deployment process.

## Setup Instructions

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/SkyOps-Dev/ECS.git

2. Ensure you have valid AWS credentials configured either through environment variables, the AWS CLI configuration (aws configure), or using an IAM role if you're running Terraform in an AWS environment.

3. In your terraform working directory, use cd command to go to the directory containing .tf files i.e env

4. Create an S3 bucket where Terraform will store its remote state files. 
   ```bash
   aws s3api create-bucket --bucket ecs-cluster --acl private --region us-east-1

5. Run the terraform init command to initialize your working directory, download the necessary plugins and modules, and configures the backend.

6. Enter the name of state file with .tf extension.

7. After writing your Terraform configuration, run terraform plan. This command analyzes your configuration and shows you what changes Terraform will apply to your infrastructure.

8. Once you're satisfied with the plan, run terraform apply to execute the changes. Terraform will create, modify, or destroy resources as necessary to match your configuration.

9. After applying the changes, verify that the deployed resources are working as expected. Check the AWS Management Console or use the AWS CLI to confirm the status of your resources.

## Usage

After deploying the infrastructure and application, you can access your application by visiting the ALB's DNS name in your web browser. The ALB will distribute traffic to the ECS tasks running your application.

## Cleaning Up

To avoid incurring unnecessary charges, make sure to delete the resources when you're done testing or using the infrastructure.

1. Delete the ECS tasks and services.
2. Delete the ALB and related resources i.e Target groups.
3. Delete the VPC and its associated resources.

## Resources

1. AWS Documentation
2. AWS CLI Documentation
3. Amazon ECS Documentation
