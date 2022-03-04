FROM rust:1.57 as build

RUN USER=root cargo new --bin wasm2js-action
WORKDIR /wasm2js-action

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

RUN cargo build --release
RUN rm src/*.rs

COPY ./src ./src

RUN rm -r ./target/release/deps/
RUN cargo build --release

FROM debian:buster-slim

RUN apt-get update
RUN apt-get install -y wget

RUN mkdir binaryen
RUN wget -qO- https://github.com/WebAssembly/binaryen/releases/download/version_104/binaryen-version_104-x86_64-linux.tar.gz | tar xvz -C ./binaryen binaryen-version_104 --strip=1
ENV PATH $PATH:/binaryen/bin

COPY --from=build /wasm2js-action/target/release/wasm2js-action .
ENV PATH $PATH:/
RUN chmod +x /wasm2js-action

ENTRYPOINT ["wasm2js-action"]
