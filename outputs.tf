output "ips_VMS" {
   value = [oci_core_instance.webserver.*.public_ip]
}


output "public_ip_LB" {
   value = [oci_load_balancer.tcbLoadBalancer.ip_addresses]
}