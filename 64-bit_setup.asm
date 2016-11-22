

    ;Move p3_table into the eax register
    ;Then, set the first two bits, the 'present' bit
    ;and 'writable' bit, of the level-3 page table.
    ;Then set the zeroth entry of p4_table to
    ;p3_table, essentially 'pointing' to p3_table.
mov eax, p3_table
    or eax, 0b11
    mov dword [p4_table], eax

    ;Point the first entry of p3_table to p2_table
    mov eax, p2_table
    or eax, 0b11
    mov dword [p3_table], eax

    mov ecx, 0                              ;Set the loop counter (ecx) to 0

    .map_p2_table:
        mov eax, 0x200000                   ;2MiB
        mul ecx                             ;The address location of the next page. Each
                                            ;page is 2 binary megabytes in size so we have
                                            ;to increment the next address space by 2MiB each
                                            ;loop iteration.

        or eax, 0b10000011                  ;Setting the 'Huge Page Bit' (which will indicate a page
                                            ;size of 2MiB instead of 4KiB), present bit, and writable bit
        mov [p2_table + ecx * 8], eax
        inc ecx
        cmp ecx, 512
        jne .map_p2_table

    ;Informing the CPU of the page tables
    mov eax, p4_table
    mov cr3, eax
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ;Enable paging
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax

section .bss

align 4096

;reserving 4096 bytes for each page table
p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096


;Creating a very minimal GDT
section .rodata
gdt64:
    dq 0

;Enabling the descriptor type, present,
;read/write, executable, and 64-bit bits
;(bit 44, 47, 41, 43, and 53 respectively)
.code: equ $ - gdt64
    dq (1 << 44) | (1 << 47) | (1 << 41) | (1 << 43) | (1 << 53)

.data: equ $ - gdt64
    dq (1 << 44) | (1 << 47) | (1 << 41)

.pointer:
    dw .pointer - gdt64 -1
    dq gdt64

;Load global descriptor table
lgdt[gdt64.pointer]


;Update segmentation registers
mov ax, gdt64.data      ;A 16-bit register
mov ss, ax              ;The stack segment register
mov ds, ax              ;The data segment register
mov es, ax              ;An extra segment register

;Start 64-bit mode
jmp gdt64.code:long_mode_start


section .text
bits 64
long_mode_start:
    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xffffc000000b8000], rax
    hlt
