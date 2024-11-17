
######## CREATE ROLES ########

# create role for ec2 service for app-server
resource "aws_iam_role" "app-server-role" {
  name = "app-server-role-tf"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
}

# define instance profile, so we can assign the role to our ec2 instance
# this is needed for the instance to have the permissions
# and will be assigned to the ec2 instance in the ec2 module
resource "aws_iam_instance_profile" "app-server-role" {
  name = "app-server-role-tf"
  role = aws_iam_role.app-server-role.name
}
