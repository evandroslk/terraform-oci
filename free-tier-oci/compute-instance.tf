resource "oci_core_instance" "vm-arm" {
  availability_domain = "zHVN:PHX-AD-1"
  compartment_id      = var.compartment_id
  display_name        = "ubuntu-server"

  shape = "VM.Standard.A1.Flex"

  shape_config {
    ocpus = "4"
    memory_in_gbs = "24"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.phx.aaaaaaaaxxtzpqcpr4ptzpbmr6w34zu6g4zefslot6opok4gkxzifwcp47uq"
  }

}