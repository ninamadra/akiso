%include        'functions.asm'
	

SECTION .text
	global  _start
 
_start:
	mov	eax, 2
	call	iprint
	call	space
	inc	eax
	
loop:
	call	printPrime
	inc	eax
	inc	eax
	cmp	eax, 100000
	jbe	loop
   	
   	call	linefeed
   	call    quit
