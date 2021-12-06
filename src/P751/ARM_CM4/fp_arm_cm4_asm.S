.syntax unified
.cpu cortex-m4
.text
    .thumb    
.thumb_func
.global fpadd751_asm
fpadd751_asm:
    push  {r4-r11,lr}

	MOVW  R14,#0xFFFF
	MOVT  R14,#0xFFFF

	mov r3, r2
	ldmia r0!, {r4-r7} 
	ldmia r1!, {r8-r11}

	adds r4, r4, r8	
	adcs r5, r5, r9	
	adcs r6, r6, r10
	adcs r7, r7, r11
	adcs r2, r14, r14

	MOVW  R8,#0xFFFE
	MOVT  R8,#0xFFFF

	subs r4, r4, r8	
	sbcs r5, r5, r14
	sbcs r6, r6, r14
	sbcs r7, r7, r14
	sbcs r12, r12, r12

	stmia r3!, {r4-r7} 

	ldmia r0!, {r4-r7} 
	ldmia r1!, {r8-r11}

	adds r2, r14, r2, lsl#31
	adcs r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r10		
	adcs r7, r7, r11		
	adcs r2, r14, r14		

	subs r12, r0, r12		
	sbcs r4, r4, r14		
	sbcs r5, r5, r14		
	sbcs r6, r6, r14		
	sbcs r7, r7, r14		
	sbcs r12, r12, r12		

	stmia r3!, {r4-r7} 			

	ldmia r0!, {r4-r7} 			
	ldmia r1!, {r8-r11} 		

	adds r2, r14, r2, lsl#31	
	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	adcs r7, r7, r11			
	adcs r2, r14, r14			

	MOVW  R10,#0xFFFF	
	MOVT  R10,#0xDD5F	

	subs r12, r0, r12	
	sbcs r4, r4, r14	
	sbcs r5, r5, r14	
	sbcs r6, r6, r14	
	sbcs r7, r7, r10	
	sbcs r12, r12, r12	

	stmia r3!, {r4-r7} 	

	ldmia r0!, {r4-r7} 	
	ldmia r1!, {r8-r11} 

	adds r2, r14, r2, lsl#31
	adcs r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r10		
	adcs r7, r7, r11		
	adcs r2, r14, r14		
	

	MOVW  R8,#0xF151	
	MOVT  R8,#0x93F0	
	MOVW  R9,#0x2D0A	
	MOVT  R9,#0xC7D9	
	MOVW  R10,#0x98ED	
	MOVT  R10,#0x27EF	
	MOVW  R11,#0x3634	
	MOVT  R11,#0xB52B	

	subs r12, r0, r12	
	sbcs r4, r4, r8		
	sbcs r5, r5, r9		
	sbcs r6, r6, r10	
	sbcs r7, r7, r11	
	sbcs r12, r12, r12	

	stmia r3!, {r4-r7} 	


	ldmia r0!, {r4-r7} 	
	ldmia r1!, {r8-r11} 

	adds r2, r14, r2, lsl#31	
	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	adcs r7, r7, r11			
	adcs r2, r14, r14			
		
	MOVW  R8,#0xD0ED	
	MOVT  R8,#0xADD7	
	MOVW  R9,#0x30CF	
	MOVT  R9,#0x109D	
	MOVW  R10,#0xAE90	
	MOVT  R10,#0xB964	
	MOVW  R11,#0x6A08	
	MOVT  R11,#0xAC5	

	subs r12, r0, r12		
	sbcs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		
	sbcs r12, r12, r12		

	stmia r3!, {r4-r7} 		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	adds r2, r14, r2, lsl#31
	adcs r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r10		
	adcs r7, r7, r11		


	MOVW  R8,#0xB8CD	
	MOVT  R8,#0x2F75	
	MOVW  R9,#0x213F	
	MOVT  R9,#0x1C25	
	MOVW  R10,#0xEE38	
	MOVT  R10,#0xAA83	
	MOVW  R11,#0xDFCB	
	MOVT  R11,#0x0000	

	subs r12, r0, r12	
	sbcs r4, r4, r8		
	sbcs r5, r5, r9		
	sbcs r6, r6, r10	
	sbcs r7, r7, r11	
	sbcs r12, r12, r12	


	stmia r3!, {r4-r7} 	

	sub r3, r3, #4*24	

	ldmia r3, {r4-r7} 		
	MOVW  R8,#0xFFFE	
	MOVT  R8,#0xFFFF	
	MOVW  R9,#0xFFFF	
	MOVT  R9,#0xFFFF	


	and r8, r8, r12		
	and r9, r9, r12		

	adds r4, r4, r8		
	adcs r5, r5, r9		
	adcs r6, r6, r9		
	adcs r7, r7, r9		
	stmia r3!, {r4-r7} 	

	ldmia r3, {r4-r7} 		

	adcs r4, r4, r9		
	adcs r5, r5, r9		
	adcs r6, r6, r9		
	adcs r7, r7, r9		
	stmia r3!, {r4-r7} 		

	ldmia r3, {r4-r7} 	
	MOVW  R10,#0xFFFF	
	MOVT  R10,#0xDD5F	

	and r10, r10, r12	

	adcs r4, r4, r9		
	adcs r5, r5, r9		
	adcs r6, r6, r9		
	adcs r7, r7, r10	
	stmia r3!, {r4-r7} 	
		
	ldmia r3, {r4-r7} 

	MOVW  R8,#0xF151
	MOVT  R8,#0x93F0
	MOVW  R9,#0x2D0A
	MOVT  R9,#0xC7D9
	MOVW  R10,#0x98ED
	MOVT  R10,#0x27EF
	MOVW  R11,#0x3634
	MOVT  R11,#0xB52B

	and r8, r8, r12	
	and r9, r9, r12	
	and r10, r10, r12
	and r11, r11, r12

	adcs r4, r4, r8	
	adcs r5, r5, r9	
	adcs r6, r6, r10
	adcs r7, r7, r11
	stmia r3!, {r4-r7}	
			
	ldmia r3, {r4-r7} 

	MOVW  R8,#0xD0ED	
	MOVT  R8,#0xADD7	
	MOVW  R9,#0x30CF	
	MOVT  R9,#0x109D	
	MOVW  R10,#0xAE90	
	MOVT  R10,#0xB964	
	MOVW  R11,#0x6A08	
	MOVT  R11,#0xAC5	

	and r8, r8, r12		
	and r9, r9, r12		
	and r10, r10, r12	
	and r11, r11, r12	

	adcs r4, r4, r8		
	adcs r5, r5, r9		
	adcs r6, r6, r10	
	adcs r7, r7, r11	
	stmia r3!, {r4-r7} 	
	ldmia r3, {r4-r7} 	

	MOVW  R8,#0xB8CD
	MOVT  R8,#0x2F75
	MOVW  R9,#0x213F
	MOVT  R9,#0x1C25
	MOVW  R10,#0xEE38
	MOVT  R10,#0xAA83
	MOVW  R11,#0xDFCB
	MOVT  R11,#0x0000

	and r8, r8, r12	
	and r9, r9, r12	
	and r10, r10, r12
	and r11, r11, r12

	adcs r4, r4, r8	
	adcs r5, r5, r9	
	adcs r6, r6, r10
	adcs r7, r7, r11
	stmia r3!, {r4-r7} 

	pop  {r4-r11,pc}
    bx lr
