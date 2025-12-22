variable "engine" {
  description = "Database engine"
  type        = string
  default     = "MySQL"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "8.0"
}

variable "instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "rds.mysql.c1.large"
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "cloud_essd"
}

variable "storage" {
  description = "Storage size in GB"
  type        = number
  default     = 50
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vswitch_id" {
  description = "VSwitch ID"
  type        = string
}

variable "security_ips" {
  description = "List of IPs allowed to access RDS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "account_name" {
  description = "Database account name"
  type        = string
  default     = "terraform"
}

variable "account_password" {
  description = "Database account password"
  type        = string
  sensitive   = true
}

variable "create_database" {
  description = "Whether to create a database"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}
