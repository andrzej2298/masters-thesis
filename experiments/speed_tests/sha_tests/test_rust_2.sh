for i in $(seq 1000 500 10000); do echo "$i"; time ./test_rust "$i" > /dev/null; done
