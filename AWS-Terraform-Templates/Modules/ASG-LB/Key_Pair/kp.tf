resource "aws_key_pair" "staging-key" {
  key_name = "staging-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXxYaH6QyTnn+8vgNNnksQ8sLX5YePIFOR4ODt9zObY yaseen@DarkRose"
}

output "stagingkeypairid-output" {
    value = aws_key_pair.staging-key.id
}

resource "aws_key_pair" "production-key" {
  key_name = "prodcution-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUDeLe+Po51FSHoATHmPGuaXcTnjPKSFE6z716r4P1q yaseen@DarkRose"
}

output "productionkeypairid-output" {
    value = aws_key_pair.production-key.id
}