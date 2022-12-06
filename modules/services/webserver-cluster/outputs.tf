output "alb_dns_name" {
  value       = aws_lb.balancio.dns_name
  description = "ol LB's domain, my dude"
}

output "asg_name" {
  value       = aws_autoscaling_group.group_1.name
  description = "Name o' the group"
}

output "alb_security_group_id" {
  value       = aws_security_group.albie.id
  description = "The ID of the Security Group attached to the load balancer"
}