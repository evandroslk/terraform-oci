data "oci_objectstorage_namespace" "this" {
    compartment_id = var.tenancy_ocid
}

resource "oci_objectstorage_bucket" "this" {
    compartment_id = var.compartment_id
    name = "${var.app_name}-bucket"
    namespace = data.oci_objectstorage_namespace.this.namespace
}

resource "oci_objectstorage_preauthrequest" "this" {
    bucket = oci_objectstorage_bucket.this.name
    namespace = data.oci_objectstorage_namespace.this.namespace
    name = "${var.app_name}-PAR"
    time_expires = timeadd(timestamp(), "8760h") # 8760h = 365 dias
    access_type = "AnyObjectRead"

    lifecycle {
      ignore_changes = [ time_expires ]
    }
}