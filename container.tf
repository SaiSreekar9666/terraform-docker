resource "docker_container" "nginx_container" {
  image = docker_image.nginx.image_id
  name  = "n1"
}