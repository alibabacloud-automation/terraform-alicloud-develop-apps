# Complete Example

This example demonstrates how to use the develop-apps module to create a complete application infrastructure on Alibaba Cloud.

## What This Example Creates

- A VPC with two VSwitches (one for ECS, one for RDS)
- A security group with configurable rules for HTTP (80), HTTPS (443), and MySQL (3306)
- An ECS instance for the application server
- An RDS MySQL instance for the database
- A database and user account
- An ECS command to install Java and initialize the database
- Optional DNS record for custom domain

## Prerequisites

1. Alibaba Cloud account with appropriate permissions
2. Terraform >= 1.0
3. Alibaba Cloud Provider >= 1.200.0

## Usage

1. Clone or download this example
2. Set your Alibaba Cloud credentials:
   ```bash
   export ALICLOUD_ACCESS_KEY="your-access-key"
   export ALICLOUD_SECRET_KEY="your-secret-key"
   export ALICLOUD_REGION="cn-shenzhen"
   ```

3. Create a `terraform.tfvars` file:
   ```hcl
   common_name = "my-app"
   ecs_instance_password = "YourPassword123!"
   db_password = "YourDBPassword123!"

   # Optional: Customize resource configurations
   # vpc_cidr_block = "10.0.0.0/16"
   # instance_type = "ecs.c6.large"
   # rds_instance_type = "mysql.n2.medium.1"
   # rds_instance_storage = 80

   # Optional: Configure custom domain
   # domain_config = {
   #   domain_prefix = "app"
   #   domain_name   = "example.com"
   # }
   ```

4. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | The Alibaba Cloud region where resources will be created | `string` | `"cn-shenzhen"` | no |
| common_name | Common name prefix for resources | `string` | `"develop-app-example"` | no |
| vpc_cidr_block | CIDR block for the VPC | `string` | `"192.168.0.0/16"` | no |
| ecs_vswitch_cidr_block | CIDR block for the ECS VSwitch | `string` | `"192.168.0.0/24"` | no |
| rds_vswitch_cidr_block | CIDR block for the RDS VSwitch | `string` | `"192.168.1.0/24"` | no |
| instance_type | Instance type for the ECS instance | `string` | `"ecs.g7.large"` | no |
| system_disk_category | System disk category for the ECS instance | `string` | `"cloud_essd"` | no |
| internet_max_bandwidth_out | Maximum outbound bandwidth for the ECS instance | `number` | `100` | no |
| image_name_regex | Regex pattern to match the desired image | `string` | `"^aliyun_3_x64_20G_alibase_.*"` | no |
| ecs_instance_password | Password for the ECS instance. Must be 8-30 characters and contain at least three types: uppercase letters, lowercase letters, numbers, and special characters | `string` | n/a | yes |
| rds_engine | Database engine for RDS instance | `string` | `"MySQL"` | no |
| rds_engine_version | Database engine version for RDS instance | `string` | `"8.0"` | no |
| rds_instance_type | Instance type for RDS instance | `string` | `"mysql.n2e.small.1"` | no |
| rds_instance_storage | Storage size for RDS instance in GB | `number` | `40` | no |
| rds_category | Category for RDS instance | `string` | `"Basic"` | no |
| rds_storage_type | Storage type for RDS instance | `string` | `"cloud_essd"` | no |
| rds_security_ips | List of IPs allowed to access the RDS instance | `list(string)` | `["192.168.0.0/16"]` | no |
| rds_account_type | Account type for RDS account | `string` | `"Super"` | no |
| db_user_name | Database username. Must be 2-32 lowercase letters, supporting lowercase letters, numbers and underscores, starting with lowercase letters | `string` | `"appuser"` | no |
| db_password | Database password. Must be 8-30 characters and contain at least three types: uppercase letters, lowercase letters, numbers, and special characters | `string` | n/a | yes |
| database_name | Database name. Must be 2-32 lowercase letters, supporting lowercase letters, numbers and underscores, starting with lowercase letters | `string` | `"appdb"` | no |
| database_character_set | Character set for the database | `string` | `"utf8mb4"` | no |
| security_group_rules | List of security group rules to create | `list(object({type=string,ip_protocol=string,port_range=string,cidr_ip=string}))` | see variables | no |
| ecs_command_description | Description for the ECS command | `string` | `"Install Java and Initialize Database"` | no |
| ecs_command_type | Type of the ECS command | `string` | `"RunShellScript"` | no |
| ecs_command_working_dir | Working directory for the ECS command | `string` | `"/root"` | no |
| domain_config | Domain configuration for DNS record | `object({domain_prefix=optional(string,"@"),domain_name=string,record_type=optional(string,"A")})` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| application_url | The URL to access the application |
| ecs_login_url | The URL to login to ECS instance via Alibaba Cloud console |
| vpc_id | The ID of the VPC |
| instance_id | The ID of the ECS instance |
| instance_public_ip | The public IP address of the ECS instance |
| instance_private_ip | The private IP address of the ECS instance |
| db_instance_id | The ID of the RDS instance |
| db_instance_connection_string | The connection string of the RDS instance |
| db_instance_port | The port of the RDS instance |
| db_account_name | The name of the RDS account |
| database_name | The name of the database |
| ecs_command_id | The ID of the ECS command |
| ecs_invocation_id | The ID of the ECS invocation |
| dns_record_id | The ID of the DNS record |

## After Deployment

1. The ECS instance will automatically install Java and initialize the database
2. You can access the ECS instance via the provided login URL
3. The application will be accessible via the provided application URL
4. Database connection details are available in the outputs

## Clean Up

To destroy the resources:

```bash
terraform destroy
```

## Security Considerations

- The security group allows access from any IP (0.0.0.0/0) for demonstration purposes
- In production, restrict access to specific IP ranges
- Use strong passwords for ECS and database
- Consider using Alibaba Cloud KMS for password encryption