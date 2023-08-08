resource "aws_lb" "elb" {
  name               = "${var.env}-${var.name}-lb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.elbsg.id]
  subnets            = [var.public_subnets[0], var.public_subnets[1]]

  tags = {
    Name = "${var.env}-${var.name}-lb"
  }
}


resource "aws_security_group" "elbsg" {
  name   = "elb"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_target_group" "targetgroup" {
  name     = "${var.env}-${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    path = "${var.health_check_path}"
  }
}


resource "aws_lb_target_group_attachment" "attachment1a" {
  target_group_arn = aws_lb_target_group.targetgroup.arn
  target_id        = var.intance1a_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment1c" {
  target_group_arn = aws_lb_target_group.targetgroup.arn
  target_id        = var.intance1c_id
  port             = 80
}


resource "aws_lb_listener" "HTTPlistener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener_rule" "listenerRule" {
  listener_arn = var.HTTPSlistener_arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}