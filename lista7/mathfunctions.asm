section .data
    x:         dd    5.0       
    result:    dd    0

ln:
    fld1                       ; st(0) = 1
    fldl2e                     ; st(0) = log_2(e) | st(1) = 1
    fdiv                       ; fdiv: st(0) = st(1) / st(0) | st(0) = 1 / log_2(e)
    fld       dword[x]         ; st(0) = x | st(1) = 1 / log_2(e)
    fyl2x                      ; fyl2x: st(1) = st(1) * log_2(st(0)) | st(0) = log_2(x) * 1/log_2(e) = ln(x)

    fstp      dword[result]  
    ret

exp:
    fld       dword[x]         ; st(0) = x
    fldl2e                     ; st(0) = log_2(e) | st(1) = x 
    fmulp                      ; fmulp: st(1) = st(1) * st(0) | st(0) = x * log_2(e)
    fld1                       ; st(0) = 1 | st(1) = x * log_2(e) 
    fscale                     ; fscale: st(0) = st(0) * 2 ^ (st(1)) | st(0) = 2 ^ (int)(x * log_2(e)) | st(1) = x * log_2(e)
    fxch                       ; st(0) = x * log_2(e) | st(1) = 2 ^ (int)(x * log_2(e))
    fld1                       ; st(0) = 1 | st(1) = x * log_2(e) | st(2) = 2 ^ (int)(x * log_2(e))
    fxch                       ; st(0) = x * log_2(e) | st(1) = 1 | st(2) =  2 ^ (int)(x * log_2(e))
    fprem1                     ; fprem1: st(0) = st(0) mod st(1) | st(0) = (frac)(x * log_2(e)) | st(1) = 1 | st(2) =  2 ^ (int)(x * log_2(e))
    f2xm1                      ; f2xm1: 2 ^ (st(0)) - 1 | st(0) = 2 ^ (frac)(x * log_2(e)) - 1 | st(1) = 1 | st(2) = 2 ^ (int)(x * log_2(e))
    faddp                      ; faddp: st(1) = st(1) + st(0) | st(0) =  2 ^ (frac)(x * log_2(e)) | st(1) = 2 ^ (int)(x * log_2(e))
    fmulp                      ; st(0) = e ^ x

    fstp      dword[result]
    ret

sinh:
    call      exp

    fld       dword[result]    ; st(0) = e ^ x
    fld1                       ; st(0) = 1 | st(1) = e ^ x
    fld       dword[result]    ; st(0) = e ^ x | st(1) = 1 | st(2) = e ^ x
    fdiv                       ; st(0) = 1 / e ^ x | st(1) = e ^ x
    fsubp                      ; fsubp: st(1) = st(1) - st(0) | st(0) = e ^ x - (1 / e ^ x)
    fld1                       ; st(0) = 1 | st(1) = e ^ x - (1 / e ^ x)
    fld1                       ; st(0) = 1 | st(1) = 1 | st(2) = e ^ x - (1 / e ^ x)
    faddp                      ; st(0) = 2 | st(1) = e ^ x - e ^ -x
    fdiv                       ; st(0) = (e ^ x - e ^ -x) / 2 = sinh(x)

    fstp     dword[result]
    ret

arsinh:
    fld       dword[x]         ; st(0) = x
    fld       dword[x]         ; st(0) = x | st(1) = x
    fmulp                      ; st(0) = x * x
    fld1                       ; st(0) = 1 | st(1) = x ^ 2
    faddp                      ; st(0) = 1 + x ^ 2
    fsqrt                      ; st(0) = sqrt(1 + x ^ 2)
    fld       dword[x]         ; st(0) = x | st(1) = sqrt(1 + x ^ 2)
    faddp                      ; st(0) = x + sqrt(1 + x ^ 2)
    fld1                       ; st(0) = 1 | st(1) = x + sqrt(1 + x ^ 2)
    fldl2e                     ; st(0) = log_2(e) | st(1) = 1 | st(2) = x + sqrt(1 + x ^ 2)
    fdiv                       ; st(0) = 1 / log_2(e) | st(1) = x + sqrt(1 + x ^ 2)
    fxch                       ; st(0) = x + sqrt(1 + x ^ 2) | st(1) =  1 / log_2(e) 
    fyl2x                      ; st(0) = (log_2(x + sqrt(x ^ 2 + 1))) * (1 / log_2(e)) = ln(x + sqrt(x ^ 2 + 1)) = arsinh(x)

    fstp      dword[result]
    ret
