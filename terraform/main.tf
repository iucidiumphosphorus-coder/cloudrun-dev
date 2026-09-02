resource "google_artifact_registry_repository" "repo" {
  provider      = google-beta
  location      = var.region
  repository_id = "cloudrun-repo"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_service" "default" {
  provider     = google-beta
  name         = "corporate-web-service"
  location     = var.region
  ingress      = "INGRESS_TRAFFIC_ALL"
  launch_stage = "BETA"
  iap_enabled  = true

  deletion_protection = false

  template {
    containers {
      image = var.container_image
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}

resource "google_cloud_run_v2_service_iam_member" "iap_invoker" {
  provider = google-beta
  project  = google_cloud_run_v2_service.default.project
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-iap.iam.gserviceaccount.com"
}

resource "google_cloud_run_v2_service_iam_member" "user_access" {
  for_each = toset(var.allowed_user_email)

  provider = google-beta
  project  = google_cloud_run_v2_service.default.project
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "user:${each.value}"
}

data "google_project" "project" {
  project_id = var.project_id
}
