#include <stdio.h>
#include <signal.h>

//nie mozna zlapac SIGKILL (9) ani SIGSTOP (19)
void sig_handler (int signum) {

    printf("signal %d: ", signum );
    signal(signum, sig_handler);
}

int main(int argc, char *argv[]) {

    for ( int i = 1; i <= SIGRTMAX; i++) { 
        signal(i, sig_handler);
    }

    int i = 1;
    while (i <= SIGRTMAX) {

        if ( i != 9 && i != 19 && i != 32 && i != 33) { //32,33 not defined
            kill(getpid(),i);
            printf("alive\n");
        }
        i++;
    }
    kill(getpid(),9);
    return 0;
}
