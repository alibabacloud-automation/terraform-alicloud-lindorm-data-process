# ------------------------------------------------------------------------------
# Complete Example
#
# This example demonstrates the basic usage of the lindorm-data-process module.
# It creates a complete Lindorm data processing environment including VPC,
# VSwitch, Security Group, ECS instance, and Lindorm instance.
# ------------------------------------------------------------------------------

# Configure the Alibaba Cloud Provider
provider "alicloud" {
  region = var.region
}

# Query available zones with specified disk category
data "alicloud_zones" "default" {
  available_disk_category = "cloud_essd"
  available_instance_type = "ecs.e-c1m4.2xlarge"
}

# Query the latest Alibaba Linux 3 system image
data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_*"
  owners      = "system"
  most_recent = true
  status      = "Available"
}

# Generate a random password for ECS instance login
resource "random_password" "ecs_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Call the lindorm-data-process module
module "lindorm_data_process" {
  source = "../../"

  # VPC configuration
  vpc_config = {
    cidr_block = var.vpc_cidr_block
    vpc_name   = "${var.name_prefix}-vpc"
  }

  # VSwitch configuration
  vswitch_config = {
    cidr_block   = var.vswitch_cidr_block
    zone_id      = data.alicloud_zones.default.zones[length(data.alicloud_zones.default.zones) - 1].id
    vswitch_name = "${var.name_prefix}-vswitch"
  }

  # Security group configuration
  security_group_config = {
    security_group_name = "${var.name_prefix}-sg"
  }

  # ECS instance configuration
  instance_config = {
    password                   = random_password.ecs_password.result
    instance_type              = "ecs.e-c1m4.2xlarge"
    system_disk_category       = "cloud_essd"
    image_id                   = data.alicloud_images.default.images[0].id
    instance_name              = "${var.name_prefix}-ecs"
    internet_max_bandwidth_out = var.internet_max_bandwidth_out
  }

  # Lindorm instance configuration
  lindorm_config = {
    instance_storage            = var.lindorm_instance_storage
    payment_type                = "PayAsYouGo"
    search_engine_specification = var.lindorm_search_engine_specification
    search_engine_node_count    = var.lindorm_search_engine_node_count
    table_engine_specification  = var.lindorm_table_engine_specification
    table_engine_node_count     = var.lindorm_table_engine_node_count
    disk_category               = "cloud_efficiency"
    instance_name               = "${var.name_prefix}-lindorm"
  }

  # ECS command configuration
  ecs_command_config = {
    type        = "RunShellScript"
    timeout     = 300
    name        = "${var.name_prefix}-command"
    working_dir = "/root"
  }

  # ECS invocation configuration
  ecs_invocation_config = {
    timeout_create = "60m"
  }
}