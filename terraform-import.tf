
Create a VPC from UI in awscloud: Mandatory value : IPv4 CIDR
Create a EC2 instance , install terraform and export access key and secret key over the machine.
mkdir test
cd test
cat main.tf 
provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
}

terraform init
terraform import aws_vpc.vpc vpc-0082b3c1a3f75caa3
terraform tfstate file will be created ,now we can manage VPC from terraform code itself .
Changing the param enable_dns_hostnames to true,previously it was false .

provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

