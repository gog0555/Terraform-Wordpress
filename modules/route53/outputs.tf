output "certificate_arn" {
    value = aws_acm_certificate.cert.arn
}

output "HTTPSlistener_arn" {
    value = aws_lb_listener.HTTPSlistener.arn
}