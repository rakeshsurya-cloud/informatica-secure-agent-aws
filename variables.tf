variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type fterraformor Informatica Secure Agent"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) for EC2 instance"
  default     = "ami-0abcdef1234567890" # Replace with a real AMI
}

variable "secret_name" {
  description = "Name of the Snowflake credentials secret"
  default     = "SnowflakeCredentials"
}
