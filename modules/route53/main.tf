resource "aws_route53_zone" "hostzone" {
  name = var.my_domain
}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hostzone.zone_id
}

resource "aws_route53_record" "aliasrecord" {
  zone_id = aws_route53_zone.hostzone.zone_id
  name    = var.my_domain
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}



resource "aws_acm_certificate" "cert" {
  domain_name       = aws_route53_zone.hostzone.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certvalidation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}




resource "aws_lb_listener" "HTTPSlistener" {
  load_balancer_arn = var.elb_arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = var.targetgroup_arn
  }

  depends_on = [
    aws_acm_certificate_validation.certvalidation
  ]
}