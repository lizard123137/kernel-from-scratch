section .multiboot_header
header_start:
    dd 0xe85250d6                   ; Magic number
    dd 0                            ; Protected i386 mode
    dd header_end - header_start    ; Header length
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; Optional tags
    ; No optional tags for now

    ; Ending tags
    dw 0
    dw 0
    dd 8
header_end:

