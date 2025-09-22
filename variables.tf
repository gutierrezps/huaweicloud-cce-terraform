variable "hwc_access_key" {
  type        = string
  description = "Access Key (AK) of your Huawei Cloud account or IAM User"
}

variable "hwc_secret_key" {
  type        = string
  sensitive   = true
  description = "Secret Access Key (SK) of your Huawei Cloud account or IAM User"
}

variable "region" {
  type        = string
  default     = "sa-brazil-1"
  description = "Region where resources will be created (LA-Sao Paulo1 by default)"
}

variable "availability_zone" {
  type        = string
  default     = "sa-brazil-1b"
  description = "AZ where resources will be created (AZ2 by default)"
}

variable "cce_node_password" {
  type        = string
  sensitive   = true
  description = "OS password for CCE Nodes"
}

variable "obs_bucket_name" {
  type        = string
  description = "Name of OBS bucket to be mounted as storage in cluster"
}

variable "create_elb" {
  type        = bool
  description = "Set to true to create an ELB for inbound internet access"
  default     = false
}

variable "create_nat" {
  type        = bool
  description = "Set to true to create a NAT Gateway for outbound internet access"
  default     = false
}

variable "create_obs" {
  type        = bool
  description = "Set to true to create an OBS bucket + IAM user"
  default     = false
}