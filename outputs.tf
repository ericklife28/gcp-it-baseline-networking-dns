output "managed_zone_id" {
  value = google_dns_managed_zone.cloud_dns_zone[0]
}