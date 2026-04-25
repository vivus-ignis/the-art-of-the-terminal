#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];

    int fd = open(filename, O_RDWR | O_CREAT, 0644);
    if (fd == -1) {
        perror("open");
        return EXIT_FAILURE;
    }

    struct stat st;
    if (stat(filename, &st) == -1) {
        perror("stat");
    }

    printf("Keeper with PID %d started: FD %d points to %s (inode %ju)\n",
           getpid(),
           fd,
           filename,
           (uintmax_t)st.st_ino);
    fflush(stdout);

    sleep(600);

    return EXIT_SUCCESS;
}
