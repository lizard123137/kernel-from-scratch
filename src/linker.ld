ENTRY(start)

SECTIONS {
    . = 2M;

    .text :
    {
        *(.multiboot)
        *(.text)
    }
}