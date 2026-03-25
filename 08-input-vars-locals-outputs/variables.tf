# variable "aws_region" {
#   type    = string
#   default = "eu-west-1"
# }
# Problematic if we change the value of this variable, Terraform will forget previous state and try to create new resources in the new region, 
# while the old ones will still exist in the old region. This can lead to unexpected costs and resource duplication.

variable "ec2_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The type of managed EC2 instances."

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
    error_message = "Only supports t2.micro and t3.micro instance types."
  }
}


# The following variables have been replaced by a single object variable to group related configuration together.
# variable "ec2_volume_size" {
#   type        = number
#   description = "The size in GB of the root block volume attached to managed EC2 instances."
# }

# variable "ec2_volume_type" {
#   type        = string
#   description = "The volume type between gp2 and gp3."
# }


variable "ec2_volume_config" {
  type = object({
    size = number
    type = string
  })

  description = "The size and type of the root block volume for EC2 instances."

  default = {
    size = 10
    type = "gp3"
  }
}


variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to apply to resources."
  default     = {}
}

variable "my_sensitive_value" {
  type = string
  sensitive = true
}