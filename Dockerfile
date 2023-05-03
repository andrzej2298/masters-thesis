FROM ubuntu:jammy

RUN apt update && apt install -y \
    sudo \
    curl \
    cmake \
    make \
    git \
    golang-go \
    python3 \
    # emscripten \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash jsonnet_ffi -p "" && adduser jsonnet_ffi sudo

USER jsonnet_ffi
WORKDIR /home/jsonnet_ffi

ENV PATH="/home/jsonnet_ffi/.cargo/bin:${PATH}"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

COPY --chown=jsonnet_ffi go-jsonnet go-jsonnet
COPY --chown=jsonnet_ffi ffi_wasmtime.patch /home/jsonnet_ffi/go-jsonnet/
RUN cd ~/go-jsonnet && git apply ffi_wasmtime.patch && go build ./cmd/jsonnet

COPY --chown=jsonnet_ffi go-jsonnet go-jsonnet-wasmer
COPY --chown=jsonnet_ffi ffi_wasmer.patch /home/jsonnet_ffi/go-jsonnet-wasmer/
RUN cd ~/go-jsonnet-wasmer && git apply ffi_wasmer.patch && go build -v ./cmd/jsonnet

COPY --chown=jsonnet_ffi wasm-c-lib wasm-c-lib
COPY --chown=jsonnet_ffi wasm-rust-lib wasm-rust-lib

RUN git clone https://github.com/emscripten-core/emsdk.git && \
    cd emsdk && \
    ./emsdk install latest && \
    ./emsdk activate latest && \
    . ./emsdk_env.sh

RUN rustup target add wasm32-wasi

RUN cd ~/wasm-rust-lib && cargo build

RUN cp ~/wasm-rust-lib/target/wasm32-wasi/debug/wasm_lib.wasm ~/go-jsonnet/ffi_examples/rust-library.wasm
RUN cp ~/wasm-rust-lib/target/wasm32-wasi/debug/wasm_lib.wasm ~/go-jsonnet-wasmer/ffi_examples/rust-library.wasm

RUN cd ~/wasm-c-lib && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cd ~/emsdk/ && \
    . ./emsdk_env.sh && \
    cd ~/wasm-c-lib/build && \
    emcmake cmake .. && \
    emmake make

RUN cp ~/wasm-c-lib/build/exported-functions.wasm ~/go-jsonnet/ffi_examples/c-library.wasm
RUN cp ~/wasm-c-lib/build/exported-functions.wasm ~/go-jsonnet-wasmer/ffi_examples/c-library.wasm
