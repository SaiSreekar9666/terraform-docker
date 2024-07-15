#create image nginx:
resource "docker_image" "ecomm" {
  name = "gsaisreekar9666/ecomm"
}
#build the image
resource "docker_image" "ecomm" {
  name = "ecomm"
  build {
    context = "."
    tag     = ["gsaisreekar9666/ecomm1"]
    label = {
      author : "sai"
    }
  }
}