plugin "docker" {
  config {
    allow_privileged = true
    volumes {
      enabled = true
    }
  }
}
plugin "nomad-device-nvidia" {
  config {
    enabled            = true
  }
}
