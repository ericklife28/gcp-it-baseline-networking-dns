data "terraform_remote_state" "trs_net_vpcs" {
  backend = "gcs"
  config = {
    bucket = "${var.organization}-gcs-it-trf-net-eus1-001"
    prefix = "gcp-it-baseline-networking-vcp/net"
  }
}

resource "google_dns_managed_zone" "cloud_dns_zone" {
  count       = var.deploy ? 1 : 0
  name        = "${var.organization}-dns-it-trf-${var.environment}-eus1-001"
  project     = var.project_id
  dns_name    = "${var.environment}.${var.organization}.cloud"
  visibility  = "private"
  description = "Private DNS zone for the ${var.environment} environment"
  labels = {
    env = "${var.environment}"
  }

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.trs_net_vpcs.outputs.networks[var.environment][0].id //[]
    }
  }

}

/*
resource "google_dns_record_set" "vpc_a_record" {
  count = var.deploy ? 1 : 0
  name = "${var.organization}-rcrd-it-trf-${var.environment}-eus1-001"
  type = "A"
  ttl  = 300
  project = var.project_id

  managed_zone = google_dns_managed_zone.cloud_dns_zone.name

  rrdatas = [data.terraform_remote_state.trs_net_vpcs.networks[var.environment].ip_range]

}*/
