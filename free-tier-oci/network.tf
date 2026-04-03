resource "oci_core_vcn" "this" {
    compartment_id = var.compartment_id
    display_name = "evandro-vcn"
    cidr_block = "10.90.0.0/24"
    dns_label = "evandrovcn"
}

resource "oci_core_internet_gateway" "this" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "igw-evandro"
    enabled = true
}

# Recursos da Subnet Pública

resource "oci_core_route_table" "public_rt" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "rt-publica"

    route_rules {
      destination = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.this.id
    }
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

resource "oci_core_security_list" "public_sl" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "sl-public"

    ingress_security_rules {
      protocol = "6" #TCP
      source = "0.0.0.0/0"
      stateless = false

      tcp_options {
        min = 443
        max = 443
      }
    }

    ingress_security_rules {
      protocol = "6"
      source = "0.0.0.0/0"
      stateless = false

      tcp_options {
        min = 80
        max = 80
      }
    }

    ingress_security_rules {
      protocol = "6"
      source = "${chomp(data.http.my_ip.response_body)}/32"
      stateless = false

      tcp_options {
        min = 22
        max = 22
      }
    }

    ingress_security_rules {
      protocol = "6"
      source = "${chomp(data.http.my_ip.response_body)}/32"
      stateless = false

      tcp_options {
        min = 8080
        max = 8080
      }
    }

    egress_security_rules {
      protocol = "all"
      destination = "0.0.0.0/0"
      stateless = false
    }
}

resource "oci_core_subnet" "public_subnet" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "subnet-publica"
    cidr_block = "10.90.0.0/26"
    dns_label = "subnetpublica"
    route_table_id = oci_core_route_table.public_rt.id
    security_list_ids = [oci_core_security_list.public_sl.id]
}

# Recursos da Subnet Privada

resource "oci_core_route_table" "private_rt" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "rt-private"
}

resource "oci_core_security_list" "private_sl" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "sl-private"

    egress_security_rules {
      protocol = "all"
      destination = "0.0.0.0/0"
      stateless = false
    }
}

resource "oci_core_subnet" "private_subnet" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "subnet-privada"
    cidr_block = "10.90.0.64/26"
    dns_label = "subnetprivada"
    route_table_id = oci_core_route_table.private_rt.id
    security_list_ids = [oci_core_security_list.private_sl.id]
}