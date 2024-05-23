resource "google_compute_subnetwork" "default" {
  depends_on    = [google_compute_network.default]
  name          = "${var.gke_cluster_name}-subnet"
  project       = google_compute_network.default.project
  region        = var.region
  network       = google_compute_network.default.name
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_container_cluster" "default" {
  provider           = google-beta
  project            = var.project_id
  name               = var.gke_cluster_name
  location           = var.zone
  initial_node_count = var.num_nodes
  networking_mode    = "VPC_NATIVE"
  network            = google_compute_network.default.name
  subnetwork         = google_compute_subnetwork.default.name
  logging_service    = "none"

  node_config {
    spot         = true
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    tags         = ["${var.gke_cluster_name}"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.16/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "5.0.0.0/16"
    services_ipv4_cidr_block = "5.1.0.0/16"
  }

  default_snat_status {
    disabled = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "World"
    }
  }
}

resource "time_sleep" "wait_for_kube" {
  depends_on      = [google_container_cluster.default]
  create_duration = "30s"
}

resource "null_resource" "local_k8s_context" {
  depends_on = [time_sleep.wait_for_kube]
  provisioner "local-exec" {
    command = "for i in 1 2 3 4 5; do gcloud container clusters get-credentials ${var.gke_cluster_name} --project=${var.project_id} --zone=${var.zone} && break || sleep 60; done"
  }
}
