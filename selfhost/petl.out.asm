    section .text
    global main
    extern printf
    extern realloc
    extern free
    extern malloc
main:
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_NULL], rax
    mov rax, 1
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_INTLITERAL], rax
    mov rax, 2
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_KEYWORD], rax
    mov rax, 3
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_STRLITERAL], rax
    mov rax, 4
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_OPERATION], rax
    mov rax, 5
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_PARENTHESIS], rax
    mov rax, 32
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_SIZE], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_TYPEOFFSET], rax
    mov rax, 8
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_LINEOFFSET], rax
    mov rax, 16
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_COLOFFSET], rax
    mov rax, 24
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKEN_VALUEOFFSET], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKENLIST_CAPOFFSET], rax
    mov rax, 8
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKENLIST_SIZEOFFSET], rax
    mov rax, 16
    call __stk_push
    call __stk_pop
    mov [GLOB_TOKENLIST_BUFOFFSET], rax
    mov rax, 69
    call __stk_push
    call __stk_pop
    mov [GLOB_testVar], rax
    mov rax, GLOB_testVar
    call __stk_push
    call __stk_pop
    mov [GLOB_testPtr], rax
    mov rax, 24
    call __stk_push
    mov rax, [GLOB_testPtr]
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    call FN_main
_done:
    mov rdi, 0
_exit:
    mov rax, 60
    syscall
    ret


FN_main:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+8], rax
    mov rax, [GLOB_TOKEN_INTLITERAL]
    call __stk_push
    call __stk_pop
    mov [rsp+8], rax
    mov rax, 12
    call __stk_push
    call __stk_pop
    mov [rsp+16], rax
    mov rax, 34
    call __stk_push
    call __stk_pop
    mov [rsp+24], rax
    mov rax, STR_0
    call __stk_push
    call __stk_pop
    mov [rsp+32], rax
    call FN_initTokenList
    call __stk_pop
    mov [rsp+48], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
    mov rax, [rsp+48]
    call __stk_push
    call FN_tokenlistAppend
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+56], rax
    lea rax, [rsp+56]
    call __stk_push
    mov rax, 0
    call __stk_push
    mov rax, [rsp+48]
    call __stk_push
    call FN_tokenlistPeek
    mov rax, [rsp+56]
    call __stk_push
    mov rax, [rsp+64]
    call __stk_push
    mov rax, [rsp+72]
    call __stk_push
    mov rax, [rsp+80]
    call __stk_push
    call FN_printToken
    jmp FN_END
FN_strlen:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    call __stk_pop
    mov [rsp+8], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+16], rax
WHILE_0:
    mov rax, 1
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je WHILE_0_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
OPR_0:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov al, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+24], rax
IF_0:
    mov rax, [rsp+24]
    call __stk_push
    mov rax, 0
    call __stk_push
OPR_1:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    je OPR_1_OTHR
    mov rax, 0
    jmp OPR_1_DONE
OPR_1_OTHR:
    mov rax, 1
OPR_1_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je IF_0_DONE
    mov rax, [rsp+16]
    call __stk_push
    jmp FN_END
    jmp IF_0_DONE
IF_0_DONE:
    mov rax, [rsp+16]
    call __stk_push
    mov rax, 1
    call __stk_push
OPR_2:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+16], rax
    jmp WHILE_0
WHILE_0_DONE:
    jmp FN_END
FN_getln:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    call __stk_pop
    mov [rsp+8], rax
    call __stk_pop
    mov [rsp+16], rax
    mov rax, [rsp+8]
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, [rsp+16]
    call __stk_push
    call __stk_pop
    mov rdx, rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov rax, rax
    syscall
    call __stk_push
    jmp FN_END
FN_puts:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    call __stk_pop
    mov [rsp+8], rax
    mov rax, [rsp+8]
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, [rsp+8]
    call __stk_push
    call FN_strlen
    call __stk_pop
    mov rdx, rax
    mov rax, 1
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 1
    call __stk_push
    call __stk_pop
    mov rax, rax
    syscall
    call __stk_push
    jmp FN_END
FN_memset:
    push rbp
    mov rbp, rsp
    sub rsp, 56
    call __stk_pop
    mov [rsp+8], rax
    call __stk_pop
    mov [rsp+16], rax
    call __stk_pop
    mov [rsp+24], rax
    call __stk_pop
    mov [rsp+32], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+40], rax
WHILE_1:
    mov rax, [rsp+40]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
OPR_3:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jl OPR_3_OTHR
    mov rax, 0
    jmp OPR_3_DONE
OPR_3_OTHR:
    mov rax, 1
