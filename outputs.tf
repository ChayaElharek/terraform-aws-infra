# ============================================================
# OUTPUTS — terraform-aws-infra
# ============================================================

output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "ec2_instance_ids" {
  description = "IDs das instâncias EC2"
  value       = module.ec2.instance_ids
}

output "ec2_public_ips" {
  description = "IPs públicos das instâncias EC2"
  value       = module.ec2.public_ips
}

output "alb_dns_name" {
  description = "DNS do Load Balancer — use este endereço para acessar a aplicação"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN do Application Load Balancer"
  value       = module.alb.alb_arn
}
