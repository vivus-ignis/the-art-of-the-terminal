```bash
sudo apt install podman/testing crun/testing libwasmedge0
crun -v
podman run --platform wasi/wasm quay.io/podman-desktop-demo/wasm-rust-hello-world
```