OPR_3_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je WHILE_1_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+40]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
OPR_4:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
OPR_5:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+48], rax
    mov rax, [rsp+32]
    call __stk_push
    mov rax, [rsp+48]
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+40]
    call __stk_push
    mov rax, 1
    call __stk_push
OPR_6:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+40], rax
    jmp WHILE_1
WHILE_1_DONE:
    jmp FN_END
FN_memcpy:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    call __stk_pop
    mov [rsp+8], rax
    call __stk_pop
    mov [rsp+16], rax
    call __stk_pop
    mov [rsp+24], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+32], rax
WHILE_2:
    mov rax, [rsp+32]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
OPR_7:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jl OPR_7_OTHR
    mov rax, 0
    jmp OPR_7_DONE
OPR_7_OTHR:
    mov rax, 1
OPR_7_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je WHILE_2_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
OPR_8:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov al, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+40], rax
    mov rax, [rsp+40]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
OPR_9:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+32]
    call __stk_push
    mov rax, 1
    call __stk_push
OPR_10:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+32], rax
    jmp WHILE_2
WHILE_2_DONE:
    jmp FN_END
FN_tokenize:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    call __stk_pop
    mov [rsp+8], rax
    call FN_initTokenList
    call __stk_pop
    mov [rsp+16], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+48], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+56], rax
WHILE_3:
    mov rax, [rsp+56]
    call __stk_push
    mov rax, [rsp+8]
    call __stk_push
    call FN_strlen
OPR_11:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jl OPR_11_OTHR
    mov rax, 0
    jmp OPR_11_DONE
OPR_11_OTHR:
    mov rax, 1
OPR_11_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je WHILE_3_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+56]
    call __stk_push
OPR_12:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov al, [rsi]
    call __stk_push
    mov rax, STR_1
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    call printf
    mov rax, [rsp+56]
    call __stk_push
    mov rax, 1
    call __stk_push
OPR_13:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+56], rax
    jmp WHILE_3
WHILE_3_DONE:
    mov rax, [rsp+16]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
    jmp FN_END
    jmp FN_END
FN_tokenlistPeek:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    call __stk_pop
    mov [rsp+8], rax
    call __stk_pop
    mov [rsp+16], rax
    call __stk_pop
    mov [rsp+24], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_SIZEOFFSET]
    call __stk_push
OPR_14:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+32], rax
IF_1:
    mov rax, [rsp+16]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
OPR_15:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jge OPR_15_OTHR
    mov rax, 0
    jmp OPR_15_DONE
OPR_15_OTHR:
    mov rax, 1
OPR_15_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je IF_1_DONE
    mov rax, STR_2
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call printf
    mov rax, 0
    call __stk_push
    jmp FN_END
    jmp IF_1_DONE
IF_1_DONE:
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+40], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_BUFOFFSET]
    call __stk_push
OPR_16:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+80], rax
    mov rax, [rsp+80]
    call __stk_push
    mov rax, [GLOB_TOKEN_SIZE]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
OPR_17:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
OPR_18:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+88], rax
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_TYPEOFFSET]
    call __stk_push
OPR_19:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+40], rax
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_LINEOFFSET]
    call __stk_push
OPR_20:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+48], rax
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_COLOFFSET]
    call __stk_push
OPR_21:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+56], rax
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_VALUEOFFSET]
    call __stk_push
OPR_22:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+64], rax
    mov rax, [rsp+40]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [GLOB_TOKEN_TYPEOFFSET]
    call __stk_push
OPR_23:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+48]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [GLOB_TOKEN_LINEOFFSET]
    call __stk_push
OPR_24:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+56]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [GLOB_TOKEN_COLOFFSET]
    call __stk_push
OPR_25:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+64]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [GLOB_TOKEN_VALUEOFFSET]
    call __stk_push
OPR_26:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    jmp FN_END
FN_tokenlistAppend:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    call __stk_pop
    mov [rsp+8], rax
    call __stk_pop
    mov [rsp+16], rax
    call __stk_pop
    mov [rsp+24], rax
    call __stk_pop
    mov [rsp+32], rax
    call __stk_pop
    mov [rsp+40], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_SIZEOFFSET]
    call __stk_push
OPR_27:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+56], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_CAPOFFSET]
    call __stk_push
OPR_28:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+64], rax
IF_2:
    mov rax, [rsp+56]
    call __stk_push
    mov rax, [rsp+64]
    call __stk_push
OPR_29:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jge OPR_29_OTHR
    mov rax, 0
    jmp OPR_29_DONE
OPR_29_OTHR:
    mov rax, 1
OPR_29_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je IF_2_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_BUFOFFSET]
    call __stk_push
OPR_30:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+72], rax
    mov rax, [rsp+64]
    call __stk_push
    mov rax, 2
    call __stk_push
