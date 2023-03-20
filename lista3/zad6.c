#include <stdio.h>

int main() {
        for (int i = 0; i < 256; i++) {

                printf("\033[38;5;%dmHelloWorld\n", i);
        }

        return 0;
}
