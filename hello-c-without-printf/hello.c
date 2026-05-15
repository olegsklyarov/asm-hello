#include <sys/syscall.h>
#include <unistd.h>

int main() {
    const char *message = "Hello, World!\n";
    syscall(SYS_write, STDOUT_FILENO, message, 15);
    return 0;
}
