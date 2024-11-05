```bash
wget https://packagecloud.io/install/repositories/wasmcloud/core/script.deb.sh
nvim script.deb.sh
sudo bash ./script.deb.sh
sudo apt install wash
wash --version

rustup update
rustup target add wasm32-wasip2

wget https://github.com/bytecodealliance/wasmtime/releases/download/v17.0.3/wasmtime-v17.0.3-x86_64-linux.tar.xz
tar xf wasmtime-v17.0.3-x86_64-linux.tar.xz
export PATH=$PWD/wasmtime-v17.0.3-x86_64-linux:$PATH

git clone https://github.com/wasmCloud/wasmCloud.git
cd wasmCloud/examples/rust/components/http-jsonify

wash dev

# open another tab:
curl localhost:8000
```
