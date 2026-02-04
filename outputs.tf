# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

# VSwitch outputs
output "ecs_vswitch_id" {
  description = "The ID of the ECS VSwitch"
  value       = alicloud_vswitch.ecs_vswitch.id
}

output "rds_vswitch_id" {
  description = "The ID of the RDS VSwitch"
  value       = alicloud_vswitch.rds_vswitch.id
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

# ECS Instance outputs
output "instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.primary_ip_address
}

# RDS Instance outputs
output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = alicloud_db_instance.rds_instance.id
}

output "db_instance_connection_string" {
  description = "The connection string of the RDS instance"
  value       = alicloud_db_instance.rds_instance.connection_string
}

output "db_instance_port" {
  description = "The port of the RDS instance"
  value       = alicloud_db_instance.rds_instance.port
}

# RDS Account outputs
output "db_account_name" {
  description = "The name of the RDS account"
  value       = alicloud_rds_account.create_db_user.account_name
}

# RDS Database outputs
output "database_name" {
  description = "The name of the database"
  value       = alicloud_db_database.rds_database.data_base_name
}

# ECS Command outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.install_java.id
}

# ECS Invocation outputs
output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = alicloud_ecs_invocation.invoke_install_java.id
}

# DNS Record outputs (conditional)
output "dns_record_id" {
  description = "The ID of the DNS record"
  value       = var.domain_config != null ? alicloud_dns_record.domain_record[0].id : null
}

# Convenient outputs for application access
output "application_url" {
  description = "The application URL"
  value       = var.domain_config != null ? "http://${var.domain_config.domain_prefix != "" && var.domain_config.domain_prefix != "@" ? var.domain_config.domain_prefix : "www"}.${var.domain_config.domain_name}" : "http://${alicloud_instance.ecs_instance.public_ip}"
}

output "ecs_login_url" {
  description = "The ECS instance login URL in Alibaba Cloud console"
  value       = "https://ecs-workbench.aliyun.com/?from=EcsConsole&instanceType=ecs&instanceId=${alicloud_instance.ecs_instance.id}"
}