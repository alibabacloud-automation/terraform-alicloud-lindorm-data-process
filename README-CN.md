阿里云 Lindorm 数据处理 Terraform 模块

# terraform-alicloud-lindorm-data-process

[English](https://github.com/alibabacloud-automation/terraform-alicloud-lindorm-data-process/blob/main/README.md) | 简体中文

Terraform 模块，用于在阿里云上创建完整的 Lindorm 数据处理解决方案。该模块实现了[泛时序数据一站式分析与洞察](https://www.aliyun.com/solution/tech-solution/lindorm-data-process)解决方案，涉及专有网络（VPC）、交换机（VSwitch）、云服务器（ECS）和 Lindorm 数据库等资源的部署，用于全面的时序数据处理和分析。

## 使用方法

该模块创建一个完整的 Lindorm 数据处理环境，包括 VPC、ECS 实例和 Lindorm 数据库。您可以根据需要自定义配置：

```terraform
data "alicloud_zones" "default" {
  available_disk_category = "cloud_essd"
  available_instance_type = "ecs.e-c1m4.2xlarge"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_*"
  owners      = "system"
  most_recent = true
  status      = "Available"
}

module "lindorm_data_process" {
  source = "alibabacloud-automation/lindorm-data-process/alicloud"

  # VPC 配置（仅必需字段）
  vpc_config = {
    cidr_block = "192.168.0.0/16"
  }

  # 交换机配置（仅必需字段）
  vswitch_config = {
    cidr_block = "192.168.0.0/24"
    zone_id    = data.alicloud_zones.default.zones[length(data.alicloud_zones.default.zones) - 1].id
  }

  # ECS 实例配置（仅必需字段）
  instance_config = {
    password             = "YourPassword123!"
    instance_type        = "ecs.e-c1m4.2xlarge"
    system_disk_category = "cloud_essd"
    image_id             = data.alicloud_images.default.images[0].id
  }

  # Lindorm 实例配置（仅必需字段）
  lindorm_config = {
    instance_storage            = 160
    payment_type                = "PayAsYouGo"
    search_engine_specification = "lindorm.g.xlarge"
    search_engine_node_count    = 2
    table_engine_specification  = "lindorm.g.xlarge"
    table_engine_node_count     = 2
    disk_category               = "cloud_efficiency"
  }

  # ECS 命令配置（仅必需字段）
  ecs_command_config = {
    type        = "RunShellScript"
    timeout     = 300
    name        = "lindorm-demo-command"
    working_dir = "/root"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-lindorm-data-process/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.ecs_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.ecs_invocation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_lindorm_instance.lindorm_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/lindorm_instance) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_ecs_command_script"></a> [custom\_ecs\_command\_script](#input\_custom\_ecs\_command\_script) | Custom ECS command script content. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | ECS command configuration parameters. The attributes 'type', 'timeout', 'name', 'working\_dir' are required. | <pre>object({<br/>    type        = optional(string, "RunShellScript")<br/>    timeout     = optional(number, 300)<br/>    name        = optional(string, "auto-75ca2a13")<br/>    working_dir = optional(string, "/root")<br/>  })</pre> | `{}` | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | ECS invocation configuration parameters. | <pre>object({<br/>    timeout_create = optional(string, "60m")<br/>  })</pre> | `{}` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | ECS instance configuration parameters. The attributes 'password', 'instance\_type', 'system\_disk\_category', 'image\_id' are required. | <pre>object({<br/>    password                   = string<br/>    instance_type              = string<br/>    system_disk_category       = string<br/>    image_id                   = string<br/>    instance_name              = optional(string, "default-ecs-instance")<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>    tags                       = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": null,<br/>  "password": null,<br/>  "system_disk_category": null<br/>}</pre> | no |
| <a name="input_lindorm_config"></a> [lindorm\_config](#input\_lindorm\_config) | Lindorm instance configuration parameters. The attributes 'instance\_storage', 'payment\_type', 'search\_engine\_specification', 'search\_engine\_node\_count', 'table\_engine\_specification', 'table\_engine\_node\_count', 'disk\_category' are required. | <pre>object({<br/>    instance_storage            = number<br/>    payment_type                = string<br/>    search_engine_specification = string<br/>    search_engine_node_count    = number<br/>    table_engine_specification  = string<br/>    table_engine_node_count     = number<br/>    disk_category               = string<br/>    instance_name               = optional(string, "default-lindorm-instance")<br/>    tags                        = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "disk_category": null,<br/>  "instance_storage": null,<br/>  "payment_type": null,<br/>  "search_engine_node_count": null,<br/>  "search_engine_specification": null,<br/>  "table_engine_node_count": null,<br/>  "table_engine_specification": null<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Security group configuration parameters. | <pre>object({<br/>    security_group_name = optional(string, "default-security-group")<br/>    tags                = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration parameters. The attribute 'cidr\_block' is required. | <pre>object({<br/>    cidr_block = string<br/>    vpc_name   = optional(string, "default-vpc")<br/>    tags       = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | VSwitch configuration parameters. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "default-vswitch")<br/>    tags         = optional(map(string), {})<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_instance_private_ip"></a> [ecs\_instance\_private\_ip](#output\_ecs\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_ecs_instance_public_ip"></a> [ecs\_instance\_public\_ip](#output\_ecs\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS invocation |
| <a name="output_ecs_invocation_status"></a> [ecs\_invocation\_status](#output\_ecs\_invocation\_status) | The status of the ECS invocation |
| <a name="output_ecs_login_address"></a> [ecs\_login\_address](#output\_ecs\_login\_address) | The ECS instance login address |
| <a name="output_lindorm_instance_id"></a> [lindorm\_instance\_id](#output\_lindorm\_instance\_id) | The ID of the Lindorm instance |
| <a name="output_lindorm_instance_status"></a> [lindorm\_instance\_status](#output\_lindorm\_instance\_status) | The status of the Lindorm instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_cidr_block"></a> [vswitch\_cidr\_block](#output\_vswitch\_cidr\_block) | The CIDR block of the VSwitch |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)