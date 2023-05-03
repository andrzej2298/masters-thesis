for i in $(seq 1000 500 10000); do echo "$i"; time ./jsonnet --ext-str loopCount="$i" sha_ffi.jsonnet > /dev/null; done
