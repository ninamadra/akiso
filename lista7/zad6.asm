section .data
  scan: db "%lf %c %lf", 0
  print: db "%f", 10, 0
  a: dq 0
  b: dq 0
  op: db 0

section .text
  global main
  extern printf
  extern scanf

main:
  push a
  push op
  push b
  push scan
  call scanf
  
  finit	
  fld qword [b]
  fld qword [a]				
  
 calc:
  cmp byte [op],'+'
  je add
  cmp byte [op],'-'
  je subtract
  cmp byte [op],'/'
  je divide
  cmp byte [op],'*'
  je multiply
  
  add:
    fadd
    jmp exit
  subtract:
    fsub
    jmp exit
  divide:
    fdiv
    jmp exit
  multiply:
    fmul
    jmp exit
    
exit:
  fstp qword [b]
  push dword [b+4]
  push dword [b]
  push print
  call printf
  jmp main
