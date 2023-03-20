#include <stdio.h>
#include <string.h>

#define BUFF_LEN 1024

int main() {

    char commandLine[BUFF_LEN];
    char* argv[128];
    int argc;
    char* path = "/bin/";
    char fullPath[64];

    while(1) {

        printf("lsh$ ");

        if(!fgets(commandLine, BUFF_LEN, stdin)) { 
                break;                               
        }
        int len = strlen(commandLine);
        if ( commandLine[len -1] == '\n') {
            commandLine[len -1] = '\0';
        }
        if(strcmp(commandLine, "exit") == 0) {       
            break;
        }
            
        char *token;
        token = strtok(commandLine," ");
        int argc = 0;
        while (token != NULL) {
            argv[argc] = token;
            token = strtok(NULL, " ");
            argc++;
        }

        if (strcmp(argv[0],"cd") == 0) {
            if(argv[1]) {
                if (chdir(argv[1]) != 0) {
                    perror("cd failed");
                }
            }
        
            else {
                if (chdir("/home/nina")!= 0){
                 perror("cd failed");
                }
            }
        }
        
        else {

            argv[argc] = NULL;
            int bg = (*argv[argc-1] == '&');

            strcpy(fullPath, path);
            strcat(fullPath, argv[0]);

            if (!bg) {

                int i;
                i = fork();
                if (i == 0) { 
                    execvp(fullPath,argv);
                    perror("execvp error"); 
            
                } 
                else { 
                    wait();
                } 
            }

            else {
                argv[argc-1] = NULL;
                int i;
                i = fork();
                if (i == 0) { 
                    int j = fork();
                    if (j == 0) {
                        execvp(fullPath,argv);
                        perror("execvp error"); 
                    }
                    else {
                        exit(0);
                    }

                    execvp(fullPath,argv);
                    perror("execvp error"); 
                } 
            }
        }

    }
    return 0;
}   
