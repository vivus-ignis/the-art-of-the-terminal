# Wasm is NOT what you think

## Links and sources

- nginx/openresty WASM modules:
	- https://github.com/Kong/ngx_wasm_module
	- https://github.com/api7/wasm-nginx-module
	- Wasm Proxy ABI https://github.com/proxy-wasm/spec
	- Proxy SDK for C++ https://github.com/proxy-wasm/proxy-wasm-cpp-sdk
	- Proxy SDK for Rust https://github.com/proxy-wasm/proxy-wasm-rust-sdk
	- C++ modules I've tried that do not work for me
		- https://github.com/GoogleCloudPlatform/service-extensions
		- example from https://github.com/proxy-wasm/proxy-wasm-cpp-sdk.git
	- rust module that worked https://github.com/wasmx-proxy/proxy-wasm-rust-filter-echo
	- proxy-wasm issues with go https://github.com/tetratelabs/proxy-wasm-go-sdk/issues/450#issuecomment-2253729297
	- https://github.com/tetratelabs/proxy-wasm-go-sdk?tab=readme-ov-file
- big thread on the state of proxy wasm https://github.com/envoyproxy/envoy/issues/35420
- extism C PDK https://github.com/extism/c-pdk
- webassembly binary tools https://github.com/WebAssembly/wabt
- Solomon Hykes' tweet https://x.com/solomonstre/status/1111004913222324225
- A couple more runtimes than I reviewed in my video https://github.com/appcypher/awesome-wasm-runtimes
- Where wasmer is used https://mnt.io/articles/i-leave-wasmer/
- Extending JVM languages with wasm
	- https://www.graalvm.org/webassembly/
	- https://github.com/dylibso/chicory
- wasi-sdk https://github.com/WebAssembly/wasi-sdk
- alternative guest-to-host interface, WALI https://arxiv.org/pdf/2312.03858 (WebAssembly Linux Interface)
