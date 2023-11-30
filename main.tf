variable "docker_image_tag" {
  description = "The tag of the Docker image"
  type        = string
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13"
    }
  }
}

provider "docker" {
  # Configuration du provider
}

resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_image" "api_image" {
  name = "taherjerbiinsat/docker-tp-api:${var.docker_image_tag}"
}

resource "docker_image" "myblog_image" {
  name = "taherjerbiinsat/docker-tp-myblog:${var.docker_image_tag}"
}


resource "docker_container" "api_container" {
  image = docker_image.api_image.latest
  name  = "api"
  networks_advanced {
    name = docker_network.app_network.name
  }
  ports {
    internal = 4000
    external = 4000
  }
}

resource "docker_container" "myblog_container" {
  image = docker_image.myblog_image.latest
  name  = "myblog"
  networks_advanced {
    name = docker_network.app_network.name
  }
  ports {
    internal = 3000
    external = 3000
  }
  stdin_open = true
}