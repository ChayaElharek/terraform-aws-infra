# ============================================================
# ROOT MODULE — terraform-aws-infra
# Orquestra todos os módulos: VPC, Security Groups, EC2, ALB
# ============================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Descomente para usar backend remoto (recomendado em produção)
  # backend "s3" {
  #   bucket = "seu-bucket-tfstate"
  #   key    = "infra/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
}

# ─── VPC ────────────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                = var.availability_zones
}

# ─── SECURITY GROUPS ────────────────────────────────────────
module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# ─── EC2 ────────────────────────────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.ec2_sg_id
  instance_count    = var.instance_count
  key_name          = var.key_name
}

# ─── ALB ────────────────────────────────────────────────────
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_sg_id
  target_instance_ids = module.ec2.instance_ids
}
