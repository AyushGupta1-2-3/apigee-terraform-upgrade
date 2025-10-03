/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  subnet_region_name = { for subnet in var.exposure_subnets :
    subnet.region => "${subnet.region}/${subnet.name}"
  }
  svpc_host_project_id = var.svpc_host_project_id != "" ? var.svpc_host_project_id : join("-", ["host", var.project_id])
}


module "nip-development-hostname" {
  source             = "./modules/nip-development-hostname"
  project_id         = module.service-project.project_id
  address_name       = "apigee-external"
  subdomain_prefixes = [for name, _ in var.apigee_envgroups : name]
}

module "apigee-x-core" {
  source              = "./modules/apigee-x-core"
  project_id          = module.service-project.project_id
  ax_region           = var.ax_region
  apigee_environments = var.apigee_environments
  apigee_instances    = var.apigee_instances
  apigee_envgroups = {
    for name, env_group in var.apigee_envgroups : name => {
      hostnames = concat(env_group.hostnames, ["${name}.${module.nip-development-hostname.hostname}"])
    }
  }
  network = module.shared-vpc.network.id
}



