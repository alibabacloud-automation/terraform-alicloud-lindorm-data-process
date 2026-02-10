# ------------------------------------------------------------------------------
# Example Variables
#
# This file defines the variables used in the complete example.
# These variables allow customization of the example deployment.
# ------------------------------------------------------------------------------

variable "region" {
  description = "The Alibaba Cloud region where resources will be created"
  type        = string
  default     = "cn-hangzhou"
}

variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
  default     = "lindorm-demo"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vswitch_cidr_block" {
  description = "CIDR block for the VSwitch"
  type        = string
  default     = "192.168.0.0/24"
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth for ECS instance in Mbps"
  type        = number
  default     = 5
}

variable "lindorm_instance_storage" {
  description = "Storage size for Lindorm instance in GB"
  type        = number
  default     = 160
}

variable "lindorm_search_engine_specification" {
  description = "Specification for Lindorm search engine"
  type        = string
  default     = "lindorm.g.xlarge"
}

variable "lindorm_search_engine_node_count" {
  description = "Number of search engine nodes for Lindorm"
  type        = number
  default     = 2
}

variable "lindorm_table_engine_specification" {
  description = "Specification for Lindorm table engine"
  type        = string
  default     = "lindorm.g.xlarge"
}

variable "lindorm_table_engine_node_count" {
  description = "Number of table engine nodes for Lindorm"
  type        = number
  default     = 2
}