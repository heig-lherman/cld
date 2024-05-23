resource "google_compute_forwarding_rule" "http" {
  depends_on            = [google_compute_subnetwork.proxy]
  count                 = var.https ? 0 : 1
  name                  = "l7-xlb-forwarding-rule-http"
  project               = google_compute_subnetwork.default.project
  region                = google_compute_subnetwork.default.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.default.id
  ip_address            = google_compute_address.default.id
  network_tier          = "STANDARD"
}

resource "google_compute_region_target_http_proxy" "default" {
  project = google_compute_subnetwork.default.project
  region  = google_compute_subnetwork.default.region
  name    = "l7-xlb-proxy-http"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_region_url_map" "default" {
  depends_on      = [google_compute_region_backend_service.default]
  project         = google_compute_subnetwork.default.project
  region          = google_compute_subnetwork.default.region
  name            = "regional-l7-xlb-map-http"
  default_service = google_compute_region_backend_service.default.id

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.default.id
    path_rule {
      service = google_compute_region_backend_service.default.id
      paths   = ["/"]
      route_action {
        retry_policy {
          num_retries = 5
          per_try_timeout {
            seconds = 1
          }
          retry_conditions = ["5xx", "deadline-exceeded", "connect-failure"]
        }
      }
    }
  }
}
