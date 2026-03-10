# ============================================================
# MÓDULO: EC2
# Cria N instâncias com NGINX via user_data
# Distribuídas em subnets diferentes (alta disponibilidade)
# ============================================================

resource "aws_instance" "web" {
  count = var.instance_count

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    instance_index = count.index + 1
    project_name   = var.project_name
    environment    = var.environment
  }))

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name      = "${var.project_name}-vol-${count.index + 1}-${var.environment}"
      ManagedBy = "Terraform"
    }
  }

  tags = {
    Name        = "${var.project_name}-ec2-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
