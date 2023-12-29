
# AWS_LB
resource "aws_lb" "nginx" {
  name               = "globo_web_alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet1, aws_subnet.public_subnet2]

  enable_deletion_protection = false


  tags = locals.common_tags
}

# AWS_LB_TARGET_GROUP
resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app.id
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_app_cidr_block
}

# AWS_LB_LISTENER
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }

}

# AWS_LB_TARGET_GROUP_ATTACHMENT
resource "aws_lb_target_group_attachment" "nginx_target_group_attach" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = [aws_instance.nginx1, aws_instance.nginx2]
  port             = 80
}


