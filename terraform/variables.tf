variable "container_image" {
  type        = string
  description = "Container image to deploy"
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "asia-northeast1"
}

variable "allowed_user_email" {
  type        = list(string)
  description = "List of allowed user emails for IAP / Cloud Run access"
}
