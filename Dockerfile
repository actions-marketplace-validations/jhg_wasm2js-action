FROM rust:1.57 as build

RUN USER=root cargo new --bin wasm-opt-action
WORKDIR /wasm-opt-action

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

RUN cargo build --release
RUN rm src/*.rs

COPY ./src ./src

RUN rm -r ./target/release/deps/
RUN cargo build --release

FROM debian:buster-slim

RUN mkdir binaryen
RUN apt-get update
RUN apt-get install -y wget
RUN wget -qO- https://github.com/WebAssembly/binaryen/releases/download/version_104/binaryen-version_104-x86_64-linux.tar.gz | tar xvz -C ./binaryen binaryen-version_104 --strip=1
ENV PATH $PATH:/binaryen/bin
COPY --from=build /wasm-opt-action/target/release/wasm-opt-action .

ENTRYPOINT ["./wasm-opt-action"]