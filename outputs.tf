# ------------------------------------------------------------------------------
# Module Output Values
#
# This file defines the output values returned by the module after successful execution.
# These outputs can be referenced by other Terraform configurations or displayed to users
# after the apply command completes.
# ------------------------------------------------------------------------------

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
output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "vswitch_cidr_block" {
  description = "The CIDR block of the VSwitch"
  value       = alicloud_vswitch.vswitch.cidr_block
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

# ECS Instance outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.primary_ip_address
}

output "ecs_login_address" {
  description = "The ECS instance login address"
  value       = format("https://ecs-workbench.aliyun.com/?from=EcsConsole&instanceType=ecs&regionId=%s&instanceId=%s", data.alicloud_regions.current.regions[0].id, alicloud_instance.ecs_instance.id)
}

# Lindorm Instance outputs
output "lindorm_instance_id" {
  description = "The ID of the Lindorm instance"
  value       = alicloud_lindorm_instance.lindorm_instance.id
}

output "lindorm_instance_status" {
  description = "The status of the Lindorm instance"
  value       = alicloud_lindorm_instance.lindorm_instance.status
}

# ECS Command outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.ecs_command.id
}

# ECS Invocation outputs
output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = alicloud_ecs_invocation.ecs_invocation.id
}

output "ecs_invocation_status" {
  description = "The status of the ECS invocation"
  value       = alicloud_ecs_invocation.ecs_invocation.status
}