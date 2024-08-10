output "public_ip" {
  value = aws_instance.app.public_ip
}

output "name" {
  value = aws_instance.app.tags.Name
}
