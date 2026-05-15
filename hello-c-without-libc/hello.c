long my_syscall(long syscall_no, long a, long b, long c);

void start() {
	const char *message = "Hello, World!\n";
	my_syscall(0x2000004, 1, (long)message, 14);
	my_syscall(0x2000001, 0, 0, 0);
}
