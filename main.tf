# ------------------------------------------------------------------------------
# Core Resource Definitions
#
# This file contains the core infrastructure resources for the module.
# The code here is responsible for creating and configuring all cloud resources
# based on the input variables.
# ------------------------------------------------------------------------------

# Get current region information
data "alicloud_regions" "current" {
  current = true
}

# Local values for the module
locals {
  # Default ECS command script
  default_ecs_command_script = <<-EOF
    #!/bin/bash
    function log_info() {
        printf "%s [INFO] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
    }
    function log_error() {
        printf "%s [ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
    }
    function debug_exec(){
        local cmd="$@"
        log_info "$cmd"
        eval "$cmd"
        ret=$?
        echo ""
        log_info "$cmd, exit code: $ret"
        return $ret
    }
    function init_work(){
      yum upgrade & yum install -y python3 cryptography==3.4.8
      wget -O lindorm-cli-linux-latest.tar.gz https://tsdbtools.oss-cn-hangzhou.aliyuncs.com/lindorm-cli-linux-latest.tar.gz
      tar zxvf lindorm-cli-linux-latest.tar.gz
    }
    debug_exec init_work
  EOF
}

# Create VPC
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
  tags       = var.vpc_config.tags
}

# Create VSwitch
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
  tags         = var.vswitch_config.tags
}

# Create Security Group
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  tags                = var.security_group_config.tags
}

# Create ECS Instance
resource "alicloud_instance" "ecs_instance" {
  availability_zone          = alicloud_vswitch.vswitch.zone_id
  vpc_id                     = alicloud_vpc.vpc.id
  vswitch_id                 = alicloud_vswitch.vswitch.id
  security_groups            = [alicloud_security_group.security_group.id]
  password                   = var.instance_config.password
  instance_type              = var.instance_config.instance_type
  instance_name              = var.instance_config.instance_name
  system_disk_category       = var.instance_config.system_disk_category
  image_id                   = var.instance_config.image_id
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
  tags                       = var.instance_config.tags
}

# Create Lindorm Instance
resource "alicloud_lindorm_instance" "lindorm_instance" {
  instance_storage            = var.lindorm_config.instance_storage
  zone_id                     = alicloud_vswitch.vswitch.zone_id
  payment_type                = var.lindorm_config.payment_type
  vswitch_id                  = alicloud_vswitch.vswitch.id
  vpc_id                      = alicloud_vpc.vpc.id
  search_engine_specification = var.lindorm_config.search_engine_specification
  search_engine_node_count    = var.lindorm_config.search_engine_node_count
  table_engine_specification  = var.lindorm_config.table_engine_specification
  table_engine_node_count     = var.lindorm_config.table_engine_node_count
  disk_category               = var.lindorm_config.disk_category
  instance_name               = var.lindorm_config.instance_name
  tags                        = var.lindorm_config.tags
}

# Create ECS Command
resource "alicloud_ecs_command" "ecs_command" {
  type            = var.ecs_command_config.type
  timeout         = var.ecs_command_config.timeout
  command_content = var.custom_ecs_command_script != null ? base64encode(var.custom_ecs_command_script) : base64encode(local.default_ecs_command_script)
  name            = var.ecs_command_config.name
  working_dir     = var.ecs_command_config.working_dir
}

# Create ECS Command Invocation
resource "alicloud_ecs_invocation" "ecs_invocation" {
  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.ecs_command.id

  timeouts {
    create = var.ecs_invocation_config.timeout_create
  }
}