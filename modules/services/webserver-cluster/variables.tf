# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "state-bucket-122022"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-stores/mysql/terraform.tfstate"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "jacks_security_group_name" {
  description = "Group name for instance(s)"
  type        = string
  default     = "basic_group"
}

variable "server_port" {
  description = "Port number used for HTTP requests"
  type        = number
  default     = 8088
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = "albie-the-dragon-01"
}

variable "instance_security_group_name" {
  description = "The name of the good ol group"
  type        = string
  default     = "one_abnormal_group_01"
}

variable "cluster_name" {
  description = "Name for use on all cluster resources"
  type        = string
}

variable "instance_type" {
  description = "The type of instance running; e.g. t2.micro"
  type = string
}

variable "min_size" {
  description = "the minimum # of instances in a cluster"
  type = number
}
variable "max_size" {
  description = "the maximum # of instances in a cluster"
  type = number
}