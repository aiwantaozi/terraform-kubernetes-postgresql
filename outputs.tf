output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = var.context
}

output "selector" {
  description = "The selector, a map, which is used for dependencies or collaborations."
  value       = local.labels
}

output "endpoint_internal" {
  description = "The internal endpoints, a string list, which are used for internal access."
  value       = [format("%s-primary.%s.svc.%s:5432", local.name, local.namespace, local.domain_suffix)]
}

output "endpoint_internal_readonly" {
  description = "The internal readonly endpoints, a string list, which are used for internal readonly access."
  value       = var.architecture == "replication" ? [format("%s-secondary.%s.svc.%s:5432", local.name, local.namespace, local.domain_suffix)] : []
}

output "database" {
  description = "The name of database to access."
  value       = var.database
}

output "username" {
  description = "The username of the account to access the database."
  value       = var.username
}

output "password" {
  description = "The password of the account to access the database."
  value       = local.password
  sensitive   = true
}
