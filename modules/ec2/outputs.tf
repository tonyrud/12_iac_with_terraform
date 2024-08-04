# output "public_ip" {
#   value = aws_instance.app.public_ip
# }

output "all_public_ips" {
  value = aws_instance.app[*].public_ip
}