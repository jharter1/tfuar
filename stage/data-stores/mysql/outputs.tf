output "address" {
    value = aws_db_instance.dby.address
    description = "Connect @ this endpoint"
}

output "port" {
  value = aws_db_instance.dby.port
  description = "The port for listening"
}