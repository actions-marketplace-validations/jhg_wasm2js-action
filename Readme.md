# wasm2js GitHub action

This docker action allows usage of [binaryen's](https://github.com/WebAssembly/binaryen) wasm2js to generate JS from Wasm files inside your GitHub workflows. Binaryen is available under its [Apache 2.0 License](https://github.com/WebAssembly/binaryen/blob/main/LICENSE). This action is forked from [NiklasEi/wasm-opt](https://github.com/NiklasEi/wasm-opt).

## Usage

In one of your GitHub workflow steps:
```yaml
      - name: Generate JS from Wasm
        uses: jhg/wasm2js-action@v1
        with:
          file: some/path/to/file.wasm
          output: some/path/to/file.js
```

The input parameters `file` and `output` are required. There is another optional parameter `options` with a default value of `-Os`. The input parameters are passed to `wasm2js` like so: `<input> -o <output> <options>`.

Check the [wasm2js options](https://github.com/WebAssembly/binaryen/blob/main/src/tools/optimization-options.h) for more info.
