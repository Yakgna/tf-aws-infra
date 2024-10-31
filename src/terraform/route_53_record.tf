data "aws_route53_zone" "main_domain" {
  name         = "${var.profile}.${var.domain_name}"
  private_zone = false
}

# Add or Update Route 53 A record
resource "aws_route53_record" "webapp_record" {
  zone_id = data.aws_route53_zone.main_domain.zone_id
  name    = "${var.profile}.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.web_app_instance.public_ip]
}