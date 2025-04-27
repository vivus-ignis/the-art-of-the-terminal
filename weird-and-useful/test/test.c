#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>

int main() {
    char *args[] = {"/usr/bin/[", "-f", "/etc/debian_version", "]", NULL};
    pid_t pid = fork();
    if (pid == 0) {
        execve("/usr/bin/[", args, NULL);
    } else {
        int status;
        wait(&status);
        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
            printf("Debian\n");
        } else {
            printf("NOT debian\n");
        }
    }
    return 0;
}
