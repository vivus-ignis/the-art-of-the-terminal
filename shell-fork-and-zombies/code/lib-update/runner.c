extern char *get_version();
#include <stdio.h>
#include <unistd.h>

int main() {
    while(1) {
            printf("Running with library version: %s\n", get_version());
            sleep(2);
        }
    return 0;
}
