


module "nip-development-hostname" {
  source             = "github.com/apigee/terraform-modules/modules/nip-development-hostname?ref=v0.12.0"
  project_id         = module.service-project.project_id
  address_name       = "apigee-external"
  subdomain_prefixes = [for name, _ in var.apigee_envgroups : name]
}

module "apigee-x-core" {
  source              = "github.com/apigee/terraform-modules/modules/apigee-x-core?ref=v0.12.0"
  project_id          = module.service-project.project_id
  ax_region           = var.ax_region
  apigee_instances    = var.apigee_instances
  apigee_environments = var.apigee_environments
  apigee_envgroups = {
    for name, env_group in var.apigee_envgroups : name => {
      environments = env_group.environments
      hostnames    = concat(env_group.hostnames, ["${name}.${module.nip-development-hostname.hostname}"])
    }
  }
  network = module.shared-vpc.network.id
}
