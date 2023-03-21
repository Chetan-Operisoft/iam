provider "aws" {
    region = "ap-south-1"
}

resource "aws_iam_user" "newuser" {
    name = "chetan"
}

resource "aws_iam_user_login_profile" "administrator" {
  user                    = aws_iam_user.newuser.name
  password_reset_required = false
}

resource "aws_iam_policy" "policy1" {
  name        = "AmazonEC2FullAccess"
  description = "A ec2 policy"
  policy      = "${file("ec2fullaccess.json")}"
}

resource "aws_iam_policy" "policy2" {
  name        = "regionrestriction"
  description = "A region-wise restriction policy"
  policy      = "${file("regionrestriction.json")}"
}

resource "aws_iam_policy_attachment" "policies" {
    count = length(var.policy_arn)

    policy_arn = var.policy_arn[count.index]
    users      = [aws_iam_user.newuser]
}

variable "policy_arn" {
    type = list(string)
    default = [
        aws_iam_policy.policy1.arn,
        aws_iam_policy.policy2.arn,
    ]
}


resource "aws_iam_access_key" "example" {
  user = aws_iam_user.newuser.name
}



