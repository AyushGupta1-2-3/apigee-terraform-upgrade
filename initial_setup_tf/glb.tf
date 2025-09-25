module "mig-l7xlb" {
  source          = "./modules/mig-l7xlb"
  project_id      = module.service-project.project_id
  name            = "apigee-xlb"
  backend_migs    = [for _, mig in module.apigee-x-bridge-mig : mig.instance_group]
  ssl_certificate = [module.nip-development-hostname.ssl_certificate]
  external_ip     = module.nip-development-hostname.ip_address
}