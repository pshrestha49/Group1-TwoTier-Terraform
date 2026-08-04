output "website_url" {
  description = "URL to access the website via ALB"
  value       = "http://${module.alb.alb_dns_name}"
}
