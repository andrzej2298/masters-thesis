for i in $(seq 1 30); do echo "$i"; time ./test_rust "$i" > /dev/null; done
