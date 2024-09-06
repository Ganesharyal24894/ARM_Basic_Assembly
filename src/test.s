.syntax unified
.cpu  cortex-m4
.fpu softvfp
.thumb


.word 0x20010000
.word 0x08000195
.space 396


RCC_BASE_ADD = 0x40023800
GPIOC_BASE_ADD = 0x40020800
GPIOA_BASE_ADD = 0x40020000


AHB1ENR_OFF = 0x30
MODER_OFF = 0x00
IDR_OFF = 0x10
BSRR_OFF = 0x18
ODR_OFF = 0x14

GPIOC_EN_BIT = 0x04
GPIOA_EN_BIT = 0x01
IDR_BIT = 8
BUTTON_MODER_BIT = IDR_BIT*2
ODR_BIT = 13



DELAY = 800000


.global main
main:
	/* Copy the data segment initializers from flash to SRAM */
	ldr r0, =_sdata
	ldr r1, =_edata
	ldr r2, =_sload_data
	movs r3, #0
	b LoopCopyDataInit

	CopyDataInit:
	ldr r4, [r2, r3]
	str r4, [r0, r3]
	adds r3, r3, #4

	LoopCopyDataInit:
	adds r4, r0, r3
	cmp r4, r1
	bcc CopyDataInit

	//enable GPIOC port
	ldr r0,=RCC_BASE_ADD+AHB1ENR_OFF
	ldr r1,[r0]
	orr r1,#GPIOC_EN_BIT
	orr r1,#GPIOA_EN_BIT
	str r1,[r0]

	//set PA8 as Input
	ldr r0,=GPIOA_BASE_ADD+MODER_OFF
	ldr r1,[r0]
	mov r2, #0x03
	lsl r2,#BUTTON_MODER_BIT
   	bic r1,r2
	str r1,[r0]

	//set PC13 as Output
	ldr r0,=GPIOC_BASE_ADD+MODER_OFF
	ldr r1,[r0]
	mov r2, #1
   	lsl r2, r2, #26
    orr r1, r1, r2
    mov r2, #1
    lsl r2, r2, #27
    bic r1, r1, r2
	str r1,[r0]



loop:

	//Read User Input button PA8
	ldr r0,=GPIOA_BASE_ADD+IDR_OFF
	ldr r1,[r0]
	mov r0,#1
	lsl	r0,#IDR_BIT
	and r1,r0
	cmp r1,#0
	bne ButtonNotPressed

	

	//Toggle PC13
	ldr r0,=GPIOC_BASE_ADD+ODR_OFF
	mov r1, #1
   	lsl r1, #ODR_BIT
	ldr r2,[r0]
	eor r2,r1
	str r2,[r0]

	//add some delay here
	bl delay
	
ButtonNotPressed:
	b loop


delay:
	ldr r2,=delay_var
	ldr r2,[r2]

delay_cont:
	subs r2,r2,#1
	bne delay_cont
	bx lr



	b .


.data
delay_var:
	.word 400000
