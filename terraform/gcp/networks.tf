resource "google_compute_network" "vpc" {
  name                    = "terragoat-${var.environment}-network"
  description             = "Virtual vulnerable-by-design network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "terragoat-${var.environment}-public-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id

  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_firewall" "allow_http_https" {
  name          = "terragoat-${var.environment}-firewall"
  network       = google_compute_network.vpc.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "allow_ssh_restricted" {
  name          = "terragoat-${var.environment}-ssh-restricted"
  network       = google_compute_network.vpc.id
  source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
