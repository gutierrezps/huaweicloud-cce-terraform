module "cce" {
  source = "./module/cce"

  cce_node_password = var.cce_node_password
  obs_bucket_name   = var.obs_bucket_name

  create_elb = var.create_elb
  create_nat = var.create_nat
  create_obs = var.create_obs
}

data "huaweicloud_identity_agencies" "authorized" {
  for_each = toset(var.cce_authorized_agencies)
  name = each.value
}

data "huaweicloud_identity_users" "authorized" {
  for_each = toset(var.cce_authorized_users)
  name = each.value
}

locals {
  authorized_agencies_ids = [
    for agency_data_source in values(data.huaweicloud_identity_agencies.authorized) :
    agency_data_source.agencies[0].id
    if length(agency_data_source.agencies) > 0
  ]
  authorized_users_ids = [
    for user_data_source in values(data.huaweicloud_identity_users.authorized) :
    user_data_source.users[0].id
    if length(user_data_source.users) > 0
  ]
}

module "k8s" {
  source = "./module/k8s"

  cluster_admin_user_ids = concat(
    local.authorized_agencies_ids,
    local.authorized_users_ids
  )
}