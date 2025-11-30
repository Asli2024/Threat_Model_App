resource "aws_lb" "this" {
  name                       = trimspace(var.environment) != "" ? "English-Somali-ALB-${var.environment}" : "English-Somali-Dictionary-ALB"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.private_subnet_ids
  drop_invalid_header_fields = true
}

resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    protocol            = var.target_group_protocol
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
