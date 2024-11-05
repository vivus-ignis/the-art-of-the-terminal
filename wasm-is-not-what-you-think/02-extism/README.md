```bash
python3 -mvenv .venv
. .venv/bin/activate
pip install extism

wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-24/wasi-sdk-24.0-x86_64-linux.deb
sudo dpkg -i wasi-sdk-24.0-x86_64-linux.deb
wget https://raw.githubusercontent.com/extism/c-pdk/refs/heads/main/extism-pdk.h
export CC="/opt/wasi-sdk/bin/clang --sysroot=/opt/wasi-sdk/share/wasi-sysroot"
$CC -o fortunes.wasm fortunes.c -mexec-model=reactor
# reactor is needed, because we don't have main function as an entrypoint here

python ./wasm_host.py
```

## Disassembling to WAT format

```bash
wget https://github.com/WebAssembly/wabt/releases/download/1.0.36/wabt-1.0.36-ubuntu-20.04.tar.gz
tar xzf wabt-1.0.36-ubuntu-20.04.tar.gz
ls -l wabt-1.0.36
./wabt-1.0.36/bin/wasm2wat fortunes.wasm > fortunes.wat
```
