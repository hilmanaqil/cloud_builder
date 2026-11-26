
variable "aws_region" {
  description = "AWS Singapore region"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.nano"
}

variable "enable_public_ip" {
  description = "Whether to assign a public IPv4 address"
  type        = bool
  default     = false
}

variable "ssh_allowed_cidr" {
  description = "Your public IP in CIDR notation"
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 8
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
  default     = "teamcity-linux-test"
}
