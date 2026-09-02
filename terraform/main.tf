# 0. コンテナイメージを保存するArtifactRegistryの作成
resource "google_artifact_registry_repository" "repo" {
  provider      = google-beta
  location      = "asia-northeast1"
  repository_id = "cloudrun-repo"
  format        = "DOCKER"
}

# 1. Cloud Runサービスの定義（Nginxコンテナのデプロイ ＋ IAP有効化）
resource "google_cloud_run_v2_service" "default" {
  provider     = google-beta
  name         = "corporate-web-service"
  location     = "asia-northeast1"
  ingress      = "INGRESS_TRAFFIC_ALL"
  launch_stage = "BETA"
  iap_enabled  = true

  deletion_protection = false

  template {
    containers {
      image = "asia-northeast1-docker.pkg.dev/bigquery-s3-cloudrun/cloudrun-repo/my-web-app:latest"
    }
  }

  depends_on = [google_artifact_registry_repository.repo]
}

# 2. IAPサービスエージェントにCloud Runの実行権限を付与
resource "google_cloud_run_v2_service_iam_member" "iap_invoker" {
  provider = google-beta
  project  = google_cloud_run_v2_service.default.project
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-iap.iam.gserviceaccount.com"
}

# 3. アクセスを許可する特定の人間（複数人）に「閲覧権限」を一括付与
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
  project_id = "bigquery-s3-cloudrun"
}
