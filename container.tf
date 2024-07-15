resource "docker_container" "nginx_container" {
  image = docker_image.nginx.image_id
  name  = "n1"
   port {
      port        = 80
      target_port = 80
    }
}