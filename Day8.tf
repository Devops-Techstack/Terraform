Loops with for_each expressions:
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  for_each = <COLLECTION> ======= Map or set (List not supported)

  [CONFIG ...]    === Within config we can use each.key or each.value to access the key and value of current item in collection .
}


variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["test", "test1", "test2"]
}


#Create three IAM user using for_each
resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)  
  name     = each.value   
}

It now become map of resources instead of just one resource while using count .
output "all_users" {
  value = values(aws_iam_user.example)[*].arn
}

===============

variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  target_group_arns    = [aws_lb_target_group.asg.arn]
  health_check_type    = "ELB"

  min_size = var.min_size
  max_size = var.max_size
  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

Loops with for expressions

variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["test", "test1", "test2"]
}

names = ["test", "test1", "test289076"]
upper_case_names = []
for name in names:
    upper_case_names.append(name.upper())

print upper_case_names

output "upper_names" {
  value = [for name in var.names : upper(name)]  ==> test ,test1,test2 ===>TEST,TEST1,TEST2
}

output "short_upper_names" {
  value = [for name in var.names : upper(name) if length(name) < 5]
}

variable "devops-techstack" {
  description = "map"
  type        = map(string)
  default     = {
    test      = "hi"
    test1  = "devops"
    test2 = "techstack"
  }
}
output "name" {
  value = [for name, role in var.devops-techstack : "${name} is the ${role}"] ==>echo $VARIABLE ===>test is the hi , test1 is the devops ,
}

======================
Conditionals with the count parameter
variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
  default     = false

}


provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
  count = var.enable_autoscaling ? 1 : 0
  bucket = "devops-techstack"
 
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

If-else:

resource "aws_iam_user_policy_attachment" "full_access" {
  count = var.give_test_ec2_full_access ? 1 : 0

  user       = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.ec2_full_access.arn
}

resource "aws_iam_user_policy_attachment" "read_only" {
  count = var.give_test_ec2_full_access ? 0 : 1

  user       = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.ec2_read_only.arn
}

