data "terraform_remote_state" "trs_net_vpcs" {
  backend = "gcs"
  config = {
    bucket = "${var.organization}-gcs-it-trf-net-eus1-001"
    prefix = "gcp-it-baseline-networking-vcp/net"
  }
}

