# Input variable definitions
variable "base_domain" {
  description = "The base domain of the application. Should be a subdomain of an existing domain."
  type        = string
}

variable "app_subdomain" {
  description = "Application subdomain"
  type        = string
  default     = "demo"
}

variable "primary_subdomain" {
  description = "Primary deployment subdomain"
  type        = string
  default     = "aws"
}

variable "secondary_subdomain" {
  description = "Secondary deployment subdomain"
  type        = string
  default     = "gcp"
}

variable "app_primary_health_check_path" {
  description = ""
  type        = string
  default     = "/api/time"
}

variable "cloudfront_distribution" {
  description = "The cloudfront distribution for the primary deployment"
}


