output "intance1a_id" {
    value = aws_instance.instance1a.id
}

output "intance1c_id" {
    value = aws_instance.instance1c.id
}

output "ec2sg_id" {
    value = aws_security_group.ec2sg.id
}