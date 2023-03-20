%include        'functions.asm'

SECTION .data
	msg1	db	'Enter DEC number: ', 0h
	
SECTION .bss
	userinput:	resb	10
	
SECTION .text
	global  _start
 
_start:
	mov	eax, msg1
    	call	sprint
    	
    	mov	edx, 10
    	mov	ecx, userinput
    	mov	ebx, 0
    	mov	eax, 3	;read
    	int	80h    	
    	
    	mov	eax, userinput
    	call	atoi
    	call	itoh
    	int	80h
 
   	call    quit
