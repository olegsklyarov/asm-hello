.PHONY: all build clean run test

all: build test

build: hello.c my_syscall.s Makefile
	as my_syscall.s -o my_syscall.o
	clang -c hello.c -o hello.o
	ld my_syscall.o hello.o -o hello.out \
		-lSystem -syslibroot \
		"$$(xcrun -sdk macosx --show-sdk-path)" \
		-e _start -arch x86_64

clean:
	rm -f hello.out hello.o my_syscall.o

run: build
	./hello.out

test: build
	./hello.out | grep -nq "Hello, World!"
	@test $$? -eq 0
