.section __TEXT, __text

.set SYSCALL_write, 0x2000004
.set SYSCALL_exit, 0x2000001
.set STDOUT_FILENO, 1
.set EXIT_SUCCESS, 0

.global _main

_main:
	# macOS x86_64 syscall ABI:
	# rax = SYSCALL number
	#
	# rdi = arg1
	# rsi = arg2
	# rdx = arg3
	# r10 = arg4
	# r8  = arg5
	# r9  = arg6


	# WRITE syscall
	# Use man for more information:
	# $ (terminal) $ man 2 write
	movq $SYSCALL_write, %rax
	movq $STDOUT_FILENO, %rdi
	leaq message(%rip), %rsi
	movq $(message_end - message), %rdx
	syscall


	# EXIT syscall
	# Use man for more information:
	# (terminal) $ man 2 _exit
	movq $SYSCALL_exit, %rax
	movq $EXIT_SUCCESS, %rdi
	syscall

.section __TEXT,__const
message:
	.ascii "Hello, World!\n"
message_end:
