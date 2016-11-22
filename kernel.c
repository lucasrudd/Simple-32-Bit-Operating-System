void main()
{
    const char *str = "My first kernel";
    volatile short int *vidptr = (volatile short int*)0xb8000;      // 0xb8000 is the memory address of the upper left hand corner of the screen

    while(*str){
        *vidptr++ = 0x07;
        *vidptr++ = *str++;
    }
    return;

}
