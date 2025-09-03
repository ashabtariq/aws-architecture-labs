output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.SecurityLab.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.PublicSubnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.PrivateSubnet.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.SecurityLabIGW.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = aws_nat_gateway.NatGW.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.PublicRTB.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.PrivateRTB.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.ec2_lab.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.ec2_lab.public_dns
}

