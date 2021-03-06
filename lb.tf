resource "oci_load_balancer" "tcbLoadBalancer" {
  shape          = "10Mbps"
  compartment_id = var.compartment_ocid 
  subnet_ids     = [
    oci_core_subnet.tcb_subnet.id
  ]
  display_name   = "tcbLoadBalancer"
}

resource "oci_load_balancer_backendset" "tcbLoadBalancerBackendset" {
  name             = "tcbLBBackendset"
  load_balancer_id = oci_load_balancer.tcbLoadBalancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = "80"
    protocol = "HTTP"
    response_body_regex = ".*"
    url_path = "/"
  }
}


resource "oci_load_balancer_listener" "tcbLoadBalancerListener" {
  load_balancer_id         = oci_load_balancer.tcbLoadBalancer.id
  name                     = "tcbLoadBalancerListener"
  default_backend_set_name = oci_load_balancer_backendset.tcbLoadBalancerBackendset.name
  port                     = 80
  protocol                 = "HTTP"
}


resource "oci_load_balancer_backend" "tcbLoadBalancerBackend" {
  load_balancer_id = oci_load_balancer.tcbLoadBalancer.id
  backendset_name  = oci_load_balancer_backendset.tcbLoadBalancerBackendset.name
  ip_address       = element(oci_core_instance.webserver.*.private_ip, count.index)
  port             = 80 
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
  count            =  var.qtdevm
}
