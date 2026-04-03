variable "tenancy_ocid" {
    description = "OCID do Tenancy"
    type = string
}

variable "compartment_id" {
    description = "OCID do Compartment utilizado para o projeto"
    type = string
}

variable "region" {
    description = "Região na qual serão criados os recursos"
    type = string
}