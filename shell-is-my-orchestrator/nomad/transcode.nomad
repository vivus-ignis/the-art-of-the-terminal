job "transcode" {
  type        = "batch"
  datacenters = ["dc1"]

  meta {
    input   = ""
    profile = "small"
  }

  parameterized {
    meta_required = ["input"]
    meta_optional = ["profile"]
  }

  task "tc" {
    driver = "exec"

    config {
      command = "transcode.sh"
      args    = ["${NOMAD_META_INPUT}", "${NOMAD_META_PROFILE}"]
    }

    resources {
      cpu    = 1000
      memory = 256
    }
  }
}
