# Cloudfront-provisioning-via-terraform
<br />

This GitHub repository provides a Terraform code for setting up an AWS CloudFront distribution with integration to Amazon Route 53, AWS Certificate Manager (ACM), and an S3 bucket. The Terraform code automates the provisioning and configuration process, enabling efficient content delivery, secure communication, and global availability.
The code provisions an S3 bucket as the origin server for CloudFront, where you can store your static or dynamic content. It also utilizes ACM to request and manage SSL/TLS certificates, ensuring secure communication between CloudFront and end-users.By running the Terraform code, a CloudFront distribution is created and configured to use the S3 bucket as the origin. 

Integration with Amazon Route 53 is established by creating DNS records using Terraform. The code enables you to associate your custom domain with the CloudFront distribution, allowing users to access your content using your domain name.

When a user requests content, the CloudFront distribution, powered by its global network of edge locations, delivers the content efficiently. Content is cached at the edge locations, reducing latency and improving performance. ACM certificates are used for SSL/TLS termination, ensuring secure delivery of content over HTTPS.

This GitHub repository provides a streamlined and automated approach to set up AWS CloudFront with Route 53, ACM, and an S3 bucket using Terraform. The code can be easily executed, providing a scalable and robust content delivery solution for your applications or websites.
<br />
![Cloudfront](https://github.com/Chris-luiz-16/Cloudfront-provisioning-via-terraform/assets/128575317/350b8052-1a55-4cd3-b478-2ebb9cb782d5)

## Table of contents
* [Prerequisites](#prerequisites)
  * [Terraform Installation Linux](#terraform-installation-linux)
  * [Git installation](#git-installation)
  * [Ec2-instance-IAM user or role update ](#ec2-instance-iam-user-or-role-update )
* [Customizing based on your needs](#customizing-based-on-your-needs)
* [Execution of the code](#execution-of-the-code)

## Prerequisites
Things to install and note before executing the code

### Terraform Installation Linux
In my case, I'm using an Amazon Linux  ec2-instance and I installed terraform following the ***binary download for Linux AMD64*** in the official doc [Terraform installation setup](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform).
You can choose the download depending on the OS used.
```sh
 wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip
 unzip terraform_1.4.6_linux_amd64.zip
 sudo mv terraform /usr/local/bin/
```
After this, you can confirm whether terraform is installed by checking the terraform version command
```sh
terraform version
```
if all look good it should be displayed like this
```bash
[ec2-user@ip-172-31-41-59 ~]$ terraform version
Terraform v1.4.6
on linux_amd64
```

### Git installation
You can clone my repository in your ec2-instance by following the below-method
```sh
yum install git -y
git clone https://github.com/Chris-luiz-16/Cloudfront-provisioning-via-terraform.git
cd Cloudfront-provisioning-via-terraform
```

### Ec2-instance-IAM user or role update 
Make sure to have an IAM user or role to have the following permissions
```
1. AmazonEC2FullAccess
2. AmazonRoute53FullAccess
3. AmazonS3FullAccess
4. AWSCertificateManagerFullAccess
5. CloudFrontFullAccess
```

## Customizing based on your needs
I have set a variable.tf file where you can mention the name of the domain, access_key/secret_key, path of the website, name of the hosted zone etc. Please add the required fields

```hcl

variable "region" {
description = "Default region where your s3 bucket get's created in my case I've chosen ap-south-1/Mumbai"
  default = "ap-south-1"
}

variable "aws_secret_key" {
  description = "Secret key of IAM User"
  type        = string
  default     = "<Secret Key>"
}
variable "aws_access_key" {
  description = "Access key of the IAM user"
  type        = string
  default     = "Access_key"
}

variable "mime_types" {
  description= "This is to set mime_types for your static website."
  type = map
  default = {
    "css"   = "text/css"
    "html"  = "text/html"
    "ico"   = "image/vnd.microsoft.icon"
    "js"    = "application/javascript"
    "json"  = "application/json"
    "map"   = "application/json"
    "png"   = "image/png"
    "svg"   = "image/svg+xml"
    "txt"   = "text/plain"
    "woff"  = "application/font-woff"
    "woff2" = "application/font-woff2"
    "jpg"   = "image/jpeg"
  }
}

variable "path" {
description = "the Path where your static website is placed in ec2-instance in order to copy to s3 bucket"
default = "/home/ec2-user/<path>"
}

variable "domain_name" {
description = "Domain name that you wish to point to cloudfront endpoint from s3 bucket"
  default = "<name of the domain that needs to point to cloudfront>"
}

variable "hosted_zone" {
descrition = "Hosted_zone name"
  default = "<Name of the hosted zone in route53>"
}
```
You can edit the Endpoint whitelisting in the cloudfront.tf file where you need to mention the country code in ***[ISO 3166-1-alpha-2](https://www.iso.org/obp/ui/#search)*** . I've whitelisted the below regions. You can edit the required countries in cloudfront.tf in line 32.
```hcl
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN"]
    }
  }
```

## Execution of the code

After making the required changes, you can execute the below commands
```sh
terraform init
terraform plan
terraform apply 
```
