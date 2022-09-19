output "aws_lb_public_dns" {
  value = aws_lb.nginx.dns_name
}