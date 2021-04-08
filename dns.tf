
resource "oci_dns_zone" "zone1" {
    compartment_id = var.compartment_ocid
    name = var.domain
    zone_type = "PRIMARY"

}

resource "oci_dns_rrset" "web" {
    domain = "niture.${var.domain}"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.zone1.id
    
    compartment_id = var.compartment_ocid
    items {
        domain = "niture.${var.domain}"
        rdata = var.iplb
        rtype = "A"
        ttl = "300"
    }

}
