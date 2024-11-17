
######## CREATE ROLES ########

# define and get info on needed policies for both roles
data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "AmazonSSMFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

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

# attach the needed policies to the created ec2 role
resource "aws_iam_role_policy_attachment" "policy-attach-ssm" {
  role       = aws_iam_role.app-server-role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_role_policy_attachment" "policy-attach-ecr-full" {
  role       = aws_iam_role.app-server-role.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn
}

# define instance profile, so we can assign the role to our ec2 instance
# this is needed for the instance to have the permissions
# and will be assigned to the ec2 instance in the ec2 module
# ex
resource "aws_iam_instance_profile" "app-server-role" {
  name = "app-server-role-tf"
  role = aws_iam_role.app-server-role.name
}
