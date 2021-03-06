resource "null_resource" "web-install" {
  count =  var.qtdevm

  connection {
    type        = "ssh"
    user        = "opc"
    host        = element(oci_core_instance.webserver.*.public_ip, count.index)
    private_key = var.ssh_private_key

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

