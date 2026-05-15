.PHONY: all build clean run test

all: build test

build: hello.c Makefile
	clang hello.c -o hello.out

clean:
	rm -f hello.out

run: build.out
	./hello

test: build
	./hello.out | grep -nq "Hello, World!"
	@test $$? -eq 0
