#create image nginx:
resource "docker_image" "nginx" {
  name = "nginx:latest"
}