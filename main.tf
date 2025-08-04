# IAM Role for Secure Agent
resource "aws_iam_role" "secure_agent_role" {
  name = "informatica-secure-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy to allow Secrets Manager access
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "secrets-manager-access"
  description = "Allow Secure Agent to read secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["secretsmanager:GetSecretValue"],
      Resource = [
        aws_secretsmanager_secret.snowflake_secret.arn,
        aws_secretsmanager_secret.infa_token_secret.arn
      ]
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.secure_agent_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "secure_agent_profile" {
  name = "informatica-secure-agent-profile"
  role = aws_iam_role.secure_agent_role.name
}

# EC2 Instance
resource "aws_instance" "secure_agent_ec2" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.secure_agent_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y unzip wget

              echo "Downloading Informatica Secure Agent installer..."
              wget -O SecureAgent_Linux64.bin "${var.infa_installer_url}"

              chmod +x SecureAgent_Linux64.bin

              echo "Running Secure Agent installer..."
              ./SecureAgent_Linux64.bin -i silent \
                  -VLICENSE_KEY="${var.informatica_agent_token}" \
                  -VUSER_EMAIL="${var.informatica_user}" \
                  -VPASSWORD="${var.informatica_password}"

              echo "Secure Agent installation completed."
              EOF

  tags = {
    Name = "Informatica-Secure-Agent"
  }
}

# Snowflake Secret in Secrets Manager
resource "aws_secretsmanager_secret" "snowflake_secret" {
  name = var.snowflake_secret_name
}

resource "aws_secretsmanager_secret_version" "snowflake_secret_value" {
  secret_id     = aws_secretsmanager_secret.snowflake_secret.id
  secret_string = jsonencode({
    username = var.snowflake_username,
    password = var.snowflake_password,
    account  = var.snowflake_account
  })
}

# Informatica Agent Token Secret
resource "aws_secretsmanager_secret" "infa_token_secret" {
  name = var.infa_token_secret_name
}

resource "aws_secretsmanager_secret_version" "infa_token_secret_value" {
  secret_id     = aws_secretsmanager_secret.infa_token_secret.id
  secret_string = jsonencode({
    token = var.informatica_agent_token
  })
}