//


.thumb_func
.global fpsub751_asm
fpsub751_asm:

    push  {r4-r11,lr}		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	subs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		

	stmia r2!, {r4-r7} 		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	sbcs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		

	stmia r2!, {r4-r7} 		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	sbcs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		

	stmia r2!, {r4-r7} 		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	sbcs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		

	stmia r2!, {r4-r7} 		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	sbcs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		

	stmia r2!, {r4-r7} 		

	ldmia r0!, {r4-r7} 		
	ldmia r1!, {r8-r11} 	

	sbcs r4, r4, r8			
	sbcs r5, r5, r9			
	sbcs r6, r6, r10		
	sbcs r7, r7, r11		
	sbcs r12, r12, r12		

	stmia r2!, {r4-r7} 		
	
	sub r3, r2, #4*24		

	ldmia r3, {r4-r7} 		
	MOVW  R8,#0xFFFE	
	MOVT  R8,#0xFFFF	
	MOVW  R9,#0xFFFF	
	MOVT  R9,#0xFFFF	


	and r8, r8, r12			
	and r9, r9, r12			

	adds r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r9			
	adcs r7, r7, r9			
	stmia r3!, {r4-r7} 		

	ldmia r3, {r4-r7} 		

	adcs r4, r4, r9			
	adcs r5, r5, r9			
	adcs r6, r6, r9			
	adcs r7, r7, r9			
	stmia r3!, {r4-r7} 		
	
	ldmia r3, {r4-r7} 		
	MOVW  R10,#0xFFFF
	MOVT  R10,#0xDD5F

	and r10, r10, r12		

	adcs r4, r4, r9			
	adcs r5, r5, r9			
	adcs r6, r6, r9			
	adcs r7, r7, r10		
	stmia r3!, {r4-r7} 		

	ldmia r3, {r4-r7} 		

	MOVW  R8,#0xF151
	MOVT  R8,#0x93F0
	MOVW  R9,#0x2D0A
	MOVT  R9,#0xC7D9
	MOVW  R10,#0x98ED
	MOVT  R10,#0x27EF
	MOVW  R11,#0x3634
	MOVT  R11,#0xB52B

	and r8, r8, r12			
	and r9, r9, r12			
	and r10, r10, r12		
	and r11, r11, r12		

	adcs r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r10		
	adcs r7, r7, r11		
	stmia r3!, {r4-r7} 		
		
	ldmia r3, {r4-r7} 		

	MOVW  R8,#0xD0ED	
	MOVT  R8,#0xADD7	
	MOVW  R9,#0x30CF	
	MOVT  R9,#0x109D	
	MOVW  R10,#0xAE90	
	MOVT  R10,#0xB964	
	MOVW  R11,#0x6A08	
	MOVT  R11,#0xAC5	

	and r8, r8, r12			
	and r9, r9, r12			
	and r10, r10, r12		
	and r11, r11, r12		

	adcs r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r10		
	adcs r7, r7, r11		
	stmia r3!, {r4-r7} 		

	ldmia r3, {r4-r7} 		

	MOVW  R8,#0xB8CD
	MOVT  R8,#0x2F75
	MOVW  R9,#0x213F
	MOVT  R9,#0x1C25
	MOVW  R10,#0xEE38
	MOVT  R10,#0xAA83
	MOVW  R11,#0xDFCB
	MOVT  R11,#0x0000

	and r8, r8, r12			
	and r9, r9, r12			
	and r10, r10, r12		
	and r11, r11, r12		

	adcs r4, r4, r8			
	adcs r5, r5, r9			
	adcs r6, r6, r10		
	adcs r7, r7, r11		
	stmia r3!, {r4-r7} 		

	pop  {r4-r11,pc}		
    bx lr
