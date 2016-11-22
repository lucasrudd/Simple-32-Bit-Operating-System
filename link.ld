/*
 * specifies the point of entry of the program
 */
ENTRY(start)
SECTIONS
{
    /*
     * the location counter is set at the address 0x100000
     * which is the start of the kernel's code
     */
    . = 0x100000;
    .boot : { *(.multiboot_header)} /* allows the GRUB multiboot loader to be able to find necessary boot information */
    .text : { *(.text) }            /* sets all text sections to the address 0x100000 */
    .data : { *(.data) }            /* sets all data sections to the address 0x100000 + size of the text section */
    .bss  : { *(.bss)  }            /* sets all bss  sections to the address 0x100000 + size of the text and data sections */
    /*.rodata : { *(.rodata)}*/
}
