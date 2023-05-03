for i in $(seq 1 30); do echo "$i"; time ./jsonnet -s 1000 --ext-str loopCount="$i" sha.jsonnet > /dev/null; done
