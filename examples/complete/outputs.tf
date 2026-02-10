# ------------------------------------------------------------------------------
# Example Outputs
#
# This file defines the outputs from the complete example.
# These outputs display important information after deployment.
# ------------------------------------------------------------------------------

# Module outputs
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.lindorm_data_process.vpc_id
}

output "vswitch_id" {
  description = "The ID of the created VSwitch"
  value       = module.lindorm_data_process.vswitch_id
}

output "security_group_id" {
  description = "The ID of the created security group"
  value       = module.lindorm_data_process.security_group_id
}

output "ecs_instance_id" {
  description = "The ID of the created ECS instance"
  value       = module.lindorm_data_process.ecs_instance_id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.lindorm_data_process.ecs_instance_public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = module.lindorm_data_process.ecs_instance_private_ip
}

output "ecs_login_address" {
  description = "The ECS instance login address"
  value       = module.lindorm_data_process.ecs_login_address
}

output "lindorm_instance_id" {
  description = "The ID of the created Lindorm instance"
  value       = module.lindorm_data_process.lindorm_instance_id
}

output "lindorm_instance_status" {
  description = "The status of the Lindorm instance"
  value       = module.lindorm_data_process.lindorm_instance_status
}

# Generated password (sensitive)
output "ecs_instance_password" {
  description = "The password for the ECS instance (sensitive)"
  value       = random_password.ecs_password.result
  sensitive   = true
}