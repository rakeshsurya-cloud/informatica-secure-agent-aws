output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.secure_agent_ec2.public_ip
}

output "secret_arn" {
  description = "ARN of the Snowflake secret"
  value       = aws_secretsmanager_secret.snowflake_secret.arn
}
