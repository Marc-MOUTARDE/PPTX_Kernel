ENTRY(_start)

SECTIONS
{
    . = 0x7c00;

    .text :
    {
        *(.text.boot)
        *(.text*)
    }

    .shstrtab :
    {
        *(.shstrtab)
    }

    /DISCARD/ : 
    {
        *(*)
    }
}