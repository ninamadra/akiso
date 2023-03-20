#include <stdio.h>

int main(int argc, char *argv[], char **envp) {

    setuid(0);
    char *newargv[2];
    int i;

    newargv[0] = "bash";
    newargv[1] = NULL;
    i = execve("/bin/bash", newargv, envp);
    perror("exec: error");
    exit(1);
}