//



.MACRO K_A A0 A1 B0 B1 C0 C1 C2 C3

	MOV \C2, #0
    MOV \C3, #0
    UMULL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0
    UMLAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1

.ENDM

.MACRO K_B A0 A1 B0 B1 C0 C1 C2 C3

    MOV \C2, #0
    MOV \C3, #0

    UMLAL \C0, \C2, \A0, \B0
    UMAAL \C1, \C2, \A1, \B0
    UMLAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1 

.ENDM

.MACRO K_C A0 A1 B0 B1 C0 C1 C2 C3

    UMAAL \C0, \C2, \A0, \B0
    UMAAL \C1, \C2, \A1, \B0
    UMAAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1

.ENDM

.MACRO K_D A0 A1 B0 C0 C1 C2

    UMAAL \A0, \B0, \C0, \C2
    UMAAL \A1, \B0, \C1, \C2

.ENDM

.MACRO K_E A0 A1 B0 C0 C1 C2

    MOV \C2, #0
    UMLAL \A0, \B0, \C0, \C2
    UMAAL \A1, \B0, \C1, \C2

.ENDM


.MACRO K44_A A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	K_A R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C0, R7
	VMOV \C1, R8

	VMOV R3, \A2
	VMOV R4, \A3

	K_B R3, R4, R5, R6, R9, R10, R7, R8

	VMOV R5, \B2
	VMOV R6, \B3
	VMOV R3, \A0
	VMOV R4, \A1

	K_B R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C2, R9
	VMOV \C3, R10

	VMOV R3, \A2
	VMOV R4, \A3

	K_C R3, R4, R5, R6, R7, R8, R11, R12

	VMOV \C4, R7
	VMOV \C5, R8
	VMOV \C6, R11
	VMOV \C7, R12

.ENDM

