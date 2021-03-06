module "zookeeper_application" {
  source = "./puppet_cluster"

  role = "zookeeper"
  subrole = "application"
  image = "${var.images["generic"]}"
  dns_alias = "application.zk"
  frontend_lb = "applicationui.zk"
  lb_port = "80"

  project = "${var.project}"
  zones = "${var.zones}"
  region = "${var.region}"
  network = "${var.network}"
  subnet = "${var.subnet}"
  bootscript_bucket = "${var.buckets["boot_scripts"]}"
  region_dns_suffix = "${google_dns_managed_zone.region_dns.dns_name}"
  region_dns_zone_name = "${google_dns_managed_zone.region_dns.name}"
}

resource "google_compute_firewall" "zookeeper_application_allow_self" {
  name    = "zookeeper-application-allow-self"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_tags = ["zookeeper-application"]
  target_tags = ["zookeeper-application"]
}