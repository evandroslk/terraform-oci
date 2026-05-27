terraform {
  backend "oci" {
    bucket                      = "terraform-state-free-tier"
    key                         = "prod/terraform.tfstate"
    region                      = "us-phoenix-1"
    namespace                   = "axkwrxdchqxx"
  }
}
provider "oci" {
  config_file_profile = "DEFAULT"
}