.MACRO K44_B A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	VMOV R7, \C0
	VMOV R8, \C1

	K_B R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C0, R7
	VMOV \C1, R8

	VMOV R3, \A2
	VMOV R4, \A3

	VMOV R7, \C2
	VMOV R8, \C3

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B2
	VMOV R6, \B3

	K_B R3, R4, R5, R6, R7, R8, R11, R12

	VMOV R3, \A2
	VMOV R4, \A3

	VMOV \C2, R7
	VMOV \C3, R8

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C4, R9
	VMOV \C5, R10
	VMOV \C6, R11
	VMOV \C7, R12
     
.ENDM

.MACRO K44_C A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7 

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	VMOV R7, \C0
	VMOV R8, \C1
	VMOV R9, \C4
	VMOV R10, \C5

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C0, R7
	VMOV \C1, R8

	VMOV R3, \A2
	VMOV R4, \A3

	VMOV R7, \C2
	VMOV R8, \C3

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B2
	VMOV R6, \B3

	VMOV R11, \C6
	VMOV R12, \C7

	K_C R3, R4, R5, R6, R7, R8, R11, R12

	VMOV \C2, R7
	VMOV \C3, R8

	VMOV R3, \A2
	VMOV R4, \A3

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C4, R9
	VMOV \C5, R10
	VMOV \C6, R11
	VMOV \C7, R12

.ENDM

.MACRO K88_A A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 B6 B7 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15

    K44_A \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7

    K44_B \A4, \A5, \A6, \A7, \B0, \B1, \B2, \B3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11

    K44_B \A0, \A1, \A2, \A3, \B4, \B5, \B6, \B7, \C4, \C5, \C6, \C7, \C12, \C13, \C14, \C15

    K44_C \A4, \A5, \A6, \A7,\B4, \B5, \B6, \B7,\C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

.ENDM

.MACRO K88_B A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 B6 B7 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15

    K44_B \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3, \C8, \C9, \C10, \C11

    K44_C \A4, \A5, \A6, \A7, \B0, \B1, \B2, \B3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11

    K44_B \A0, \A1, \A2, \A3, \B4, \B5, \B6, \B7, \C4, \C5, \C6, \C7, \C12, \C13, \C14, \C15

    K44_C \A4, \A5, \A6, \A7, \B4, \B5, \B6, \B7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

.ENDM

.MACRO K88_C A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 B6 B7 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15

    K44_C \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3, \C8, \C9, \C10, \C11

    K44_C \A4, \A5, \A6, \A7, \B0, \B1, \B2, \B3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11

    K44_C \A0, \A1, \A2, \A3, \B4, \B5, \B6, \B7, \C4, \C5, \C6, \C7, \C12, \C13, \C14, \C15

    K44_C \A4, \A5, \A6, \A7, \B4, \B5, \B6, \B7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

.ENDM

