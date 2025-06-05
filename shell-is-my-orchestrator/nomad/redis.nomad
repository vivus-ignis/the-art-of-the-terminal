job "redis" {
  datacenters = ["dc1"]
  type        = "service"

  group "redis" {
    network {
      mode = "host"
      port "db" { 
        to = 6379
        static = 6379    # listen to a port and don't use dynamic port mapping
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:8.0.1"
        ports = ["db"]   # without this, nothing is exposed!
      }

      service {
        name     = "redis"
        provider = "nomad"
        port     = "db"
      }
    }
  }
}
