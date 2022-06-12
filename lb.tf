resource "aws_lb" "web" {
  name               = "web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_lb.id]
  # subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.public_1.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.public_2.id
  }

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  #   tags = {
  #     Environment = "production"
  #   }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  # certificate_arn   = data.aws_acm_certificate.redes.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "web_server_1_lb" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_server_2_lb" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}
