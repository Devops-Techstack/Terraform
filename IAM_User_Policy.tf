
provider "aws" {
  region = "us-east-2"
}
resource "aws_iam_user" "lb" {
  count = length(var.username)
  name = element(var.username,count.index)
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_policy" "policy" {
  name        = "random-policy"
  description = "My test policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]

}
EOT
}
resource "aws_iam_user_policy_attachment" "attachment" {
  count = length(var.username)
  user       = aws_iam_user.lb[count.index].name
  policy_arn = aws_iam_policy.policy.arn
}
