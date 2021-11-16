resource "random_string" "random" {
  length  = 4
  lower   = true
  special = false
  upper   = false
}