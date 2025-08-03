# IAM Role
resource "aws_iam_role" "secure_agent_role" {
  name = "informatica-secure-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "secrets-manager-access"
  description = "Allow Secure Agent to read Snowflake secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.secure_agent_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "secure_agent_profile" {
  name = "informatica-secure-agent-profile"
  role = aws_iam_role.secure_agent_role.name
}

# EC2 Instance
resource "aws_instance" "secure_agent_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.secure_agent_profile.name

  tags = {
    Name = "Informatica-Secure-Agent"
  }
}

# Secrets Manager Secret
resource "aws_secretsmanager_secret" "snowflake_secret" {
  name = var.secret_name
}

# Secrets Manager Secret Value
resource "aws_secretsmanager_secret_version" "snowflake_secret_value" {
  secret_id     = aws_secretsmanager_secret.snowflake_secret.id
  secret_string = jsonencode({
    username = "snowflake_user",
    password = "snowflake_password",
    account  = "snowflake_account"
  })
} 