section .data
  int: db "%d", 10, 0
  scan: db "%d", 0
  print: db "%08x%08x%08x%08x", 10, 0
  num: dd 0
  n1: dd 1
  
section .bss
  result resb 16
  
section .text
  global main
  extern scanf
  extern printf

main:
  push num
  push scan
  call scanf
  mov ecx, dword [num]
  movd xmm1,dword [n1]
 
  multiplyloop:
    ;do
    movd xmm2,ecx
    pmuludq xmm1,xmm2
    dec ecx
    cmp ecx,1
    je end
    jmp multiplyloop
  
end:
  movdqu oword[result],xmm1
  push dword [result]
  push dword [result+4]
  push dword [result+8]
  push dword [result+12]
  push print
  call printf
  mov eax, 1
  int 0x80
