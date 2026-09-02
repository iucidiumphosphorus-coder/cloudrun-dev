variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "allowed_user_email" {
  type        = list(string)
  description = "IAPでアクセスを許可するユーザーのGoogleアカウントのリスト"
}
