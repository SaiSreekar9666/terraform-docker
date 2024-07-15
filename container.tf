resource "docker_container" "nginx_container" {
  image = docker_image.gsaisreekar9666/ecomm.image_id
  name  = "n1"
   ports{
    internal= 80
    external = 80
    }
}