.PHONY: all build clean run test

all: test

build: fib.s Makefile
	as fib.s -o fib.o
	ld fib.o -o fib.out \
		-lSystem -syslibroot \
		"$$(xcrun -sdk macosx --show-sdk-path)" \
		-e _main -arch x86_64

clean:
	rm -f fib.o fib.out

run: build
	echo 10 | ./fib.out

test: build
	echo 0 | ./fib.out | grep -xq 0
	echo 1 | ./fib.out | grep -xq 1
	echo 10 | ./fib.out | grep -xq 55
