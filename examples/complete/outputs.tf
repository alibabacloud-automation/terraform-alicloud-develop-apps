# Application access outputs
output "application_url" {
  description = "The URL to access the application"
  value       = module.develop_apps.application_url
}

output "ecs_login_url" {
  description = "The URL to login to ECS instance via Alibaba Cloud console"
  value       = module.develop_apps.ecs_login_url
}

# Infrastructure outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.develop_apps.vpc_id
}

output "instance_id" {
  description = "The ID of the ECS instance"
  value       = module.develop_apps.instance_id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.develop_apps.instance_public_ip
}

output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.develop_apps.db_instance_id
}

output "db_instance_connection_string" {
  description = "The connection string of the RDS instance"
  value       = module.develop_apps.db_instance_connection_string
  sensitive   = true
}

output "database_name" {
  description = "The name of the created database"
  value       = module.develop_apps.database_name
}