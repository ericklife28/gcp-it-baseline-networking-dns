resource "google_dns_managed_zone" "managedservices_zone" {
  name        = "managedservices-zone"
  dns_name    = "gcp.mcc.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.services.outputs.network.id
    }
  }

  project = var.gcp_project_id
}


resource "google_dns_record_set" "redis" {
  name = "redis.${google_dns_managed_zone.managedservices_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.managedservices_zone.name

  rrdatas = [module.redis.ip_address]

  project = var.gcp_project_id
}