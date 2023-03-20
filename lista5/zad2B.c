#include <stdio.h>
#include <signal.h>

int main(int argc, char *argv[], char **envp) {

    setuid(0);
    char *newargv[4];
    int i;

    newargv[0] = "kill";
    newargv[1] = "-9";
    newargv[2] = "1";
    newargv[3] = NULL;
    i = execve("/bin/kill", newargv, envp);
    perror("exec: error");
    exit(1);
}