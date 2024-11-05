import extism

manifest = { "wasm": [ {"path": "./fortunes.wasm"} ] }

with extism.Plugin(manifest, wasi=False) as plugin:
    print(plugin.call("get_random_phrase", ""))
