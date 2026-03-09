# -----------------------------------------------
# outputs.tf
# Exposes key resource values after apply.
# Useful for referencing infrastructure details
# without digging through the AWS console.
# -----------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host - use this to SSH in"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = aws_instance.bastion.id
}

output "bastion_security_group_id" {
  description = "Security group ID attached to the bastion host"
  value       = aws_security_group.bastion.id
}

output "private_security_group_id" {
  description = "Security group ID for private subnet resources"
  value       = aws_security_group.private.id
}
