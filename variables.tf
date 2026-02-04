
variable "vpc_config" {
  type = object({
    vpc_name   = optional(string, null)
    cidr_block = string
  })
  description = "Configuration for VPC. The attribute 'cidr_block' is required."
  default = {
    cidr_block = "192.168.0.0/16"
  }
}

variable "ecs_vswitch_config" {
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, null)
  })
  description = "Configuration for ECS VSwitch. The attributes 'cidr_block' and 'zone_id' are required."
  default = {
    cidr_block = "192.168.0.0/24"
    zone_id    = null
  }
}

variable "rds_vswitch_config" {
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, null)
  })
  description = "Configuration for RDS VSwitch. The attributes 'cidr_block' and 'zone_id' are required."
  default = {
    cidr_block = "192.168.1.0/24"
    zone_id    = null
  }
}

variable "security_group_config" {
  type = object({
    security_group_name = optional(string, null)
  })
  description = "Configuration for security group"
  default     = {}
}

variable "security_group_rules" {
  type = list(object({
    type        = string
    ip_protocol = string
    port_range  = string
    cidr_ip     = string
  }))
  description = "List of security group rules to create"
  default = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "443/443"
      cidr_ip     = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "3306/3306"
      cidr_ip     = "0.0.0.0/0"
    }
  ]
}

variable "instance_config" {
  type = object({
    instance_name              = optional(string, null)
    image_id                   = string
    instance_type              = string
    system_disk_category       = string
    internet_max_bandwidth_out = number
    password                   = string
  })
  description = "Configuration for ECS instance. The attributes 'image_id', 'instance_type', 'system_disk_category', 'internet_max_bandwidth_out', and 'password' are required."
  default = {
    image_id                   = null
    instance_type              = null
    system_disk_category       = "cloud_essd"
    internet_max_bandwidth_out = 100
    password                   = null
  }
  sensitive = true
}

variable "db_instance_config" {
  type = object({
    engine                   = string
    engine_version           = string
    instance_type            = string
    instance_storage         = number
    category                 = string
    db_instance_storage_type = string
    security_ips             = list(string)
  })
  description = "Configuration for RDS instance. All attributes are required."
  default = {
    engine                   = "MySQL"
    engine_version           = "8.0"
    instance_type            = null
    instance_storage         = 40
    category                 = "Basic"
    db_instance_storage_type = "cloud_essd"
    security_ips             = ["192.168.0.0/24"]
  }
}

variable "rds_account_config" {
  type = object({
    account_name     = string
    account_password = string
    account_type     = string
  })
  description = "Configuration for RDS account. All attributes are required."
  sensitive   = true
}

variable "db_database_config" {
  type = object({
    name          = string
    description   = optional(string, null)
    character_set = string
  })
  description = "Configuration for RDS database. The attributes 'name' and 'character_set' are required."
}

variable "custom_command_content" {
  type        = string
  description = "Custom command content to execute on ECS instance"
  default     = null
}

variable "ecs_command_config" {
  type = object({
    name        = string
    description = string
    type        = string
    working_dir = string
  })
  description = "Configuration for ECS command. The attributes 'name', 'description', 'type', and 'working_dir' are required."
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