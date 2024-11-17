output "app-server-role" {
  description = "The IAM role for the app server"
  value       = aws_iam_role.app-server-role
}