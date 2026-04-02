locals {
  object_storage_base_url = "https://objectstorage.${var.region}.oraclecloud.com${oci_objectstorage_preauthrequest.this.access_uri}"

  file_type_routes = [
    { name = "js-rule", wildcard = "*.js" },
    { name = "css-rule", wildcard = "*.css" },
    { name = "html-rule", wildcard = "*.html" },
    { name = "json-rule", wildcard = "*.json" },
    { name = "png-rule", wildcard = "*.png" },
    { name = "svg-rule", wildcard = "*.svg" },
    { name = "ico-rule", wildcard = "*.ico" },
    { name = "map-rule", wildcard = "*.map" },
    { name = "txt-rule", wildcard = "*.txt" },
  ]
}

resource "oci_apigateway_gateway" "this" {
    compartment_id = var.compartment_id
    display_name = "${var.app_name}-gateway"
    endpoint_type = "PUBLIC"
    subnet_id = oci_core_subnet.public_subnet.id
}

resource "oci_apigateway_deployment" "this" {
    compartment_id = var.compartment_id
    display_name = "${var.app_name}-deployment"
    gateway_id = oci_apigateway_gateway.this.id
    path_prefix = "/"

    specification {
      routes {
        path = "/{req*}"
        methods = ["GET"]

        backend {
          type = "DYNAMIC_ROUTING_BACKEND"

          selection_source {
            type      = "SINGLE"
            selector  = "request.path[req]"
          }

          routing_backends {
            key {
              type = "ANY_OF"
              name = "default"
              is_default = true
              values = []
            }

            backend {
              type = "HTTP_BACKEND"
              url = "${local.object_storage_base_url}index.html"
            }
          }
          
          dynamic "routing_backends" {
            for_each = local.file_type_routes

            content {
              key {
                type = "WILDCARD"
                name = routing_backends.value.name
                expression = routing_backends.value.wildcard
                is_default = false
              }

              backend {
                type = "HTTP_BACKEND"
                url = "${local.object_storage_base_url}$${request.path[req]}"
              }
            }
          }
        }
      }
    }
}