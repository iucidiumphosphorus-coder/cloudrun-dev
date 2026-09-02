terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "bigquery-s3-cloudrun-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "bigquery-s3-cloudrun"
  region  = "asia-northeast1"
}
