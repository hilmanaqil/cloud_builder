
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.linux_ec2.id
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.linux_ec2.private_ip
}

output "public_ip" {
  description = "Public IP address, if enabled"
  value       = aws_instance.linux_ec2.public_ip
}

output "instance_type" {
  value = aws_instance.linux_ec2.instance_type
}

output "availability_zone" {
  value = aws_instance.linux_ec2.availability_zone
}
