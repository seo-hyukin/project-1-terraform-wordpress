
output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "Application Load Balancer URL"
}

output "rds_endpoint" {
  value       = aws_db_instance.default.endpoint
  description = "RDS Endpoint"
}