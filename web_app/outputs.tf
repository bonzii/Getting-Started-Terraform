output "aws_instance_public_dns" {
  value       = "http://${aws_instance.nginx1.public_dns}"
  description = "Public DNS hostname of EC2 instance"

}
