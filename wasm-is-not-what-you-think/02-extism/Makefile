CC := /opt/wasi-sdk/bin/clang --sysroot=/opt/wasi-sdk/share/wasi-sysroot

.PHONY: default
default:
	$(CC) -o fortunes.wasm fortunes.c -mexec-model=reactor

.PHONY: clean
clean:
	rm -f fortunes.wasm
