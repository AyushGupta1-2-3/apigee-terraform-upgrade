variable "project_id" {
  description = "Project id (also used for the Apigee Organization)."
  type        = string
}

variable "project_number" {
  description = "Number of the GCP Host Project where the Apigee Private Service Access Range and subnets for the Service Project have been defined.This is required because the 'project' module's 'project_reuse.use_data_source' is set to 'false', which bypasses its internal project number lookup and mandates explicit provision of project attributes"
  type        = number
}

variable "svc_prj_number" {
  description = "Number of the GCP Service Project that should host the Apigee X Organization. This is required because the 'shared_project' module's 'project_reuse.use_data_source' is set to 'false', which bypasses its internal project number lookup and mandates explicit provision of project attributes"
  type        = number
}


variable "svpc_host_project_id" {
  description = "Shared VPC Host Project id)."
  type        = string
  default     = ""
}

variable "ax_region" {
  description = "GCP region for storing Apigee analytics data (see https://cloud.google.com/apigee/docs/api-platform/get-started/install-cli)."
  type        = string
}

variable "apigee_envgroups" {
  description = "Apigee Environment Groups."
  type = map(object({
    environments = list(string)
    hostnames    = list(string)
  }))
  default = {}
}

variable "apigee_environments" {
  description = "Apigee Environment Names."
  type        = list(string)
  default     = []
}

variable "apigee_instances" {
  description = "Apigee Instances (only one for EVAL)."
  type = map(object({
    region       = string
    ip_range     = string
    environments = list(string)
  }))
  default = {}
}

variable "exposure_subnets" {
  description = "Subnets for exposing Apigee services"
  type = list(object({
    name               = string
    ip_cidr_range      = string
    region             = string
    secondary_ip_range = map(string)
  }))
  default = []
}

variable "network" {
  description = "VPC name."
  type        = string
}

/*
variable "peering_range" {
  description = "Peering CIDR range"
  type        = string
}

variable "support_range" {
  description = "Support CIDR range of length /28 (required by Apigee for troubleshooting purposes)."
  type        = string
}
*/

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "project_parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format."
  type        = string
  default     = null
  validation {
    condition     = var.project_parent == null || can(regex("(organizations|folders)/[0-9]+", var.project_parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

variable "vpc_psa_config_ranges" {
  description = "Map of CIDR ranges to use for Apigee service peering and support."
  type        = map(string)
}


variable "skip_delete" {
  description = "Deprecated. Use deletion_policy."
  type        = bool
  default     = null
}