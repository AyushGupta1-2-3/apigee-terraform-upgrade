locals {
  subnet_region_name = { for subnet in var.exposure_subnets :
    subnet.region => "${subnet.region}/${subnet.name}"
    
  }
  svpc_host_project_id = var.svpc_host_project_id != "" ? var.svpc_host_project_id : join("-", ["host", var.project_id])

  subnets_with_iam = [
    for subnet in var.exposure_subnets : merge(subnet, {
      iam = {
        "roles/compute.networkUser" = [
          "serviceAccount:${module.service-project.service_agents.cloudservices.iam_email}"
        ]
      }
    })
  ]
}

module "host-project" {
  source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v42.0.0"
  name            = local.svpc_host_project_id
  parent          = var.project_parent
  billing_account = var.billing_account
  project_reuse = {
    use_data_source = false
    attributes = {
      name   = var.project_id
      number = var.project_number
    }
  }

  shared_vpc_host_config = {
    enabled          = true
    service_projects = [] # defined later
  }
  services = [
    "servicenetworking.googleapis.com"
  ]

}

module "service-project" {
  source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v42.0.0"
  name            = var.project_id
  parent          = var.project_parent
  billing_account = var.billing_account
  project_reuse = {
    use_data_source = false
    attributes = {
      name   = var.svpc_host_project_id
      number = var.svc_prj_number
    }
  }
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
  source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc?ref=v42.0.0"
  project_id      = module.host-project.project_id
  name            = var.network
  subnets         = var.exposure_subnets
  shared_vpc_host = true
  shared_vpc_service_projects = [
    module.service-project.project_id
  ]

  create_googleapis_routes = null

  psa_configs = [{
    ranges       = var.vpc_psa_config_ranges
    range_prefix = ""
  }]
}
