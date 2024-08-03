output "instance_ids" {
  description = "IDs of the created instances"
  value       = aws_instance.mongodb[*].id
}

output "public_ips" {
  description = "Public IPs of the created instances"
  value       = aws_instance.mongodb[*].public_ip
}
