# Input variable definitions

variable "authorized_IAM_arn" {
  description = "Authorized terraform user/roles IAM arn"
  type        = list(string)
}

variable "root_IAM_arn" {
  description = "Root IAM arn"
  type        = list(string)
}
