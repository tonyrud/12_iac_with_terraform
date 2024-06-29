output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app-image-repo.repository_url
}