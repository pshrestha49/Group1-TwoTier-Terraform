output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "Security group ID for the Bastion host"
  value       = aws_security_group.bastion_sg.id
}

output "web_sg_id" {
  description = "Security group ID for web servers"
  value       = aws_security_group.web_sg.id
}
