# ------------------------------------------------------------------------------
# Module Input Variables
#
# This file defines all configurable input variables for this Terraform module.
# Each variable includes detailed descriptions to help users configure the module correctly.
# ------------------------------------------------------------------------------

variable "vpc_config" {
  description = "VPC configuration parameters. The attribute 'cidr_block' is required."
  type = object({
    cidr_block = string
    vpc_name   = optional(string, "default-vpc")
    tags       = optional(map(string), {})
  })
}

variable "vswitch_config" {
  description = "VSwitch configuration parameters. The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "default-vswitch")
    tags         = optional(map(string), {})
  })
}

variable "security_group_config" {
  description = "Security group configuration parameters."
  type = object({
    security_group_name = optional(string, "default-security-group")
    tags                = optional(map(string), {})
  })
  default = {}
}

variable "instance_config" {
  description = "ECS instance configuration parameters. The attributes 'password', 'instance_type', 'system_disk_category', 'image_id' are required."
  type = object({
    password                   = string
    instance_type              = string
    system_disk_category       = string
    image_id                   = string
    instance_name              = optional(string, "default-ecs-instance")
    internet_max_bandwidth_out = optional(number, 5)
    tags                       = optional(map(string), {})
  })
  default = {
    password             = null
    instance_type        = null
    system_disk_category = null
    image_id             = null
  }
  sensitive = true
}

variable "lindorm_config" {
  description = "Lindorm instance configuration parameters. The attributes 'instance_storage', 'payment_type', 'search_engine_specification', 'search_engine_node_count', 'table_engine_specification', 'table_engine_node_count', 'disk_category' are required."
  type = object({
    instance_storage            = number
    payment_type                = string
    search_engine_specification = string
    search_engine_node_count    = number
    table_engine_specification  = string
    table_engine_node_count     = number
    disk_category               = string
    instance_name               = optional(string, "default-lindorm-instance")
    tags                        = optional(map(string), {})
  })
  default = {
    instance_storage            = null
    payment_type                = null
    search_engine_specification = null
    search_engine_node_count    = null
    table_engine_specification  = null
    table_engine_node_count     = null
    disk_category               = null
  }
}

variable "ecs_command_config" {
  description = "ECS command configuration parameters. The attributes 'type', 'timeout', 'name', 'working_dir' are required."
  type = object({
    type        = optional(string, "RunShellScript")
    timeout     = optional(number, 300)
    name        = optional(string, "auto-75ca2a13")
    working_dir = optional(string, "/root")
  })
  default = {}
}

variable "ecs_invocation_config" {
  description = "ECS invocation configuration parameters."
  type = object({
    timeout_create = optional(string, "60m")
  })
  default = {}
}

variable "custom_ecs_command_script" {
  description = "Custom ECS command script content. If not provided, the default script will be used."
  type        = string
  default     = null
}