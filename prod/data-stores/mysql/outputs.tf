output "address" {
    value = aws_db_instance.dbx.address
    description = "Connect @ this endpoint"
}

output "port" {
  value = aws_db_instance.dbx.port
  description = "The port for listening"
}