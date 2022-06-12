resource "google_compute_firewall" "web" {
  name    = "web-fw-allow-ssh-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  direction = "INGRESS"

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["web-server"]
}