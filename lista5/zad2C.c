#include <stdio.h>
#include <signal.h>


void sig_handler (int signum) {
    
    printf("handling...\n");
    signal(SIGUSR1,sig_handler);

}

int main() {
    
    signal(SIGUSR1,sig_handler);
    int i;
    i = fork();
    if (i == 0) {
        signal(SIGUSR1,sig_handler);
        sleep(1);
    }

    else {
        
        printf("signal 0\n");
        kill (i,SIGUSR1);
        printf("signal 1\n");
        kill (i,SIGUSR1);
        printf("signal 2\n");
        kill (i,SIGUSR1);
        printf("signal 3\n");
        kill (i,SIGUSR1);
    }
}
