.syntax unified
.cpu  cortex-m4
.fpu softvfp
.thumb


.word 0x20010000
.word 0x08000195
.space 396


.equ RCC_BASE_ADD,0x40023800
.equ GPIOC_BASE_ADD,0x40020800

.equ AHB1ENR_OFF,0x30
.equ MODER_OFF,0x00
.equ BSRR_OFF,0x18
.equ ODR_OFF,0x14

.equ GPIOC_EN_BIT,0x04
.equ ODR_13_BIT,13


.equ DELAY,800000


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
	ldr r0,=RCC_BASE_ADD
	ldr r1,[r0,#AHB1ENR_OFF]
	orr r1,r1,#GPIOC_EN_BIT
	str r1,[r0,#AHB1ENR_OFF]

	//set PC13 as Output
	ldr r0,=GPIOC_BASE_ADD
	ldr r1,[r0,#MODER_OFF]
	mov r2, #1
   	lsl r2, r2, #26
    orr r1, r1, r2
    mov r2, #1
    lsl r2, r2, #27
    bic r1, r1, r2
	str r1,[r0,#MODER_OFF]

loop:
	//Toggle PC13
	mov r1, #1
   	lsl r1, #ODR_13_BIT
	ldr r2,[r0,#ODR_OFF]
	eor r2,r1
	str r2,[r0,#ODR_OFF]

	//add some delay here
	bl delay

	//increasing delay
	ldr r1,=delay_var
	ldr r2,[r1]
	ldr r3,=100000
	add r2,r3
	str r2,[r1]

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