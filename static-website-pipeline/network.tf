resource "oci_core_vcn" "this" {
    compartment_id = var.compartment_id
    display_name = "${var.app_name}-vcn"
    cidr_block = "10.40.0.0/16"
    dns_label = var.dns_label_vcn
}

resource "oci_core_internet_gateway" "this" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "${var.app_name}-igw"
    enabled = true
}

resource "oci_core_route_table" "public_rt" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "public-rt"

    route_rules {
      destination = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.this.id
    }
}

resource "oci_core_security_list" "public_sl" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "public-sl"

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

    egress_security_rules {
      protocol = "all"
      destination = "0.0.0.0/0"
      stateless = false
    }
}

resource "oci_core_subnet" "public_subnet" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.this.id
    display_name = "${var.app_name}-public-subnet"
    cidr_block = "10.40.0.0/24"
    dns_label = "publicsubnet"
    route_table_id = oci_core_route_table.public_rt.id
    security_list_ids = [oci_core_security_list.public_sl.id]
}