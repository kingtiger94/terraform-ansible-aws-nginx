## Show instance IP in the end of build
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.AVG_Ubuntu.public_ip
}
