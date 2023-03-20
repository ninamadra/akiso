section .text
global _start
_start:
	finit
	fld	dword [x]
	fld	st0
	fmul
	fld	dword [y]
	fld	st0
	fmul
	fadd
	fsqrt
	fst	dword [z]
	
	mov	ebx, 0
	mov	eax, 1
	int 	0x80
	

section .data
x:	dd 1.2
y:	dd 3.14
z:	dd 0

