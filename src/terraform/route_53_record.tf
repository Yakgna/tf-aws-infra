data "aws_route53_zone" "main_domain" {
  name         = "${var.profile}.${var.domain_name}"
  private_zone = false
}

# Route 53 A Record for Load Balancer
resource "aws_route53_record" "webapp_record" {
  zone_id = data.aws_route53_zone.main_domain.zone_id
  name    = "${var.profile}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.csye6225_lb.dns_name
    zone_id                = aws_lb.csye6225_lb.zone_id
    evaluate_target_health = true
  }
}