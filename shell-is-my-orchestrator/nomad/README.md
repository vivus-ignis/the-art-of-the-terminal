## Nomad

### Installation & basic setup

```bash
wget https://releases.hashicorp.com/nomad/1.10.1/nomad_1.10.1_linux_amd64.zip
unzip nomad_1.10.1_linux_amd64.zip
sudo cp nomad /usr/local/bin/
wget https://releases.hashicorp.com/nomad-device-nvidia/1.1.0/nomad-device-nvidia_1.1.0_linux_amd64.zip
unzip nomad-device-nvidia_1.1.0_linux_amd64.zip
sudo mkdir -p /usr/local/nomad/plugins
sudo cp nomad-device-nvidia /usr/local/nomad/plugins/
```

Create a file `/usr/local/etc/nomad.hcl`:

```hcl
plugin "nomad-device-nvidia" {
  config {
    enabled = true
  }
}
```

### Starting nomad in "dev" mode (for experimentation only)

```bash
sudo nomad agent -dev -bind 0.0.0.0 -network-interface=eno1 -plugin-dir=/usr/local/nomad/plugins -config=/usr/local/etc/nomad.hcl
```

Replace `eno0` with the name of any non-loopback interface.

### Confirming nomad GPU setup works

Please note: CUDA drivers and nvidia container toolkit have to be installed beforehand.

```bash
nomad job plan cuda_matrix_job.nomad
nomad job run cuda_matrix_job.nomad
nomad job status
nomad job status cuda_matrix_mult
nomad alloc status <alloc_id>
nomad alloc logs <alloc_id>
```

### Deploying redis service

```bash
nomad run redis.nomad
nomad service info redis
```

### Running classifier demo

```bash
docker build -t classifier:local .
nomad plan classifier.nomad
nomad run classifier.nomad
nomad job dispatch -meta SEQUENCE="Nomad, a workload orchestrator by HashiCorp, supports batch job scheduling with GPU support through its Docker driver" -meta LABELS="politics,technology,humor" classifier
nomad job dispatch -meta SEQUENCE="The Emirates will become the first country to deploy ChatGPT nationwide, OpenAI said. Every citizen and resident will soon have free access to ChatGPT Plus" -meta LABELS="politics,technology,humor" classifier
nomad job dispatch -meta SEQUENCE="Did you hear about the two people who stole a calendar? They each got six months." -meta LABELS="politics,technology,humor" classifier

nomad alloc logs -stderr <alloc_id>

docker ps | grep redis
docker exec -ti <redis_container_id> bash

redis-cli
keys *
```
