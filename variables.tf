variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type for Informatica Secure Agent"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) for EC2 instance"
  default     = "ami-054b7fc3c333ac6d2"
}

variable "infa_cloud_url" {
  description = "Base URL for Informatica Cloud downloads"
  type        = string
}

variable "infa_installer_path" {
  description = "Path for Informatica Secure Agent installer"
  type        = string
}

variable "informatica_agent_token" {
  description = "Informatica Secure Agent installation token"
  type        = string
  sensitive   = true
}

variable "informatica_user" {
  description = "Informatica user name for Secure Agent installation"
  type        = string
  sensitive   = true
}

variable "informatica_password" {
  description = "Informatica user password for Secure Agent installation"
  type        = string
  sensitive   = true
}

variable "snowflake_secret_name" {
  description = "Name of the Snowflake credentials secret"
  default     = "SnowflakeCredentials"
}

variable "snowflake_username" {
  description = "Snowflake username"
  type        = string
  sensitive   = true
}

variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
  sensitive   = true
}

variable "snowflake_account" {
  description = "Snowflake account identifier"
  type        = string
}

variable "infa_token_secret_name" {
  description = "Name of the Informatica Agent token secret"
  default     = "InformaticaAgentToken"
}

variable "infa_installer_url" {
  description = "Pre-signed URL of Informatica Secure Agent installer"
  type        = string
}

variable "key_name" {
  description = "Name of the existing EC2 key pair to allow SSH access"
  type        = string
}
