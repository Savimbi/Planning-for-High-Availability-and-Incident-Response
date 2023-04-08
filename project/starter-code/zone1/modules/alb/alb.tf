resource "aws_lb" "udacity_alb" {
  name               = "udacity-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.subnet_id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "udacity_tg" {
  name     = "udacity-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "udacity_tg_att" {
  count            = 3
  target_group_arn = aws_lb_target_group.udacity_tg.arn
  target_id        = var.ec2.*.id[count.index]
  port             = 80
}

resource "aws_lb_listener" "udacity_listener" {
  load_balancer_arn = aws_lb.udacity_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.udacity_tg.arn
  }
}