resource "aws_ecr_repository" "java-app" {
  name = "java-maven-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}