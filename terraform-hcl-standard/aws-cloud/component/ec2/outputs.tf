output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "keypair_name" {
  description = "KeyPair name used for the instance"
  value       = module.keypair.keypair_name
}

output "security_group_id" {
  description = "Security Group ID attached to the EC2 instance"
  value       = module.sg.sg_id
}
