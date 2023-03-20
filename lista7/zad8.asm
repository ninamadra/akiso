%include    'mathfunctions.asm'

section .text
  global _start

_start:

    finit

    call    ln
    call    exp
    call    sinh
    call    arsinh

    mov     ebx, 0
    mov     eax, 1
    int     0x80
