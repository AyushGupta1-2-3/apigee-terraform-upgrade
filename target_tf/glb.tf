module "apigee-x-bridge-mig" {
  for_each    = var.apigee_instances
  source      = "github.com/apigee/terraform-modules/modules/apigee-x-bridge-mig?ref=v0.12.0"
  project_id  = module.service-project.project_id
  network     = module.shared-vpc.network.id
  subnet      = module.shared-vpc.subnet_self_links[local.subnet_region_name[each.value.region]]
  region      = each.value.region
  endpoint_ip = module.apigee-x-core.instance_endpoints[each.key]
}