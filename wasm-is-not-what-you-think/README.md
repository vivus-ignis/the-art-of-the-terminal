# Wasm is NOT what you think

Links for the [Webassembly Is NOT What You Think episode](https://youtu.be/Wxw-YAGYHDc)

## Links and sources

### asm.js

- http://asmjs.org/
- [emscripten](https://emscripten.org/)
- [asm.js DOS games](https://dos.zone/)

### In-browser webassembly

- [Run code in different languages in your browser](https://runno.dev/)
- [LLMs](https://github.com/hrishioa/wasm-ai)
- [PostgreSQL](https://pglite.dev/)
- [OS emulators](http://copy.sh/v86/)
- [Heroes2](https://midzer.de/wasm/heroes2/)

### Runtimes

- [Webassembly specifications](https://webassembly.org/specs/)
- [wasmtime](https://wasmtime.dev/)
- [A couple more runtimes than I reviewed in my video](https://github.com/appcypher/awesome-wasm-runtimes)

### Proxy WASM ABI

- nginx/openresty WASM modules:
	- https://github.com/Kong/ngx_wasm_module
	- https://github.com/api7/wasm-nginx-module
- [Wasm Proxy ABI](https://github.com/proxy-wasm/spec)
- [Proxy SDK for C++](https://github.com/proxy-wasm/proxy-wasm-cpp-sdk)
- [Proxy SDK for Rust](https://github.com/proxy-wasm/proxy-wasm-rust-sdk)
- C++ modules I've tried that do not work for me
	- https://github.com/GoogleCloudPlatform/service-extensions
	- example from https://github.com/proxy-wasm/proxy-wasm-cpp-sdk.git
- [rust module that worked](https://github.com/wasmx-proxy/proxy-wasm-rust-filter-echo)
- [proxy-wasm issues with go](https://github.com/tetratelabs/proxy-wasm-go-sdk/issues/450#issuecomment-2253729297)
- [big thread on the state of proxy wasm](https://github.com/envoyproxy/envoy/issues/35420)

### IoT

- [wasm micro runtime](https://github.com/bytecodealliance/wasm-micro-runtime)
- [wasm3](https://github.com/wasm3/wasm3)

### Languages designed for wasm

- https://wa-lang.github.io/
- https://github.com/glebbash/LO
- https://onyxlang.io/
- https://www.assemblyscript.org/
- https://grain-lang.org/

### Wasm for plugins

- [extism](https://extism.org)
- [extism C PDK](https://github.com/extism/c-pdk)
- Extending JVM languages with wasm
	- https://www.graalvm.org/webassembly/
	- https://github.com/dylibso/chicory
- [Kubernetes policies in WASM](https://www.kubewarden.io/)
- [Paper on using wasm for ebpf](https://arxiv.org/abs/2408.04856)
- [Controllers for LLMs](https://github.com/microsoft/aici)
- [PostgreSQL FDWs](https://supabase.com/blog/postgres-foreign-data-wrappers-with-wasm)

### WASI

- [WASI specs](https://github.com/WebAssembly/WASI)
- [Solomon Hykes' tweet](https://x.com/solomonstre/status/1111004913222324225)
- [WASI SDK for C/C++](https://github.com/WebAssembly/wasi-sdk)
- https://wasix.org/
- [Alternative guest-to-host interface, WALI](https://arxiv.org/pdf/2312.03858) (WebAssembly Linux Interface)

### WAT format

- [Undestanding the text format](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format)
- [Webassembly binary toolsm can be used to disassemble to WAT](https://github.com/WebAssembly/wabt)

### Component model

- https://component-model.bytecodealliance.org/
- [WARG registry format](https://warg.io/)

### Spin

- [Documentation](https://developer.fermyon.com/spin/v2/)
- [On kubernetes](https://www.spinkube.dev/)

### Wasmcloud

- https://wasmcloud.com
- [Open Application Model](https://oam.dev/)
