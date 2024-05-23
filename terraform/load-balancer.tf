resource "google_compute_subnetwork" "proxy" {
  depends_on    = [google_compute_network.default]
  provider      = google-beta
  name          = "proxy-only-subnet"
  ip_cidr_range = "11.129.0.0/23"
  project       = google_compute_network.default.project
  region        = var.region
  network       = google_compute_network.default.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

resource "google_compute_region_backend_service" "default" {
  depends_on  = [null_resource.gloo, null_resource.delete_ingressgateway]
  project     = google_compute_subnetwork.default.project
  region      = google_compute_subnetwork.default.region
  name        = "l7-xlb-backend-service-http"
  protocol    = "HTTP"
  timeout_sec = 10

  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.default.id]

  backend {
    group                 = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/zones/${var.zone}/networkEndpointGroups/ingressgateway"
    capacity_scaler       = 1
    balancing_mode        = "RATE"
    max_rate_per_endpoint = 3500
  }

  circuit_breakers {
    max_retries = 10
  }

  outlier_detection {
    consecutive_errors = 2
    base_ejection_time {
      seconds = 30
    }
    interval {
      seconds = 1
    }
    max_ejection_percent = 50
  }
}

resource "null_resource" "delete_ingressgateway" {
  provisioner "local-exec" {
    when    = destroy
    command = "gcloud compute network-endpoint-groups delete ingressgateway --quiet"
  }
}

resource "google_compute_region_health_check" "default" {
  depends_on = [google_compute_firewall.default]
  project    = google_compute_subnetwork.default.project
  region     = google_compute_subnetwork.default.region
  name       = "l7-xlb-basic-check-http"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
    request_path       = "/"
  }
  timeout_sec         = 1
  check_interval_sec  = 3
  healthy_threshold   = 1
  unhealthy_threshold = 1
}

resource "google_compute_address" "default" {
  name         = var.ip_address_name
  project      = google_compute_subnetwork.default.project
  region       = google_compute_subnetwork.default.region
  network_tier = "STANDARD"
}

resource "google_compute_firewall" "default" {
  name          = "fw-allow-health-check-and-proxy"
  network       = google_compute_network.default.id
  project       = google_compute_network.default.project
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "11.129.0.0/23"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["${var.gke_cluster_name}"]
  direction   = "INGRESS"
}
