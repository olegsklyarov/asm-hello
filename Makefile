hello: hello.s
	as hello.s -o hello.o
	ld hello.o -o hello -lSystem -syslibroot "$$(xcrun -sdk macosx --show-sdk-path)" -e _main -arch x86_64

build: hello

clean:
	rm -f hello.o hello

watch:
	fswatch -o hello.s | xargs -n1 -I {} $(MAKE) build

objdump: hello
	objdump -d hello

otool: hello
	otool -tV hello

hexdump: hello
	hexdump -C hello
