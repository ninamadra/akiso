#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


void dec2binFrac(double dec, int precision) {
    
    while (dec > 0) {
        dec --;
    }
    dec++;
    printf("%d",dec);
    for (int i =0;i < precision; i++) {
    	dec *=2;
    	
    
   
}
char* dec2binInt(int dec) {
    char* integralPart;
    int i = 0;
    while(dec > 0) {
        integralPart[i] = dec%2+'0';
        i++;
        dec /= 2;
    }
    integralPart[i] = '\0';
    return integralPart;
}

void dec2bin (double dec, int precision) { 
    printf("%d",dec);

    //TODO to be reversed
    //printf("%s.",dec2binInt((int)dec));
    dec2binFrac(dec, precision);
    
}

int main(int argc, char** argv) {

    double dec = atof(argv[1]);
    int precision = atoi(argv[2]);
    dec2bin(dec, precision);
}
