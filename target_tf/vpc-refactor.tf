# Refactoring for resources in the host project
moved {
  from = module.host-project.google_project_iam_member.servicenetworking[0]
  to   = module.host-project.google_project_iam_member.service_agents["service-networking"]
}

moved {
  from = module.host-project.google_project_service_identity.servicenetworking[0]
  to   = module.host-project.google_project_service_identity.default["servicenetworking.googleapis.com"]
}

# Refactoring for resources in the service project
moved {
  from = module.service-project.google_project_iam_member.servicenetworking[0]
  to   = module.service-project.google_project_iam_member.service_agents["service-networking"]
}

moved {
  from = module.service-project.google_project_service_identity.servicenetworking[0]
  to   = module.service-project.google_project_service_identity.default["servicenetworking.googleapis.com"]
}



# Refactoring for PSA connection and routes
moved {
  from = module.shared-vpc.google_service_networking_connection.psa_connection["1"]
  to   = module.shared-vpc.google_service_networking_connection.psa_connection["servicenetworking.googleapis.com"]
}

moved {
  from = module.shared-vpc.google_compute_network_peering_routes_config.psa_routes["1"]
  to   = module.shared-vpc.google_compute_network_peering_routes_config.psa_routes["servicenetworking.googleapis.com"]
}