.MACRO K1616_A

    VLDR S0, [R0, #0]
    VLDR S1, [R0, #4]
    VLDR S2, [R0, #8]
    VLDR S3, [R0, #12]
    VLDR S4, [R0, #16]
    VLDR S5, [R0, #20]
    VLDR S6, [R0, #24]
    VLDR S7, [R0, #28]

    VLDR S8, [R1, #0]
    VLDR S9, [R1, #4]
    VLDR S10, [R1, #8]
    VLDR S11, [R1, #12]
    VLDR S12, [R1, #16]
    VLDR S13, [R1, #20]
    VLDR S14, [R1, #24]
    VLDR S15, [R1, #28]

    K88_A S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31

    VSTM R2!, {S16-S23}

    VPUSH {S0-S7}

    VLDR S0, [R0, #32]
    VLDR S1, [R0, #36]
    VLDR S2, [R0, #40]
    VLDR S3, [R0, #44]
    VLDR S4, [R0, #48]
    VLDR S5, [R0, #52]
    VLDR S6, [R0, #56]
    VLDR S7, [R0, #60]
    
    K88_B S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15,  S24, S25, S26, S27, S28, S29, S30, S31, S16, S17, S18, S19, S20, S21, S22, S23

    VPOP {S0-S7}
    VLDR S8, [R1, #32]
    VLDR S9, [R1, #36]
    VLDR S10, [R1, #40]
    VLDR S11, [R1, #44]
    VLDR S12, [R1, #48]
    VLDR S13, [R1, #52]
    VLDR S14, [R1, #56]
    VLDR S15, [R1, #60]

    VPUSH {S16-S23}

    K88_B S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S24, S25, S26, S27, S28, S29, S30, S31, S16, S17, S18, S19, S20, S21, S22, S23

    VLDR S0, [R0, #32]
    VLDR S1, [R0, #36]
    VLDR S2, [R0, #40]
    VLDR S3, [R0, #44]
    VLDR S4, [R0, #48]
    VLDR S5, [R0, #52]
    VLDR S6, [R0, #56]
    VLDR S7, [R0, #60]
    
    VSTM R2!, {S24-S31}
    VPOP {S24-S31}

    K88_C S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31

.ENDM


.MACRO Kcomplete C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15

    VLDR S0, [R0, #0]
    VLDR S1, [R0, #4]
    VLDR S2, [R0, #8]
    VLDR S3, [R0, #12]
    VLDR S4, [R0, #16]
    VLDR S5, [R0, #20]
    VLDR S6, [R0, #24]
    VLDR S7, [R0, #28]

    VLDR S8,  [R1, #64]
    VLDR S9,  [R1, #68]
    VLDR S10, [R1, #72]
    VLDR S11, [R1, #76]
    VLDR S12, [R1, #80]
    VLDR S13, [R1, #84]
    VLDR S14, [R1, #88]
    VLDR S15, [R1, #92]

	VPUSH {\C8-\C15}

	K88_B S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

	VPOP {S0-S7}
	VPUSH {\C0-\C7}

	VLDR \C0, [R0, #32]
    VLDR \C1, [R0, #36]
    VLDR \C2, [R0, #40]
    VLDR \C3, [R0, #44]
    VLDR \C4, [R0, #48]
    VLDR \C5, [R0, #52]
    VLDR \C6, [R0, #56]
    VLDR \C7, [R0, #60]

	K88_C \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, S8, S9, S10, S11, S12, S13, S14, S15, S0, S1, S2, S3, S4, S5, S6, S7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

	VPOP {\C0-\C7}
	VPUSH {\C8-\C15}
	VPUSH {S0-S7}

	VLDR S0, [R1, #0]
    VLDR S1, [R1, #4]
    VLDR S2, [R1, #8]
    VLDR S3, [R1, #12]
    VLDR S4, [R1, #16]
    VLDR S5, [R1, #20]
    VLDR S6, [R1, #24]
    VLDR S7, [R1, #28]

	VLDR S8,  [R0, #64]
    VLDR S9,  [R0, #68]
    VLDR S10, [R0, #72]
    VLDR S11, [R0, #76]
    VLDR S12, [R0, #80]
    VLDR S13, [R0, #84]
    VLDR S14, [R0, #88]
    VLDR S15, [R0, #92]

	K88_B S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

	VSTM R2!, {\C0-\C7}

	VPOP {\C0-\C7}

	VLDR S0, [R1, #32]
    VLDR S1, [R1, #36]
    VLDR S2, [R1, #40]
    VLDR S3, [R1, #44]
    VLDR S4, [R1, #48]
    VLDR S5, [R1, #52]
    VLDR S6, [R1, #56]
    VLDR S7, [R1, #60]

	K88_C S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

	VSTM R2!, {\C0-\C7}


	VLDR S0,  [R0, #64]
    VLDR S1,  [R0, #68]
    VLDR S2,  [R0, #72]
    VLDR S3,  [R0, #76]
    VLDR S4,  [R0, #80]
    VLDR S5,  [R0, #84]
    VLDR S6,  [R0, #88]
    VLDR S7,  [R0, #92]
	VLDR S8,  [R1, #64]
    VLDR S9,  [R1, #68]
    VLDR S10, [R1, #72]
    VLDR S11, [R1, #76]
    VLDR S12, [R1, #80]
    VLDR S13, [R1, #84]
    VLDR S14, [R1, #88]
    VLDR S15, [R1, #92]

	VPOP {\C0-\C7}

	//8X8+8+8
	K88_C S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15


	VSTM R2!, {\C0-\C15}
.ENDM

.thumb_func
.global dxd_asm
dxd_asm:

	push {r3-r4}
	umull r3, r4, r0, r1
	stm r2, {r3-r4}
	pop {r3-r4}
	bx lr

.thumb_func
.global fpmul751_asm
fpmul751_asm:

    PUSH {R3-R12, LR}

    K1616_A

	Kcomplete S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31

    POP  {R3-R12, LR}

    BX LR
//