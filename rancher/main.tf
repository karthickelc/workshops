# RKE2 for Rancher Server

resource "ssh_resource" "rke2_for_rancher" {
  host        = var.node_public_ip
  user        = var.node_username
  private_key = var.ssh_private_key_pem

  commands = [
    templatefile(join("/", [path.module, "files/install_rke2.sh"]), {
      rancher_server_public_ip = var.node_public_ip
    })
  ]

}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    ssh_resource.rke2_for_rancher
  ]
  host = var.node_public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${var.node_public_ip}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.node_username
  private_key = var.ssh_private_key_pem
}


# Install cert-manager helm chart
resource "helm_release" "cert_manager" {
  repository       = "https://charts.jetstack.io"
  name             = "cert-manager"
  chart            = "cert-manager"
  version          = "v${var.cert_manager_version}"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true
  verify           = false

  set {
    name  = "installCRDs"
    value = "true"
  }
}


# Install Rancher helm chart
resource "helm_release" "rancher_server" {
  depends_on = [
    helm_release.cert_manager,
  ]

  repository       = "https://releases.rancher.com/server-charts/latest"
  name             = "rancher"
  chart            = "rancher"
  version          = var.rancher_version
  namespace        = "cattle-system"
  create_namespace = true
  wait             = true

  set {
    name  = "hostname"
    value = var.rancher_server_dns
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "bootstrapPassword"
    value = var.rancher_server_bootstrap_password # TODO: change this once the terraform provider has been updated with the new pw bootstrap logic
  }
}


# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {
  depends_on = [
    helm_release.rancher_server
  ]

  provider = rancher2.bootstrap

  initial_password = var.rancher_server_bootstrap_password
  password         = var.rancher_server_bootstrap_password
  telemetry        = true
}
