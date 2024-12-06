%define BOOT_LOCATION       (0x7C00)
%define BOOT_SIGNATURE      (0xAA55)

[bits 16]
[org BOOT_LOCATION]

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

start:
    cli                     ; Clear and disable Interrupts
    mov ax, 0x00            ; Clear registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00          ; Initialize stack
    sti                     ; Enable interrupts

; Load Protected mode
load_PM:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0            ; Copy register to eax
    or al, 1                ; Set Protected mode flag
    mov cr0, eax            ; Set it back to CR0
    jmp CODE_OFFSET:PModeMain

; GDT
gdt_start:
    dd 0x00000000
    dd 0x00000000

    ; Code segment descriptor
    dw 0xFFFF               ; Limit
    dw 0x0000               ; Base
    db 0x00                 ; Base
    db 10011010b            ; Access byte
    db 11001111b            ; Flags
    db 0x00                 ; Base
    
    ; Data segment descriptor
    dw 0xFFFF               ; Limit
    dw 0x0000               ; Base
    db 0x00                 ; Base
    db 10010010b            ; Access byte
    db 11001111b            ; Flags
    db 0x00                 ; Base
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[bits 32]
PModeMain:
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9c00         ; Set new stack
    mov esp, ebp

    in al, 0x92
    or al, 2
    out 0x92, al

    jmp $

times 510 - ($-$$) db 0     ; Fill the rest of the segment with zeros
dw BOOT_SIGNATURE           ; Boot signature needed by BIOS