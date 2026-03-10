# ============================================================
# VARIÁVEIS GLOBAIS — terraform-aws-infra
# ============================================================

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "chaya-infra"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O ambiente deve ser: dev, staging ou prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para subnets públicas (uma por AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Zonas de disponibilidade a serem usadas"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro" # Free tier eligible
}

variable "ami_id" {
  description = "ID da AMI (Amazon Linux 2 us-east-1)"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_count" {
  description = "Número de instâncias EC2 a criar"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Nome do Key Pair SSH para acesso às instâncias (deve existir na AWS)"
  type        = string
  default     = ""
}
