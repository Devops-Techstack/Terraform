terraform {
    backend "s3" {
      # Replace this with your bucket name!
      bucket         = "ddevops-techstack21"
      key            = "global/s3/terraform.tfstate"
      region         = "us-east-2"

      # Replace this with your DynamoDB table name!
      dynamodb_table = "ddevops-techstack21"
      encrypt        = true
    }
  }

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  tags = {
    Name = "devops-techstack"
  }
}
