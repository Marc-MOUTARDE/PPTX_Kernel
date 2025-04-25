    .code16
    
    .section .text.boot
    .global _start

_start:
    .fill 0x22, 1, 0x90
    
    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    mov $0x7c00, %sp

    ljmp $0x00, $start
start:
    in $0x92, %al
    or $2, %al
    out %al, $0x92

    lgdt (gdt_ptr)

    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    cli
    ljmp $0x08, $entry32
    .code32

entry32:
    movl $0x024b024f, (0xb8000)
    hlt

gdt_ptr:
    .word gdt_end - gdt_start
    .long gdt_start
gdt_start:
    .quad 0

    .word 0xffff
    .word 0
    .byte 0
    .byte 0x9a
    .byte 0xcf
    .byte 0

    .word 0xffff
    .word 0
    .byte 0
    .byte 0x92
    .byte 0xcf
    .byte 0
gdt_end:
    nop

    .org 510
    .word 0xaa55