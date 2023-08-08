output "dns_name" {
    value = aws_lb.elb.dns_name
}

output "zone_id" {
    value = aws_lb.elb.zone_id
}

output "targetgroup_arn" {
    value = aws_lb_target_group.targetgroup.arn
}

output "elb_arn" {
    value = aws_lb.elb.arn
}

output "elbsg_id" {
    value = aws_security_group.elbsg.id
}