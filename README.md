Alibaba Cloud Development Application Infrastructure Terraform Module

# terraform-alicloud-develop-apps

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-develop-apps/blob/main/README-CN.md)

This Terraform module implements the [Efficiently Build Apps On The Cloud](https://www.aliyun.com/solution/tech-solution/develop-apps) solution, providing a complete infrastructure for developing and deploying mobile applications on Alibaba Cloud. The solution leverages Alibaba Cloud's Mobile R&D Platform (EMAS) and R&D Collaboration Platform (Cloud Efficiency) to offer comprehensive lifecycle management capabilities for apps, including development, testing, operations, and marketing. This module creates the necessary infrastructure including Virtual Private Cloud (VPC), Virtual Switch (VSwitch), RDS Database (RDS), Elastic Compute Service (ECS), security groups, and optional DNS configuration to support the solution. The solution enables efficient app development by providing various mobile technology SDKs, continuous integration and deployment workflows, automated testing capabilities, and streamlined release management.

## Usage

This module provides a complete solution for deploying development applications on Alibaba Cloud. It creates all necessary infrastructure components including networking, compute, database, and security configurations.

```terraform
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
}

module "develop_apps" {
  source = "alibabacloud-automation/develop-apps/alicloud"
  
  common_name = "my-dev-app"
  
  # VPC configuration
  vpc_config = {
    vpc_name   = "my-dev-vpc"
    cidr_block = "192.168.0.0/16"
  }
  
  # VSwitch configurations
  ecs_vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = "my-dev-ecs-vsw"
  }
  
  rds_vswitch_config = {
    cidr_block   = "192.168.1.0/24"
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = "my-dev-rds-vsw"
  }
  
  # ECS instance configuration
  instance_config = {
    instance_name              = "my-dev-ecs"
    image_id                   = "aliyun_3_9_x64_20G_alibase_20231221.vhd"
    instance_type              = "ecs.g7.large"
    system_disk_category       = "cloud_essd"
    internet_max_bandwidth_out = 100
    password                   = "YourPassword123!"
  }
  
  # RDS instance configuration
  db_instance_config = {
    engine                   = "MySQL"
    engine_version           = "8.0"
    instance_type            = "mysql.n2e.small.1"
    instance_storage         = 40
    category                 = "Basic"
    db_instance_storage_type = "cloud_essd"
    security_ips             = ["192.168.0.0/24"]
  }
  
  # Database account configuration
  rds_account_config = {
    account_name     = "appuser"
    account_password = "YourDBPassword123!"
    account_type     = "Super"
  }
  
  # Database configuration
  db_database_config = {
    name          = "appdb"
    character_set = "utf8mb4"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-develop-apps/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.200.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.200.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_db_database.rds_database](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_database) | resource |
| [alicloud_db_instance.rds_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_instance) | resource |
| [alicloud_dns_record.domain_record](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/dns_record) | resource |
| [alicloud_ecs_command.install_java](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.invoke_install_java](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_rds_account.create_db_user](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rds_account) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.security_group_rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.ecs_vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.rds_vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_command_content"></a> [custom\_command\_content](#input\_custom\_command\_content) | Custom command content to execute on ECS instance | `string` | `null` | no |
| <a name="input_db_database_config"></a> [db\_database\_config](#input\_db\_database\_config) | Configuration for RDS database. The attributes 'name' and 'character\_set' are required. | <pre>object({<br/>    name          = string<br/>    description   = optional(string, null)<br/>    character_set = string<br/>  })</pre> | n/a | yes |
| <a name="input_db_instance_config"></a> [db\_instance\_config](#input\_db\_instance\_config) | Configuration for RDS instance. All attributes are required. | <pre>object({<br/>    engine                   = string<br/>    engine_version           = string<br/>    instance_type            = string<br/>    instance_storage         = number<br/>    category                 = string<br/>    db_instance_storage_type = string<br/>    security_ips             = list(string)<br/>  })</pre> | <pre>{<br/>  "category": "Basic",<br/>  "db_instance_storage_type": "cloud_essd",<br/>  "engine": "MySQL",<br/>  "engine_version": "8.0",<br/>  "instance_storage": 40,<br/>  "instance_type": null,<br/>  "security_ips": [<br/>    "192.168.0.0/24"<br/>  ]<br/>}</pre> | no |
| <a name="input_domain_config"></a> [domain\_config](#input\_domain\_config) | Domain configuration for DNS record | <pre>object({<br/>    domain_prefix = optional(string, "@")<br/>    domain_name   = string<br/>    record_type   = optional(string, "A")<br/>  })</pre> | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | Configuration for ECS command. The attributes 'name', 'description', 'type', and 'working\_dir' are required. | <pre>object({<br/>    name        = string<br/>    description = string<br/>    type        = string<br/>    working_dir = string<br/>  })</pre> | n/a | yes |
| <a name="input_ecs_vswitch_config"></a> [ecs\_vswitch\_config](#input\_ecs\_vswitch\_config) | Configuration for ECS VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "cidr_block": "192.168.0.0/24",<br/>  "zone_id": null<br/>}</pre> | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | Configuration for ECS instance. The attributes 'image\_id', 'instance\_type', 'system\_disk\_category', 'internet\_max\_bandwidth\_out', and 'password' are required. | <pre>object({<br/>    instance_name              = optional(string, null)<br/>    image_id                   = string<br/>    instance_type              = string<br/>    system_disk_category       = string<br/>    internet_max_bandwidth_out = number<br/>    password                   = string<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": null,<br/>  "internet_max_bandwidth_out": 100,<br/>  "password": null,<br/>  "system_disk_category": "cloud_essd"<br/>}</pre> | no |
| <a name="input_rds_account_config"></a> [rds\_account\_config](#input\_rds\_account\_config) | Configuration for RDS account. All attributes are required. | <pre>object({<br/>    account_name     = string<br/>    account_password = string<br/>    account_type     = string<br/>  })</pre> | n/a | yes |
| <a name="input_rds_vswitch_config"></a> [rds\_vswitch\_config](#input\_rds\_vswitch\_config) | Configuration for RDS VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "cidr_block": "192.168.1.0/24",<br/>  "zone_id": null<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for security group | <pre>object({<br/>    security_group_name = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | List of security group rules to create | <pre>list(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    port_range  = string<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "443/443",<br/>    "type": "ingress"<br/>  },<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "80/80",<br/>    "type": "ingress"<br/>  },<br/>  {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "3306/3306",<br/>    "type": "ingress"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    vpc_name   = optional(string, null)<br/>    cidr_block = string<br/>  })</pre> | <pre>{<br/>  "cidr_block": "192.168.0.0/16"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_url"></a> [application\_url](#output\_application\_url) | The application URL |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the database |
| <a name="output_db_account_name"></a> [db\_account\_name](#output\_db\_account\_name) | The name of the RDS account |
| <a name="output_db_instance_connection_string"></a> [db\_instance\_connection\_string](#output\_db\_instance\_connection\_string) | The connection string of the RDS instance |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The ID of the RDS instance |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | The port of the RDS instance |
| <a name="output_dns_record_id"></a> [dns\_record\_id](#output\_dns\_record\_id) | The ID of the DNS record |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS invocation |
| <a name="output_ecs_login_url"></a> [ecs\_login\_url](#output\_ecs\_login\_url) | The ECS instance login URL in Alibaba Cloud console |
| <a name="output_ecs_vswitch_id"></a> [ecs\_vswitch\_id](#output\_ecs\_vswitch\_id) | The ID of the ECS VSwitch |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the ECS instance |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_rds_vswitch_id"></a> [rds\_vswitch\_id](#output\_rds\_vswitch\_id) | The ID of the RDS VSwitch |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)