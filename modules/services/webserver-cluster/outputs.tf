output "port_address" {
  description = "descriptions are good for your teammates"
  value       = var.server_port
}

output "alb_dns_name" {
  value       = aws_lb.balancio.dns_name
  description = "ol LB's domain, my dude"
}