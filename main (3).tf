# ============================================================
# MÓDULO: Application Load Balancer (ALB)
# Distribui tráfego entre as instâncias EC2
# Health check automático no endpoint /health
# ============================================================

resource "aws_lb" "main" {
  name               = "${var.project_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false # Mude para true em produção

  tags = {
    Name        = "${var.project_name}-alb-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ─── TARGET GROUP ───────────────────────────────────────────
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "${var.project_name}-tg-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ─── REGISTRA INSTÂNCIAS NO TARGET GROUP ────────────────────
resource "aws_lb_target_group_attachment" "web" {
  count = length(var.target_instance_ids)

  target_group_arn = aws_lb_target_group.web.arn
  target_id        = var.target_instance_ids[count.index]
  port             = 80
}

# ─── LISTENER HTTP:80 ───────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
