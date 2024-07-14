
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
  provisioner "file" {
    connection {
      type     = "SSH"
      user     = "testadmin"
      password = "Password1234!"
      host     = azurerm_public_ip.main.ip_address
    }
    content     = <<-EOF
      <html>
      <head>
          <title>Welcome to Nginx!</title>
      </head>
      <body>
          <h1>Success! The Nginx web server is installed and working!</h1>
      </body>
      </html>
      EOF
    destination = "/home/testadmin/index.html"
  }

  provisioner "remote-exec" {
    connection {
      type     = "SSH"
      user     = "testadmin"
      password = "Password1234!"
      host     = azurerm_public_ip.main.ip_address
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "cat /home/testadmin/index.html"
    ]
  }
}
