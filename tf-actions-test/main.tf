
terraform {
  backend "s3" {
    bucket = "husamag-git-actions-test"
    key    = "terraform/state.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "Private subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_instance" "app_server_public" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  subnet_id         = aws_subnet.public_subnet.id
  availability_zone = "us-west-2c"

  tags = {
    Name = "public ec2"
  }
}

resource "aws_instance" "app_server_private" {
  ami               = "ami-08d70e59c07c61a3a"
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.private_subnet.id
  availability_zone = "us-west-2c"
  tags = {
    Name = "private ec2"
  }
}
