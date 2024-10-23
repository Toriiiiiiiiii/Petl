    section .text
    global main
    extern strlen
    extern printf
    extern realloc
    extern free
    extern malloc
main:
    mov rax, 1024
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call malloc
    add rsp, 8
    call __stk_push
    call __stk_pop
    mov [GLOB_strbuf], rax
    mov rax, 1024
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call malloc
    add rsp, 8
    call __stk_push
    call __stk_pop
    mov [GLOB_copybuf], rax
    mov rax, STR_0
    call __stk_push
    call FN_puts
    mov rax, 1024
    call __stk_push
    mov rax, [GLOB_strbuf]
    call __stk_push
    call FN_getln
    mov rax, 1024
    call __stk_push
    mov rax, [GLOB_copybuf]
    call __stk_push
    mov rax, [GLOB_strbuf]
    call __stk_push
    call FN_memcpy
    mov rax, [GLOB_copybuf]
    call __stk_push
    mov rax, STR_1
    call __stk_push
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rsi, rax
    mov rax, 0
    call printf
    add rsp, 16
    mov rax, [GLOB_copybuf]
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call free
    add rsp, 8
    mov rax, [GLOB_strbuf]
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call free
    add rsp, 8
_done:
    mov rdi, 0
_exit:
    mov rax, 60
    syscall
    ret


FN_main:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    mov rax, STR_2
    call __stk_push
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call printf
    add rsp, 16
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
    call __stk_pop
    mov rdi, rax
    mov rax, 0
    call strlen
    add rsp, 8
    call __stk_push
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
WHILE_0:
    mov rax, [rsp+40]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
OPR_0:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jl OPR_0_OTHR
    mov rax, 0
    jmp OPR_0_DONE
OPR_0_OTHR:
    mov rax, 1
OPR_0_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je WHILE_0_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+40]
    call __stk_push
    mov rax, [rsp+16]
    call __stk_push
OPR_1:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    mul rdi
    call __stk_push
OPR_2:
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
OPR_3:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+40], rax
    jmp WHILE_0
WHILE_0_DONE:
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
WHILE_1:
    mov rax, [rsp+32]
    call __stk_push
    mov rax, [rsp+24]
    call __stk_push
OPR_4:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    cmp rax, rdi
    jl OPR_4_OTHR
    mov rax, 0
    jmp OPR_4_DONE
OPR_4_OTHR:
    mov rax, 1
OPR_4_DONE:
    call __stk_push
    call __stk_pop
    cmp rax, 0
    je WHILE_1_DONE
    mov rax, [rsp+8]
    call __stk_push
    mov rax, [rsp+32]
    call __stk_push
OPR_5:
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
OPR_6:
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
OPR_7:
    call __stk_pop
    mov rdi, rax
    call __stk_pop
    mov rdx, 0
    add rax, rdi
    call __stk_push
    call __stk_pop
    mov [rsp+32], rax
    jmp WHILE_1
WHILE_1_DONE:
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
STR_0: db `Type something: `, 0
STR_1: db `You typed: %s`, 0
STR_2: db `Hello, World!\n`, 0
    section .bss
__stk: resb 2048
GLOB_strbuf: resb 8
GLOB_copybuf: resb 8
