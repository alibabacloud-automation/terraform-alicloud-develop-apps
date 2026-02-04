# VPC resource
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.vpc_config.vpc_name
  cidr_block = var.vpc_config.cidr_block
}

# VSwitch for ECS
resource "alicloud_vswitch" "ecs_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.ecs_vswitch_config.cidr_block
  zone_id      = var.ecs_vswitch_config.zone_id
  vswitch_name = var.ecs_vswitch_config.vswitch_name
}

# VSwitch for RDS
resource "alicloud_vswitch" "rds_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.rds_vswitch_config.cidr_block
  zone_id      = var.rds_vswitch_config.zone_id
  vswitch_name = var.rds_vswitch_config.vswitch_name
}

# Security Group
resource "alicloud_security_group" "security_group" {
  security_group_name = var.security_group_config.security_group_name
  vpc_id              = alicloud_vpc.vpc.id
}

# Security Group Rules
resource "alicloud_security_group_rule" "security_group_rules" {
  for_each = { for i, rule in var.security_group_rules : "${rule.type}-${rule.port_range}" => rule }

  security_group_id = alicloud_security_group.security_group.id
  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  port_range        = each.value.port_range
  cidr_ip           = each.value.cidr_ip
}

# ECS Instance
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.instance_config.instance_name
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  security_groups            = [alicloud_security_group.security_group.id]
  vswitch_id                 = alicloud_vswitch.ecs_vswitch.id
  system_disk_category       = var.instance_config.system_disk_category
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
  password                   = var.instance_config.password
}

# RDS Instance
resource "alicloud_db_instance" "rds_instance" {
  engine                   = var.db_instance_config.engine
  engine_version           = var.db_instance_config.engine_version
  instance_type            = var.db_instance_config.instance_type
  instance_storage         = var.db_instance_config.instance_storage
  category                 = var.db_instance_config.category
  db_instance_storage_type = var.db_instance_config.db_instance_storage_type
  vpc_id                   = alicloud_vpc.vpc.id
  vswitch_id               = alicloud_vswitch.rds_vswitch.id
  security_group_ids       = [alicloud_security_group.security_group.id]
  security_ips             = var.db_instance_config.security_ips
}

# RDS Account
resource "alicloud_rds_account" "create_db_user" {
  db_instance_id   = alicloud_db_instance.rds_instance.id
  account_name     = var.rds_account_config.account_name
  account_password = var.rds_account_config.account_password
  account_type     = var.rds_account_config.account_type
}

# RDS Database
resource "alicloud_db_database" "rds_database" {
  data_base_name = var.db_database_config.name
  description    = var.db_database_config.description
  instance_id    = alicloud_db_instance.rds_instance.id
  character_set  = var.db_database_config.character_set
}

# Local for install script
locals {
  install_java_script = templatefile("${path.module}/install_java.sh", {
    database_endpoint = alicloud_db_instance.rds_instance.connection_string
    database_user     = var.rds_account_config.account_name
    database_password = var.rds_account_config.account_password
    database_name     = var.db_database_config.name
  })
}

# ECS Command
resource "alicloud_ecs_command" "install_java" {
  depends_on      = [alicloud_db_database.rds_database]
  name            = var.ecs_command_config.name
  command_content = var.custom_command_content != null ? base64encode(var.custom_command_content) : base64encode(local.install_java_script)
  description     = var.ecs_command_config.description
  type            = var.ecs_command_config.type
  working_dir     = var.ecs_command_config.working_dir
}

# ECS Invocation
resource "alicloud_ecs_invocation" "invoke_install_java" {
  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.install_java.id
}

# DNS Record (conditional)
resource "alicloud_dns_record" "domain_record" {
  count = var.domain_config != null ? 1 : 0

  name        = var.domain_config.domain_name
  host_record = var.domain_config.domain_prefix
  type        = var.domain_config.record_type
  value       = alicloud_instance.ecs_instance.public_ip
}