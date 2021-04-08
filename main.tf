data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_region_mapping[var.region]
}


resource "oci_core_instance" "webserver1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "webserver1"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.tcb_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "webserver1"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}


resource "null_resource" "web-install" {

  connection {
    type        = "ssh"
    user        = "ocp"
    password    = ""
    host        =  oci_core_instance.webserver1.public_ip
    private_key = var.ssh_public_key

  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Aguarde finalizando a VM...'; sleep 1; done",
      "sudo yum install httpd -y",
      "sudo firewall-cmd --zone=public --add-service=http",
      "sudo firewall-cmd --permanent --zone=public --add-service=http",
      "cd /var/www/html/",
      "sudo wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/u8j40_AS-7pRypC5boQT24w5QFPDTy-0j27BWBOfmsxbERTiuDtJQBIqfcsOH81F/n/idqfa2z2mift/b/bootcamp-oci/o/oci-f-handson-modulo-compute-website-files.zip",
      "sudo sleep 5",
      "sudo unzip oci-f-handson-modulo-compute-website-files.zip",
      "sudo chown -R apache:apache /var/www/html",
      "sudo rm -rf oci-f-handson-modulo-compute-website-files.zip",
      "sudo systemctl start httpd",
      "sudo sleep 2",
      "sudo systemctl enable httpd",  
    ]
  }
}

