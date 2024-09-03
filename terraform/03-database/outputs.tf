
# expor o endpoint para o banco de dados
output "database_endpoint" {
  value = aws_rds_cluster.postgresql.endpoint
}

# expor o nome do banco
output "database_name" {
  value = var.db_name
}

# expor o username do banco
output "database_username" {
  value = var.db_user
}

output "database_port" {
  value = aws_rds_cluster.postgresql.port
}

output "database_kms_key_id" {
  value = aws_kms_key.this.key_id
}

output "database_kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "database_password_secret" {
  value = aws_rds_cluster.postgresql.master_user_secret
}



