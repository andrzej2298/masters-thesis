# How to build docker image

```sh
docker build . -t jsonnet_ffi
```

# How to run docker image

```sh
docker run -it jsonnet_ffi bash
```

# Sample usage of the FFI

```
jsonnet_ffi@5627d0ee61d9:~/go-jsonnet$ ./jsonnet ffi_examples/rust_ffi_example.jsonnet 
{
   "markdown": "<p>Text <strong>text</strong> <em>text</em> text.</p>\n",
   "sha": "b7e23ec29af22b0b4e41da31e868d57226121c84"
}
jsonnet_ffi@5627d0ee61d9:~/go-jsonnet$ ./jsonnet ffi_examples/c_ffi_example.jsonnet    
{
   "markdown": "<p>Text <strong>text</strong> <em>text</em> text.</p>\n",
   "sha": "b7e23ec29af22b0b4e41da31e868d57226121c84"
}
```

# Archive content description

* `go-jsonnet` - folder with an unmodified version of the `go-jsonnet` interpreter
* `ffi_wasmtime.patch` - patch with the ffi changes to apply to the `go-jsonnet` interpreter
* `ffi_wasmer.patch` - patch with the ffi changes for the implementation with the alternative runtime (`Wasmer`),
   described in section 3.5
* `wasm-c-lib` - folder with the `C` glue code and an example library
* `wasm-rust-lib` - folder with the `Rust` glue code and an example library
* `experiments` - folder with files used for tests/experiments
   * `experiments/memory_tests/valgrind_test/` - tests from section 2.5
   * `experiments/speed_tests/sha_tests/` - tests from section 3.1
   * `experiments/speed_tests/import_tests/` - tests from section 3.2
   * `experiments/speed_tests/execution_tests/` - tests from section 3.3.1
   * `experiments/speed_tests/serialisation_tests/` - tests from section 3.3.2
   * `experiments/memory_test/allocation_test/` - tests from section 3.4
   * `experiments/wasmer_wasmtime_tests/` - tests from section 3.5
