%define MAGIC           (0xe85250d6)
%define ARCH            (0)

section .multiboot
header_start:
    dd MAGIC
    dd ARCH
    dd header_end - header_start
    dd 0x100000000 - (MAGIC + ARCH + (header_end - header_start))

    ; end tag
    dw 0
    dw 0
    dd 8
header_end:


