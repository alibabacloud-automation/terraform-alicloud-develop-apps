provider "alicloud" {
  region = var.region
}
# Data sources to fetch required information
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

data "alicloud_images" "default" {
  name_regex  = var.image_name_regex
  most_recent = true
  owners      = "system"
}

data "alicloud_db_zones" "zones_ids" {
  engine                   = var.rds_engine
  engine_version           = var.rds_engine_version
  instance_charge_type     = "PostPaid"
  category                 = var.rds_category
  db_instance_storage_type = var.rds_storage_type
}

# Call the develop-apps module
module "develop_apps" {
  source = "../../"

  # VPC configuration
  vpc_config = {
    vpc_name   = "${var.common_name}-vpc"
    cidr_block = var.vpc_cidr_block
  }

  # VSwitch configurations
  ecs_vswitch_config = {
    cidr_block   = var.ecs_vswitch_cidr_block
    zone_id      = data.alicloud_zones.default.ids[0]
    vswitch_name = "${var.common_name}-ecs-vsw"
  }

  rds_vswitch_config = {
    cidr_block   = var.rds_vswitch_cidr_block
    zone_id      = data.alicloud_db_zones.zones_ids.ids[0]
    vswitch_name = "${var.common_name}-rds-vsw"
  }

  # Security group configuration
  security_group_config = {
    security_group_name = "${var.common_name}-sg"
  }

  # Security group rules
  security_group_rules = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "443/443"
      cidr_ip     = var.vpc_cidr_block
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = var.vpc_cidr_block
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "3306/3306"
      cidr_ip     = var.vpc_cidr_block
    }
  ]

  # ECS instance configuration
  instance_config = {
    instance_name              = "${var.common_name}-ecs"
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.instance_type
    system_disk_category       = var.system_disk_category
    internet_max_bandwidth_out = var.internet_max_bandwidth_out
    password                   = var.ecs_instance_password
  }

  # RDS instance configuration
  db_instance_config = {
    engine                   = var.rds_engine
    engine_version           = var.rds_engine_version
    instance_type            = var.rds_instance_type
    instance_storage         = var.rds_instance_storage
    category                 = var.rds_category
    db_instance_storage_type = var.rds_storage_type
    security_ips             = var.rds_security_ips
  }

  # RDS account configuration
  rds_account_config = {
    account_name     = var.db_user_name
    account_password = var.db_password
    account_type     = var.rds_account_type
  }

  # Database configuration
  db_database_config = {
    name          = var.database_name
    character_set = var.database_character_set
  }

  # ECS command configuration
  ecs_command_config = {
    name        = "${var.common_name}-init-cmd"
    description = var.ecs_command_description
    type        = var.ecs_command_type
    working_dir = var.ecs_command_working_dir
  }

  # Optional domain configuration
  domain_config = var.domain_config

}