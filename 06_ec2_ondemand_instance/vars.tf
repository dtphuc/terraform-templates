/*
# Retrieves state meta data from a remote backend
*/
data "terraform_remote_state" "01_vpc" {
  backend = "s3"
  config {
    bucket = "tmp-tf-state-s3" # YOUR_BUCKET_NAME
    key = "01_vpc.tfstate"
    region = "ap-southeast-2" # Your region
    encrypt = "true"
    dynamodb_table = "terraform_statelock" # Your DynamoDB table with LockID
  }
}

data "terraform_remote_state" "02_simple_rds_mysql" {
  backend = "s3"
  config {
    bucket = "tmp-tf-state-s3" # YOUR_BUCKET_NAME
    key = "02_simple_rds_mysql.tfstate"
    region = "ap-southeast-2" # Your region
    encrypt = "true"
    dynamodb_table = "terraform_statelock" # Your DynamoDB table with LockID
  }
}

variable "aws_region" {
  default       = "ap-southeast-2"
  description   = "The AWS region you want to launch your services"
}

variable "availability_zone" {
  type = "map"
  default = {
    availability_zone_a = "ap-southeast-2a"
    availability_zone_b = "ap-southeast-2b"
  }
}

variable "aws_access_key" {
  description   = "Type your AWS access key here"
}

variable "aws_secret_key" {
  description   = "Type your AWS secret key here"
}

# Choose the exising AWS key pair in your AWS account
variable "aws_key_name" {
    description = "Enter your AWS keypair name for SSH access"
    default = "sample-keypair"
}

variable "aws_instance_type" {
  description = "Type your EC2 instance type"
  default     = "t2.micro"
}

variable "aws_instance_sg" {
  description = "Type your EC2 security group name"
  default     = "ec2_ondemand_instance_sg"
}

# Search the latest AMI to launch NAT server
data "aws_ami" "ec2_ondemand_instance" {
    most_recent = true

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical

}
