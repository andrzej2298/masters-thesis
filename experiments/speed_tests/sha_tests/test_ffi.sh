for i in $(seq 1 30); do echo "$i"; time ./jsonnet --ext-str loopCount="$i" sha_ffi.jsonnet > /dev/null; done
