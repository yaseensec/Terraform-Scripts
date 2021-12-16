resource "aws_key_pair" "terraform-key" {
  key_name = "terraform-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXxYaH6QyTnn+8vgNNnksQ8sLX5YePIFOR4ODt9zObY yaseen@DarkRose"
}

output "key-pair-id-output" {
    value = aws_key_pair.terraform-key.id
}