variable "region" {
  type        = string
  description = "The Alibaba Cloud region where resources will be created"
  default     = "cn-shenzhen"
}

variable "common_name" {
  type        = string
  description = "Common name prefix for resources"
  default     = "develop-app-example"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}

variable "ecs_vswitch_cidr_block" {
  type        = string
  description = "CIDR block for the ECS VSwitch"
  default     = "192.168.0.0/24"
}

variable "rds_vswitch_cidr_block" {
  type        = string
  description = "CIDR block for the RDS VSwitch"
  default     = "192.168.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the ECS instance"
  default     = "ecs.g7.large"
}

variable "system_disk_category" {
  type        = string
  description = "System disk category for the ECS instance"
  default     = "cloud_essd"
}

variable "internet_max_bandwidth_out" {
  type        = number
  description = "Maximum outbound bandwidth for the ECS instance"
  default     = 100
}

variable "image_name_regex" {
  type        = string
  description = "Regex pattern to match the desired image"
  default     = "^aliyun_3_x64_20G_alibase_.*"
}

variable "ecs_instance_password" {
  type        = string
  description = "Password for the ECS instance. Must be 8-30 characters and contain at least three types: uppercase letters, lowercase letters, numbers, and special characters"
  sensitive   = true
}

variable "rds_engine" {
  type        = string
  description = "Database engine for RDS instance"
  default     = "MySQL"
}

variable "rds_engine_version" {
  type        = string
  description = "Database engine version for RDS instance"
  default     = "8.0"
}

variable "rds_instance_type" {
  type        = string
  description = "Instance type for RDS instance"
  default     = "mysql.n2e.small.1"
}

variable "rds_instance_storage" {
  type        = number
  description = "Storage size for RDS instance in GB"
  default     = 40
}

variable "rds_category" {
  type        = string
  description = "Category for RDS instance"
  default     = "Basic"
}

variable "rds_storage_type" {
  type        = string
  description = "Storage type for RDS instance"
  default     = "cloud_essd"
}

variable "rds_security_ips" {
  type        = list(string)
  description = "List of IPs allowed to access the RDS instance"
  default     = ["192.168.0.0/16"]
}

variable "rds_account_type" {
  type        = string
  description = "Account type for RDS account"
  default     = "Super"
}

variable "db_user_name" {
  type        = string
  description = "Database username. Must be 2-32 lowercase letters, supporting lowercase letters, numbers and underscores, starting with lowercase letters"
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Database password. Must be 8-30 characters and contain at least three types: uppercase letters, lowercase letters, numbers, and special characters"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Database name. Must be 2-32 lowercase letters, supporting lowercase letters, numbers and underscores, starting with lowercase letters"
  default     = "appdb"
}

variable "database_character_set" {
  type        = string
  description = "Character set for the database"
  default     = "utf8mb4"
}


variable "ecs_command_description" {
  type        = string
  description = "Description for the ECS command"
  default     = "Install Java and Initialize Database"
}

variable "ecs_command_type" {
  type        = string
  description = "Type of the ECS command"
  default     = "RunShellScript"
}

variable "ecs_command_working_dir" {
  type        = string
  description = "Working directory for the ECS command"
  default     = "/root"
}

variable "domain_config" {
  type = object({
    domain_prefix = optional(string, "@")
    domain_name   = string
    record_type   = optional(string, "A")
  })
  description = "Domain configuration for DNS record"
  default     = null
}
