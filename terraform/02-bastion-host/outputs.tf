# configuration security_group_id to upload the database
output "security_group_id" {
  value = aws_security_group.this.id
}