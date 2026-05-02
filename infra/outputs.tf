output "alb_dns" {
  value = aws_lb.app.dns_name
}

output "api_url" {
  value = "https://api.test-iitc.site"
}

output "frontend_url" {
  value = "https://test-iitc.site"
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.frontend.id
}
