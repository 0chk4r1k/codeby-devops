terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}
provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "lesson14_network" {
  name = "lesson14-network"
}

resource "yandex_vpc_subnet" "public_subnet" {
  name           = "lesson14-public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lesson14_network.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "private_subnet" {
  name           = "lesson14-private"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lesson14_network.id
  v4_cidr_blocks = ["10.10.2.0/24"]
}

resource "yandex_vpc_security_group" "public_sg" {
  name       = "lesson14-public-sg"
  network_id = yandex_vpc_network.lesson14_network.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private_sg" {
  name       = "lesson14-private-sg"
  network_id = yandex_vpc_network.lesson14_network.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "public_vm" {
  name = "lesson14-public-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/lesson14_key.pub")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/lesson14_key")
      host        = self.network_interface[0].nat_ip_address
    }
  }
}

resource "yandex_compute_instance" "private_vm" {
  name = "lesson14-private-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_subnet.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/lesson14_key.pub")}"
  }
}
