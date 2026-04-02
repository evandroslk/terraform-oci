variable "tenancy_ocid" {
    description = "OCID do Tenancy"
    type = string
}

variable "compartment_id" {
    description = "OCID do Compartment utilizado para o projeto"
    type = string
}

variable "app_name" {
    description = "Nome da aplicação"
    type = string
}

variable "dns_label_vcn" {
    description = "Usado para montar o hostname DNS interno dos recursos dentro da VCN"
    type = string
}

variable "region" {
    description = "Região na qual serão criados os recursos"
    type = string
}