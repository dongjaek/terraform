variable "project" {
  default = "twitter-ads"
}
variable "region" {
  default = "us-east1"
}
variable "zones" {
  type = "list"
  default = [
    "us-east1-b",
    "us-east1-c",
    "us-east1-d"
  ]
}
variable "network" {
  default = "test"
}
variable "subnet" {
  default = "us-east1"
}
variable "images" {
  type = "map"
  default = {
    generic = "packer-generic-1485880506"
  }
}
variable "buckets" {
  type = "map"
  default = {
    boot_scripts = "tcdc-boot-scripts-devel"
  }
}
variable "tld" {
  default = "tcdc.io"
}
variable "dc" {
  default = "gue1"
}

provider "google" {
  credentials = "${file("~/dev/keys/twitter-ads-034a079e4c59.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
