module "host-project" {
  source              = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v16.0.0"

  name           = var.project_id
  project_create = false
  shared_vpc_host_config = {
    enabled          = true
    service_projects = [var.svc_prj_id]
  }
    services = [
    "servicenetworking.googleapis.com"
  ]
}

module "service-project" {
  source              = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v16.0.0"
  name           = var.svc_prj_id
  project_create = false
  auto_create_network = false
  shared_vpc_service_config = {
    attach               = true
    host_project         = module.host-project.project_id
    service_identity_iam = {}
  }
  services = [
    "apigee.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

module "shared-vpc" {
 source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc?ref=v16.0.0"
  project_id      = module.host-project.project_id
  name            = var.network
  subnets         = var.exposure_subnets
  shared_vpc_host = true
  shared_vpc_service_projects = [
    module.service-project.project_id
  ]
  iam = {
    for subnet in var.exposure_subnets :
    "${subnet.region}/${subnet.name}" =>
    {
      "roles/compute.networkUser" = [
        "serviceAccount:${module.service-project.service_accounts.cloud_services}"
      ]
    }
  }
  psa_config = {
    ranges = {
      apigee-range         = var.peering_range
      apigee-support-range = var.support_range
    }
    routes = null
  }
}
