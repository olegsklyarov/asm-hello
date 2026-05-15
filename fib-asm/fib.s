.section __TEXT, __text

.set SYSCALL_read, 0x2000003
.set SYSCALL_write, 0x2000004
.set SYSCALL_exit, 0x2000001
.set STDIN_FILENO, 0
.set STDOUT_FILENO, 1
.set EXIT_SUCCESS, 0
.set INPUT_SIZE, 64
.set OUTPUT_SIZE, 32

.global _main

_main:
	call read_input
	call parse_input
	call fib
	call print_uint64

	movq $SYSCALL_exit, %rax
	movq $EXIT_SUCCESS, %rdi
	syscall

# read(2): stdin -> input_buf
read_input:
	movq $SYSCALL_read, %rax
	movq $STDIN_FILENO, %rdi
	leaq input_buf(%rip), %rsi
	movq $INPUT_SIZE, %rdx
	syscall
	ret

# Парсит десятичное целое из input_buf (без проверок).
# Возвращает N в %rax.
parse_input:
	xorq %rax, %rax
	leaq input_buf(%rip), %rsi
parse_loop:
	movzbq (%rsi), %rcx
	cmpq $48, %rcx
	jb parse_done
	cmpq $57, %rcx
	ja parse_done
	imulq $10, %rax
	subq $48, %rcx
	addq %rcx, %rax
	incq %rsi
	jmp parse_loop
parse_done:
	ret

# Итеративный Fib(N): только два предыдущих значения в %r13 и %r14.
# F(0)=0, F(1)=1, ...; результат в %rax.
fib:
	movq %rax, %r12
	xorq %r13, %r13
	movq $1, %r14
fib_loop:
	testq %r12, %r12
	jz fib_done
	movq %r13, %r15
	addq %r14, %r15
	movq %r14, %r13
	movq %r15, %r14
	decq %r12
	jmp fib_loop
fib_done:
	movq %r13, %rax
	ret

# Печатает беззнаковое число из %rax и перевод строки в stdout.
print_uint64:
	leaq output_buf(%rip), %r8
	addq $(OUTPUT_SIZE - 1), %r8
	movb $10, (%r8)
	movq $1, %r11
	movq $10, %r10
print_loop:
	xorq %rdx, %rdx
	divq %r10
	addb $48, %dl
	decq %r8
	movb %dl, (%r8)
	incq %r11
	testq %rax, %rax
	jnz print_loop

	movq $SYSCALL_write, %rax
	movq $STDOUT_FILENO, %rdi
	movq %r8, %rsi
	movq %r11, %rdx
	syscall
	ret

.section __DATA,__bss
.align 4
input_buf:
	.space INPUT_SIZE
output_buf:
	.space OUTPUT_SIZE
