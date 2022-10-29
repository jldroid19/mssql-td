terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "mssql" {
  name         = "mcr.microsoft.com/mssql/server:2019-latest"
  keep_locally = true
}

resource "docker_container" "mssql" {
  image = docker_image.mssql.name
  name  = var.container_name
  env   = ["ACCEPT_EULA=Y", "MSSQL_SA_PASSWORD=Password1!"]

  provisioner "local-exec" {
    command = "sh ./database.sh"
  }
}
