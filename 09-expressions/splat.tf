locals {
  firstnames_from_splat = var.objects_list[*].firstname
  #   Cannot use splat with maps, only lists. We can use for expressions to achieve the same result.
  #   roles_from_splat      = local.users_map2[*].roles
  roles_from_splat        = [for username, user_props in local.users_map2 : user_props.roles]
  roles_from_splat_values = values(local.users_map2)[*].roles

}

output "firstnames_from_splat" {
  value = local.firstnames_from_splat
}

output "roles_from_splat" {
  value = local.roles_from_splat
}

output "roles_from_splat_values" {
  value = local.roles_from_splat_values
}