OPR_31:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
    mov rax, [rsp+72]
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    call realloc
    call __stk_push
    call __stk_pop
    mov [rsp+72], rax
    mov rax, [rsp+72]
    call __stk_push
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_BUFOFFSET]
    call __stk_push
OPR_32:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+64]
    call __stk_push
    mov rax, 2
    call __stk_push
OPR_33:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_CAPOFFSET]
    call __stk_push
OPR_34:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    jmp IF_2_DONE
IF_2_DONE:
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_BUFOFFSET]
    call __stk_push
OPR_35:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov [rsp+80], rax
    mov rax, [rsp+80]
    call __stk_push
    mov rax, [GLOB_TOKEN_SIZE]
    call __stk_push
    mov rax, [rsp+56]
    call __stk_push
OPR_36:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
OPR_37:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+88], rax
    mov rax, 1
    call __stk_push
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_TYPEOFFSET]
    call __stk_push
OPR_38:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, 2
    call __stk_push
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_LINEOFFSET]
    call __stk_push
OPR_39:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, 3
    call __stk_push
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_COLOFFSET]
    call __stk_push
OPR_40:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+16]
    call __stk_push
    mov rax, [rsp+88]
    call __stk_push
    mov rax, [GLOB_TOKEN_VALUEOFFSET]
    call __stk_push
OPR_41:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    mov rax, [rsp+56]
    call __stk_push
    mov rax, 1
    call __stk_push
OPR_42:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_SIZEOFFSET]
    call __stk_push
OPR_43:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov [rdi], rax
    jmp FN_END
FN_destroyTokenList:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    call __stk_pop
    mov [rsp+8], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKENLIST_BUFOFFSET]
    call __stk_push
OPR_44:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    mov rax, [rsi]
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call free
    jmp FN_END
FN_initTokenList:
    push rbp
    mov rbp, rsp
    sub rsp, 40
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+8], rax
    mov rax, 10
    call __stk_push
    call __stk_pop
    mov [rsp+8], rax
    mov rax, 0
    call __stk_push
    call __stk_pop
    mov [rsp+16], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [GLOB_TOKEN_SIZE]
    call __stk_push
OPR_45:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call malloc
    call __stk_push
    call __stk_pop
    mov [rsp+24], rax
    lea rax, [rsp+8]
    call __stk_push
    jmp FN_END
    jmp FN_END
FN_printToken:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    call __stk_pop
    mov [rsp+8], rax
    call __stk_pop
    mov [rsp+16], rax
    call __stk_pop
    mov [rsp+24], rax
    call __stk_pop
    mov [rsp+32], rax
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
    mov rax, STR_3
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rsi, rax
    call __stk_pop
    mov rdx, rax
    call __stk_pop
    mov rcx, rax
    call __stk_pop
    mov r8, rax
    mov rax, 0
    call printf
    jmp FN_END
FN_END:
    mov rsp, rbp
    pop rbp
    ret
__stk_dup:
    call __stk_pop
    call __stk_push
    call __stk_push
    ret

__stk_push:
    push rax
    push rdi
    mov rdi, [__stk_ptr]
    mov [__stk+rdi], rax
    add rdi, 8
    mov [__stk_ptr], rdi
    pop rdi
    pop rax
    ret

__stk_pop:
    push rdi
    mov rdi, [__stk_ptr]
    sub rdi, 8
    mov rax, [__stk+rdi]
    mov [__stk_ptr], rdi
    pop rdi
    ret


    section .data
__stk_ptr: dq 0
STR_0: db `This is a test token`, 0
STR_1: db `%c\n`, 0
STR_2: db `Attempting to read out of range of list index!\n`, 0
STR_3: db `TOKEN[%lu] : {%lu:%lu, %s}\n`, 0
    section .bss
__stk: resb 2048
GLOB_TOKEN_NULL: resb 8
GLOB_TOKEN_INTLITERAL: resb 8
GLOB_TOKEN_KEYWORD: resb 8
GLOB_TOKEN_STRLITERAL: resb 8
GLOB_TOKEN_OPERATION: resb 8
GLOB_TOKEN_PARENTHESIS: resb 8
GLOB_TOKEN_SIZE: resb 8
GLOB_TOKEN_TYPEOFFSET: resb 8
GLOB_TOKEN_LINEOFFSET: resb 8
GLOB_TOKEN_COLOFFSET: resb 8
GLOB_TOKEN_VALUEOFFSET: resb 8
GLOB_TOKENLIST_CAPOFFSET: resb 8
GLOB_TOKENLIST_SIZEOFFSET: resb 8
GLOB_TOKENLIST_BUFOFFSET: resb 8
GLOB_testVar: resb 8
GLOB_testPtr: resb 8
