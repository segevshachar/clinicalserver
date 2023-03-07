
resource "aws_lb_listener" "listener_https" {
  certificate_arn = var.acm_arn

  default_action {
    order            = "1"
    target_group_arn = aws_lb_target_group.tg-server.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

  tags = {
    Name        = "${var.environment}-lb-listener-https",
    Environment = var.environment,
    Automation  = "Terraform"
  }
}

resource "aws_lb_listener" "listener_http" {
  default_action {
    order = "1"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

    type = "redirect"
  }

  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  tags = {
    Name        = "${var.environment}-lb-listener-http",
    Environment = var.environment,
    Automation  = "Terraform"
  }
}

