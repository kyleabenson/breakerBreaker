resource "google_cloud_run_v2_service" "default" {
  name     = "backend-service"
  location = "us-central1"
  deletion_protection = false
  invoker_iam_disabled = true
  ingress = "INGRESS_TRAFFIC_ALL"
  template {
    containers {
      name = "backend"
      ports {
        container_port = 8000
      }
      image = "us-west1-docker.pkg.dev/kb-workspace/apprun-repo/apprun-backend:latest"
      depends_on = ["collector"]
      liveness_probe {
        http_get {
          path = "/health"
          port = 8000
        }
      }
      env {
        name = "OTEL_SERVICE_NAME"
        value = "backend"
      }
      env {
        name ="OTEL_TRACES_EXPORTER"
        value = "otlp"
      }
      env {
        name ="OTEL_METRICS_EXPORTER"
        value = "otlp"
      }
      env {
        name = "OTEL_EXPORTER_OTLP_ENDPOINT"
        value = "http://localhost:4317"
      }
    }
    containers {
      name = "collector"
      image = "us-docker.pkg.dev/cloud-ops-agents-artifacts/google-cloud-opentelemetry-collector/otelcol-google:0.126.0"
      args = ["--config=/etc/otelcol-google/config.yaml"]
      startup_probe {
        http_get {
          port = 13133
          path = "/"
        }
      }
      volume_mounts {
        mount_path = "/etc/otelcol-google"
        name = "config_bucket"
      }
    }
    volumes {
      name = "config_bucket"
      gcs {
        bucket = google_storage_bucket.default.name
        read_only = true
      }
    }
  }
}

resource "random_id" "bucket" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name = "my-bucket-${random_id.bucket.hex}"
  location = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "default" {
 name         = "config.yaml"
 source       = "config.yaml"
 content_type = "text/plain"
 bucket       = google_storage_bucket.default.id
}

resource "google_cloud_run_v2_job" "default" {
  provider = google-beta
  name     = "load-generator"
  location = "us-central1"
  deletion_protection = false
  start_execution_token = "start-once-created"
  template {
    template{
      containers {
        image = "us-west1-docker.pkg.dev/kb-workspace/apprun-repo/apprepo-generator:latest"
        env {
          name = "LOCUST_HOST"
          value = google_cloud_run_v2_service.default.uri
        }
        
      }
    }
  }
  depends_on = [google_cloud_run_v2_service.default]
}
