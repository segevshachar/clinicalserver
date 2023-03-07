output "aws_security_group_id" {
  value = aws_security_group.sg.id
}

output "default_aws_security_group_id" {
  value = aws_security_group.default.id
}
