resource "google_compute_instance_template" "template" {
  name_prefix = "tcdc-${var.role}-${var.subrole}-"
  tags = ["${var.role}-${var.subrole}"]
  machine_type = "${var.instance_type}"
  region = "${var.region}"

  disk {
    source_image = "${var.image}"
    auto_delete = true
    boot = true
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = "${var.subnet}",
    subnetwork_project = "${var.project}"
    access_config {}
  }

  metadata =
  "${
    merge(
      map(
        "puppet_role", "${coalesce("${var.role_override}", "${var.role}")}",
        "puppet_subrole", "${var.subrole}",
        "puppet_environment", "${var.environment}",
        "startup-script-url", "gs://${var.bootscript_bucket}/boot.py"
      ),
      map(
        "${var.dns_alias != "" ? "dns-alias" : "no-dns-alias" }", "${var.role}_${var.subrole}"
      )
    )
  }"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "group" {
  count = "${length(var.zones)}"
  name = "tcdc-${var.role}-${var.subrole}-${element(var.zones, count.index)}"

  base_instance_name = "tcdc-${var.role}-${var.subrole}-${element(var.zones, count.index)}"
  instance_template  = "${google_compute_instance_template.template.self_link}"
  update_strategy    = "NONE"
  zone               = "${element(var.zones, count.index)}"

  target_size  = 1
}