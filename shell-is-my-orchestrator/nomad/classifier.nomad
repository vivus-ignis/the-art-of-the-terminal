job "classifier" {
  datacenters = ["dc1"]
  type        = "batch"

  parameterized {
    payload       = "forbidden"
    meta_required = ["SEQUENCE", "LABELS"]
  }

  group "genai" {
    count = 1

    task "classify" {
      driver = "docker"

      config {
        image = "classifier:local"
        force_pull = false
        runtime = "nvidia"
      }

      template {
        data = <<EOH
{{ range nomadService "redis" }}
REDIS_HOST={{ .Address }}
{{ end }}
      EOH
        destination = "local/env.txt"
        env         = true
      }

      resources {
        cpu    = 1000  # 1 GHz
        memory = 2048  # 2 GB
        device "nvidia/gpu" {
          count = 1
        }
      }
    }
  }
}
