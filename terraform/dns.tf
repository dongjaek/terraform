resource google_dns_managed_zone "region_dns" {
  name = "tcdc-${var.region}-${var.dc}"
  dns_name = "${var.dc}.tcdc.io."
}