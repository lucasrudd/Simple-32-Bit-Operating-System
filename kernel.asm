;;kernel.asm

;;The CPU hardcodes the instruction pointer, EIP,
;;to the value 0xFFFFFFF0 at startup. Because the
;;EIP is representative of the address of the
;;instruction to be run, the CPU begins its
;;execution at this address
global start
extern main

section .text

bits 32

start:
    ;The address location for the top
    ;left hand corner of the screen is
    ;0xb8000. This is the industry standard
    mov esp, stack_space
    call main
    hlt

section .bss
resb 8192
stack_space:

