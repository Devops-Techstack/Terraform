resource "aws_iam_user" "example" {
  count = 3
  name  = "devops"
}

for (i = 0; i < 3; i++) {
  resource "aws_iam_user" "example" {
    name = "devops.${i}" 
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "example" {
  count = 3  
  name  = "devops.${count.index}"
}


variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["devops", "test", "test1"]  
}

for (i = 0; i < 3; i++) {
  resource "aws_iam_user" "example" {
    name = vars.user_names[i]
  }
}

resource "aws_iam_user" "example" {
  count = length(var.user_names) 
  name  = var.user_names[count.index]
}


output "first_arn" {
  value       = aws_iam_user.example[0].arn
  description = "The ARN for the first user"
}

output "all_arns" {
  value       = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}



resource "aws_instance" "example" {
  ami                    = "ami-0fb653ca2d3203ac1"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}
