cmake_minimum_required(VERSION 3.18)
project(JsonnetWASMMemoryTest)

set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

find_package(bson-1.0 1.7 REQUIRED)

add_executable(c-memory-test ../main.c)
# add_library(wasm_c_lib STATIC IMPORTED)
# set_target_properties(wasm_c_lib PROPERTIES IMPORTED_LOCATION /home/andrzej/wasm-c-lib/build/libexported-functions.a)
# add_library(jsonnetffi STATIC IMPORTED)
# set_target_properties(jsonnetffi PROPERTIES IMPORTED_LOCATION /home/andrzej/wasm-c-lib/build/jsonnetffi/libjsonnetffi.a)
add_library(md4c SHARED IMPORTED)
set_target_properties(md4c PROPERTIES IMPORTED_LOCATION /home/andrzej/wasm-c-lib/build/md4c/src/libmd4c-html.so)
target_link_libraries(c-memory-test PRIVATE mongo::bson_shared md4c /home/andrzej/wasm-c-lib/build/libexported-functions.a /home/andrzej/wasm-c-lib/build/jsonnetffi/libjsonnetffi.a)

add_executable(rust-memory-test ../main.c)
add_library(wasm_rust_lib SHARED IMPORTED)
set_target_properties(wasm_rust_lib PROPERTIES IMPORTED_LOCATION /home/andrzej/wasm-rust-lib/target/aarch64-unknown-linux-gnu/debug/libwasm_lib.so)
target_link_libraries(rust-memory-test PRIVATE mongo::bson_shared wasm_rust_lib)
