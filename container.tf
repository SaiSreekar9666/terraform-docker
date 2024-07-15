resource "docker_container" "nginx_container" {
  image = docker_image.nginx.image_id
  name  = "n1"
   port{
    internal= 80
    external = 80
    }
}