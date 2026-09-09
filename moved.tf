moved {
  from = google_compute_network.devops_vpc
  to   = module.network.google_compute_network.this
}

moved {
  from = google_compute_subnetwork.devops_subnet
  to   = module.network.google_compute_subnetwork.this
}
