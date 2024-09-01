ENTRY(main)

/*Memory section definition*/
MEMORY
{
    RAM    (rw)    : ORIGIN = 0x20000000,   LENGTH = 64K
    FLASH  (rx)    : ORIGIN = 0x08000000,   LENGTH = 256K
}

SECTIONS
{
    .text :
  {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    . = ALIGN(4);
  } >FLASH

    .rodata :
  {
    . = ALIGN(4);
    *(.rodata)
    . = ALIGN(4);
  } >FLASH

   .data :
  {  
    . = ALIGN(4);
    _sdata = . ; 
    *(.data)
    _edata = . ;
    . = ALIGN(4);      
  } >RAM AT> FLASH

    _sload_data = LOADADDR(.data);      /*This contains the load address of the .data section*/

   .bss :
  {
    . = ALIGN(4);
    _sbss = . ;
    *(.bss)
    _ebss = . ;
    . = ALIGN(4);
  } >RAM

}
