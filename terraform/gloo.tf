resource "null_resource" "gloo" {
  depends_on = [null_resource.local_k8s_context]
  provisioner "local-exec" {
    command = "./scripts/install-gloo.sh"
  }
}
