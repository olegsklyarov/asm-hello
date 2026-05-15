.section __TEXT, __text
.global _main

_main:
	/*
	Для macOS x86_64 syscall ABI:
	rax = syscall number

	rdi = arg1
	rsi = arg2
	rdx = arg3
	r10 = arg4
	r8  = arg5
	r9  = arg6
	*/

	/* 
		WRITE syscall
		4 AUE_NULL ALL { user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte); }
	*/
	# 0x2000004 = WRITE syscall
	movq $0x2000004, %rax
	# int fd ($1 = stdout)
	movq $1, %rdi
	# user_addr_t cbuf (адрес строки "message")
	leaq message(%rip), %rsi
	# user_size_t nbyte ($14 = длина строки message)
	movq $14, %rdx
	# syscall -> kernel mode
	syscall

	/*
		EXIT syscall
		1 AUE_EXIT ALL { void exit(int rval) NO_SYSCALL_STUB; }
	*/
	# $0x2000001 = EXIT syscall
	movq $0x2000001, %rax
	# int rval ($0 = success exit status)
	movq $2, %rdi
	# syscall -> kernel mode
	syscall

.section __TEXT,__cstring
message:
	.asciz "Hello, World!\n"
