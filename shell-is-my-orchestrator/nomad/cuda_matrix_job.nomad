job "cuda_matrix_mult" {
  datacenters = ["dc1"]
  type        = "batch"

  group "matrix" {
    count = 1

    task "matrix_mult" {
      driver = "docker"

      config {
        image = "nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda12.5.0-ubi8"
        args = [ "./vectorAdd" ]
        runtime = "nvidia"
      }

      resources {
        cpu    = 500  # 500 MHz
        memory = 512  # 512 MB
        device "nvidia/gpu" {
          count = 1
        }
      }
    }
  }
}
