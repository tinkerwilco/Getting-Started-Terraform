##################################################################################
# DATA
##################################################################################

data "aws_elb_service_account" "root" {}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_lb" "nginx" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
  access_logs {
    bucket  = module.web_app_s3.bucket_object.id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

## aws_lb_target_group
resource "aws_lb_target_group" "nginx" {
  name     = "${local.name_prefix}-lbtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  tags = local.common_tags
}

## aws_lb_listener
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}

## aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.aws_instance_count[terraform.workspace]
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx-instances[count.index].id
  port             = 80
}
