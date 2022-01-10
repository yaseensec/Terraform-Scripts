resource "aws_key_pair" "web-key" {
  key_name = "web-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXxYaH6QyTnn+8vgNNnksQ8sLX5YePIFOR4ODt9zObY yaseen@DarkRose"
}

resource "aws_key_pair" "worker-key" {
  key_name = "worker-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUDeLe+Po51FSHoATHmPGuaXcTnjPKSFE6z716r4P1q yaseen@DarkRose"
}