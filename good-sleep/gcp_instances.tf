resource "google_compute_instance" "good-sleep-wp" {
  name         = "good-sleep-wp"
  machine_type = "f1-micro"
  zone         = "asia-northeast1-a"
  description  = "wp ap server"
  tags         = ["wp-app"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  attached_disk {
    source = "good-sleep-disk"
    mode   = "READ_WRITE"
  }

  network_interface {
    access_config {
      nat_ip = "${google_compute_address.good-sleep-address.address}"
    }

    subnetwork = "${google_compute_subnetwork.good-sleep-sub-nw.name}"
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/sqlservice.admin",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }
}

