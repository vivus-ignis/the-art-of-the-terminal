## Nginx

```bash
wget https://nginx.org/download/nginx-1.26.2.tar.gz
tar xzf nginx-1.26.2.tar.gz
wget https://github.com/Kong/ngx_wasm_module/releases/download/prerelease-0.4.0/ngx_wasmx_module-prerelease-0.4.0.tar.gz
tar xf ngx_wasmx_module-prerelease-0.4.0.tar.gz
wget https://github.com/bytecodealliance/wasmtime/releases/download/v19.0.2/wasmtime-v19.0.2-x86_64-linux-c-api.tar.xz  # versions > 19 are not supported by ngx_wasmx
tar xf wasmtime-v19.0.2-x86_64-linux-c-api.tar.xz
ls -l
cd nginx-1.26.2/
./configure --prefix=$HOME/nginx --add-module=../ngx_wasmx_module-prerelease-0.4.0 --with-cc-opt='-I../wasmtime-v19.0.2-x86_64-linux-c-api/include' --with-ld-opt='../wasmtime-v19.0.2-x86_64-linux-c-api/lib/libwasmtime.a'  # compile with wasmtime statically
make
make install

git clone https://github.com/proxy-wasm/proxy-wasm-cpp-sdk.git
cd proxy-wasm-cpp-sdk
docker build -t wasmsdk:v2 -f Dockerfile-sdk . # emscripten + proxy-sdk
cd example
cat <<'EOF' > Makefile
.PHONY = all clean

PROXY_WASM_CPP_SDK=/sdk

all: http_wasm_example.wasm

include ${PROXY_WASM_CPP_SDK}/Makefile
EOF
docker run -v $PWD:/work -w /work  wasmsdk:v2 /build_wasm.sh
file http_wasm_example.wasm
cd ../..

~/nginx/sbin/nginx -c $PWD/nginx.conf -g 'daemon off;'

# open another tab:
curl localhost:8000/wasm
```

### One more example (didn't work for me as well as the example above)

```bash
git clone https://github.com/GoogleCloudPlatform/service-extensions.git
cd service-extensions/plugins/samples/redirect
```

Create a Makefile:

```makefile
PROXY_WASM_CPP_SDK=/sdk

PROTOBUF=lite
WASM_DEPS=re2 absl_strings

all: plugin.wasm

%.wasm %.wat: %.cc ${CPP_API}/proxy_wasm_intrinsics.h ${CPP_API}/proxy_wasm_enums.h ${CPP_API}/proxy_wasm_externs.h ${CPP_API}/proxy_wasm_api.h ${CPP_API}/proxy_wasm_intrinsics.js ${CPP_CONTEXT_LIB}
	em++ --no-entry -s EXPORTED_FUNCTIONS=['_malloc'] --std=c++17 -O3 -flto -I${CPP_API} -I${CPP_API}/google/protobuf -I/usr/local/include -I${ABSL} --js-library ${CPP_API}/proxy_wasm_intrinsics.js ${ABSL_CPP} $*.cc ${CPP_API}/proxy_wasm_intrinsics.pb.cc ${CPP_CONTEXT_LIB} ${CPP_API}/libprotobuf.a -o $*.wasm

include ${PROXY_WASM_CPP_SDK}/Makefile
```

```bash
docker run -v $PWD:/work -w /work  wasmsdk:v2 /build_wasm.sh
```

### This example worked

```bash
git clone https://github.com/wasmx-proxy/proxy-wasm-rust-filter-echo.git
cd proxy-wasm-rust-filter-echo
make
```

To test:

```bash
curl -v localhost:8000/headers
curl -v localhost:8000/ip
```

## Openresty & wasm-nginx-module

```bash
git clone https://github.com/api7/wasm-nginx-module.git
cd wasm-nginx-module
nvim install-wasmtime.sh # set VER to 25.0.2
./install-wasmtime.sh
export wasmtime_prefix=$PWD/wasmtime-c-api
cd ..

export PATH=/sbin:/usr/sbin:$PATH  # for ldconfig
sudo apt-get install libpcre3-dev libssl-dev

wget https://openresty.org/download/openresty-1.25.3.2.tar.gz
tar xzf openresty-1.25.3.2.tar.gz
cd openresty-1.25.3.2/
./configure --prefix=$HOME/openresty --add-module=../wasm-nginx-module --with-ld-opt="-Wl,-rpath,${wasmtime_prefix}/lib"
make
make install
~/openresty/bin/resty -V 2>&1| grep --color wasm

cd ../wasm-nginx-module
OPENRESTY_PREFIX=$HOME/openresty make install

cd ..
git clone https://github.com/proxy-wasm/proxy-wasm-cpp-sdk.git
cd proxy-wasm-cpp-sdk/example

docker build -t wasmsdk:v2 -f Dockerfile-sdk .

~/openresty/bin/opm get ledgetech/lua-resty-http # wasm-proxy lua module tries to require resty.http

cd example
cat <<EOF > Makefile
PROXY_WASM_CPP_SDK=/sdk

all: http_wasm_example.wasm

include ${PROXY_WASM_CPP_SDK}/Makefile.base_lite
EOF
docker run -v $PWD:/work -w /work  wasmsdk:v2 /build_wasm.sh
cp http_wasm_example.wasm ../../

cd ../..
make

# open another tab:
curl -v localhost:8000/wasm
```
