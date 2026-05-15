.PHONY: all build clean run test watch objdump otool hexdump

all: build test

build: hello.s Makefile
	as hello.s -o hello.o
	ld hello.o -o hello.out \
		-lSystem -syslibroot \
		"$$(xcrun -sdk macosx --show-sdk-path)" \
		-e _main -arch x86_64

clean:
	rm -f hello.o hello.out

run: build
	./hello.out

test: build
	./hello.out | grep -xq "Hello, World!"
	@test $$? -eq 0

watch:
	fswatch -o hello.s | xargs -n1 -I {} $(MAKE) build

objdump: build
	objdump -d hello

otool: build
	otool -tV hello

hexdump: build
	hexdump -C hello
