.syntax unified
.cpu cortex-m4
.text
    .thumb

.thumb_func
.global fpadd434_asm
fpadd434_asm:
	// Modular addition, c = a+b mod p434.
  	// Inputs: a, b in [0, 2*p434-1] 
  	// Output: c in [0, 2*p434-1] 
	push  {r4-r11,lr}			

	MOV R14, #0xFFFFFFFF	
	
	mov r3, r2 
	ldmia r0!, {r4-r7} 			
	ldmia r1!, {r8-r11} 		
	// c = a + b
	adds r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	adcs r7, r7, r11			
	adc r2, r14, r14			


	MOV R8, #0xFFFFFFFE
	// c = c - p434x2
	subs r4, r4, r8				
	sbcs r5, r5, r14			
	sbcs r6, r6, r14			
	sbcs r7, r7, r14			
	sbcs r12, r12, r12			


	stmia r3!, {r4-r7} 			

	ldmia r0!, {r4-r6} 			
	ldmia r1!, {r8-r10} 		

	adds r2, r14, r2, lsl#31	
	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	adc r2, r14, r14			


	
	MOV R10, #0xC5FFFFFF

	subs r12, r0, r12			
	sbcs r4, r4, r14			
	sbcs r5, r5, r14			
	sbcs r6, r6, r10			
	sbc r12, r12, r12			

	stmia r3!, {r4-r6} 			

	ldmia r0!, {r4-r7} 			
	ldmia r1!, {r8-r11} 		

	adds r2, r14, r2, lsl#31	
	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	adcs r7, r7, r11			
	adc r2, r14, r14			


	MOVW  R8,#0xECF5	
	MOVT  R8,#0xFB82	
	MOVW  R9,#0x5D47	
	MOVT  R9,#0x62B1	
	MOVW  R10,#0xB8F0	
	MOVT  R10,#0xF78C	
	MOVW  R11,#0x40AC	
	MOVT  R11,#0x38A	

	subs r12, r0, r12			
	sbcs r4, r4, r8				
	sbcs r5, r5, r9				
	sbcs r6, r6, r10			
	sbcs r7, r7, r11			
	sbc r12, r12, r12			

	stmia r3!, {r4-r7} 			

	ldmia r0!, {r4-r6} 			
	ldmia r1!, {r8-r10} 		

	adds r2, r14, r2, lsl#31	
	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adc r6, r6, r10			

	MOVW  R8,#0xBFAD	
	MOVT  R8,#0xD9F8	
	MOVW  R9,#0xE688	
	MOVT  R9,#0x4E2E	
	MOVW  R10,#0x683E	
	MOVT  R10,#0x4	

	subs r12, r0, r12			
	sbcs r4, r4, r8				
	sbcs r5, r5, r9				
	sbcs r6, r6, r10			
	sbc r12, r12, r12			

	stmia r3!, {r4-r6} 			

	sub r3, r3, #4*14			

	ldmia r3, {r4-r7} 
	MOV R8, #0xFFFFFFFE		
	MOV R9, #0xFFFFFFFF


	and r8, r8, r12
	and r9, r9, r12	

	adds r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r9				
	adcs r7, r7, r9				
	stmia r3!, {r4-r7}

	ldmia r3, {r4-r6}

	// c = c + (p434x2 & mask)
	MOV  R10,#0xC5FFFFFF	

	and r10, r10, r12			

	adcs r4, r4, r9				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	stmia r3!, {r4-r6} 			

	ldmia r3, {r4-r7} 			
	
	MOVW  R8,#0xECF5	
	MOVT  R8,#0xFB82	
	MOVW  R9,#0x5D47	
	MOVT  R9,#0x62B1	
	MOVW  R10,#0xB8F0	
	MOVT  R10,#0xF78C	
	MOVW  R11,#0x40AC	
	MOVT  R11,#0x38A	

	and r8, r8, r12				
	and r9, r9, r12				
	and r10, r10, r12			
	and r11, r11, r12			

	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adcs r6, r6, r10			
	adcs r7, r7, r11			
	stmia r3!, {r4-r7} 			

	ldmia r3, {r4-r6} 			

	MOVW  R8,#0xBFAD	
	MOVT  R8,#0xD9F8	
	MOVW  R9,#0xE688	
	MOVT  R9,#0x4E2E	
	MOVW  R10,#0x683E	
	MOVT  R10,#0x4

	and r8, r8, r12				
	and r9, r9, r12				
	and r10, r10, r12			

	adcs r4, r4, r8				
	adcs r5, r5, r9				
	adc r6, r6, r10			
	stmia r3!, {r4-r6} 			

	pop  {r4-r11,pc}			
	bx lr



.thumb_func
.global fpsub434_asm
fpsub434_asm:
	// Modular subtraction, c = a-b mod p434.
  	// Inputs: a, b in [0, 2*p434-1] 
  	// Output: c in [0, 2*p434-1] 
    push  {r4-r11,lr}
		
    mov r3, r2             

    ldmia r0!, {r4-r7} 	
    ldmia r1!, {r8-r11} 	

    subs r4, r4, r8		
    sbcs r5, r5, r9		
    sbcs r6, r6, r10	
    sbcs r7, r7, r11	

    stmia r3!, {r4-r7} 	

    ldmia r0!, {r4-r7} 	
    ldmia r1!, {r8-r11} 	

    sbcs r4, r4, r8		
    sbcs r5, r5, r9		
    sbcs r6, r6, r10	
    sbcs r7, r7, r11	

    stmia r3!, {r4-r7} 	

    ldmia r0!, {r4-r7} 	
    ldmia r1!, {r8-r11} 	

    sbcs r4, r4, r8		
    sbcs r5, r5, r9		
    sbcs r6, r6, r10	
    sbcs r7, r7, r11	

    stmia r3!, {r4-r7} 	

    ldmia r0!, {r4-r5} 	
    ldmia r1!, {r8-r9} 	

    sbcs r4, r4, r8		
    sbcs r5, r5, r9		

    sbcs r12, r12, r12	

    stmia r3!, {r4-r5} 	

    sub r3, r3, #4*14	

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

    ldmia r3, {r4-r6} 	

    MOVW  R10,#0xFFFF      
    MOVT  R10,#0xC5FF      

    and r10, r10, r12	

    adcs r4, r4, r9		
    adcs r5, r5, r9		
    adcs r6, r6, r10	
    stmia r3!, {r4-r6} 	

    ldmia r3, {r4-r7} 	

    MOVW  R8,#0xECF5	   
    MOVT  R8,#0xFB82	   
    MOVW  R9,#0x5D47	   
    MOVT  R9,#0x62B1	   
    MOVW  R10,#0xB8F0	   
    MOVT  R10,#0xF78C	   
    MOVW  R11,#0x40AC	   
    MOVT  R11,#0x38A	   

    and r8, r8, r12		
    and r9, r9, r12		
    and r10, r10, r12	
    and r11, r11, r12	

    adcs r4, r4, r8		
    adcs r5, r5, r9		
    adcs r6, r6, r10	
    adcs r7, r7, r11	
    stmia r3!, {r4-r7} 	

    ldmia r3, {r4-r6} 	

    MOVW  R8,#0xBFAD	   
    MOVT  R8,#0xD9F8	   
    MOVW  R9,#0xE688	   
    MOVT  R9,#0x4E2E	   
    MOVW  R10,#0x683E	   
    MOVT  R10,#0x4		   

    and r8, r8, r12		
    and r9, r9, r12		
    and r10, r10, r12	

    adcs r4, r4, r8		
    adcs r5, r5, r9		
    adcs r6, r6, r10	
    stmia r3!, {r4-r6} 	

    pop  {r4-r11,pc}		
    bx lr

.thumb_func
.global fneg434_asm
fneg434_asm:
	// Modular negation, a = -a mod p434.
  	// Input/output: a in [0, 2*p434-1] 
	push  {r4-r11,lr}


	ldmia r0!, {r4-r7}
	
	mov r8, #0xFFFFFFFE
	mov r9, #0xFFFFFFFF


	subs r4, r8, r4		
	sbcs r5, r9, r5 	

	sbcs r6, r9, r6		
	sbcs r7, r9, r7		

	stmia r1!, {r4-r7}
	ldmia r0!, {r4-r7}

	sbcs r4, r9, r4
	sbcs r5, r9, r5

	movw r8, #0xFFFF
	movt r8, #0xC5FF

	movw r9, #0xECF5
	movt r9, #0xFB82

	sbcs r6, r8, r6
	sbcs r7, r9, r7

	stmia r1!, {r4-r7}

	ldmia r0!, {r4-r7}
	movw r8, #0x5D47
	movt r8, #0x62B1
	movw r9, #0xB8F0
	movt r9, #0xF78C

	sbcs r4, r8, r4
	sbcs r5, r9, r5

	movw r8, #0x40AC
	movt r8, #0x038A
	movw r9, #0xBFAD
	movt r9, #0xD9F8

	sbcs r6, r8, r6
	sbcs r7, r9, r7

	stmia r1!, {r4-r7}
	ldmia r0!, {r4-r5}
	movw r8, #0xE688
	movt r8, #0x4E2E
	movw r9, #0x683E
	movt r9, #0x0004

	sbcs r4, r8, R4
	sbcs r5, r9, r5

	stmia r1!, {r4-r5}

	pop	  {r4-r11,lr}
	bx lr


.thumb_func
.global fpcorrection434_asm
fpcorrection434_asm:

	push {r4-r11, lr}

	mov r8, #0xFFFFFFFF		
	//p434[0] FFFF FFFF  |  FFFF FFFF

	ldmia r0!, {r4-r7}
	subs r4, r4, r8
	sbcs r5, r5, r8
							
							
	//p434[1] FFFF FFFF  |  FFFF FFFF
	sbcs r6, r6, r8
	sbcs r7, r7, r8

	vmov s0,r4
	vmov s1,r5
	vmov s2,r6
	vmov s3,r7

	//stmia r1!, {r4-r7}
	ldmia r0!, {r4-r7}
	
	//p434[2] FFFF FFFF  |  FFFF FFFF
	sbcs r4, r4, r8
	sbcs r5, r5, r8
	
	//p434[3] FDC1 767A  |  E2FF FFFF

	movw r8, #0xFFFF
	movt r8, #0xE2FF
	movw r9, #0x767A
	movt r9, #0xFDC1

	sbcs r6, r6, r8
	sbcs r7, r7, r9

	vmov s4,  r4
	vmov s5,  r5
	vmov s6,  r6
	vmov s7,  r7
	
	//stmia r1!, {r4-r7}
	ldmia r0!, {r4-r7}
	
	//p434[4] 7BC6 5C78  |  3158 AEA3

	movw r8, #0xAEA3
	movt r8, #0x3158
	movw r9, #0x5C78
	movt r9, #0x7BC6

	sbcs r4, r4, r8
	sbcs r5, r5, r9

	//p434[5] 6CFC 5FD6  |  81C5 2056

	movw r8, #0x2056
	movt r8, #0x81C5
	movw r9, #0x5FD6
	movt r9, #0x6CFC

	sbcs r6, r6, r8
	sbcs r7, r7, r9

	vmov s8 , 	r4
	vmov s9 , 	r5
	vmov s10 , 	r6
	vmov s11 , 	r7

	ldmia r0!, {r4-r5}
							
	//p434[6] 0x0002 341F 2717 7344

	movw r8, #0x7344
	movt r8, #0x2717
	movw r9, #0x341F
	movt r9, #0x0002

	sbcs r4, r4, r8
	sbcs r5, r5, r9
							

	vmov s12,  r4
	vmov s13,  r5

	//mask ( 0 = BORROW 1 = NO BORROW)
	mov r11, #0
	adc r10, r11, r11
	sub r10, r10, #1

	mov r8, #0xFFFFFFFF		
	
	//p434[0] FFFF FFFF  |  FFFF FFFF

	and r8, r8, r10

	vmov r4,  s0
	vmov r5,  s1
	vmov r6,  s2
	vmov r7,  s3

	adds r4, r4, r8
	adcs r5, r5, r8

	//p434[1] FFFF FFFF  |  FFFF FFFF

	adcs r6, r6, r8
	adcs r7, r7, r8

	stmia r1!, {r4-r7}
	vmov  r4, s4
	vmov  r5, s5
	vmov  r6, s6
	vmov  r7, s7

	//p434[2] FFFF FFFF  |  FFFF FFFF

	adcs r4, r4, r8
	adcs r5, r5, r8

	//p434[3] FDC1 767A  |  E2FF FFFF

	movw r8, #0xFFFF
	movt r8, #0xE2FF
	movw r9, #0x767A
	movt r9, #0xFDC1
	and r8, r8, r10
	and r9, r9, r10


	adcs r6, r6, r8
	adcs r7, r7, r9

	stmia r1!, {r4-r7}

	vmov r4 ,	s8
	vmov r5 ,	s9
	vmov r6 ,	s10
	vmov r7 ,	s11

	//p434[4] 7BC6 5C78  |  3158 AEA3

	movw r8, #0xAEA3
	movt r8, #0x3158
	movw r9, #0x5C78
	movt r9, #0x7BC6
	and r8, r8, r10
	and r9, r9, r10

	adcs r4, r4, r8
	adcs r5, r5, r9

	//p434[5] 6CFC 5FD6  |  81C5 2056

	movw r8, #0x2056
	movt r8, #0x81C5
	movw r9, #0x5FD6
	movt r9, #0x6CFC
	and r8, r8, r10
	and r9, r9, r10

	adcs r6, r6, r8
	adcs r7, r7, r9

	stmia r1!, {r4-r7}

	vmov r4, s12
	vmov r5, s13

	//p434[6] 0x0002 341F 2717 7344

	movw r8, #0x7344
	movt r8, #0x2717
	movw r9, #0x341F
	movt r9, #0x0002
	and r8, r8, r10
	and r9, r9, r10

	adcs r4, r4, r8
	adcs r5, r5, r9

	stmia r1!, {r4-r5}

	pop	{r4-r11,lr}
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

.MACRO K62_C A0 A1 A2 A3 A4 A5 B0 B1 C0 C1 C2 C3 C4 C5 C6 C7

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	VMOV R7, \C0
	VMOV R8, \C1
	VMOV R9, \C2
	VMOV R10, \C3

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C0, R7
	VMOV \C1, R8

	VMOV R3, \A2
	VMOV R4, \A3

	VMOV R7, \C4
	VMOV R8, \C5

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C2, R7
	VMOV \C3, R8

	VMOV R3, \A4
	VMOV R4, \A5

	VMOV R7, \C6
	VMOV R8, \C7

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C4, R7
	VMOV \C5, R8
	VMOV \C6, R9
	VMOV \C7, R10


.ENDM

.MACRO K66_B A0 A1 A2 A3 A4 A5 B0 B1 B2 B3 B4 B5 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11

	//     A0   A1   A2   A3   B0   B1   B2   B3   C0   C1   C2   C3   C4   C5   C6   C7 
	K44_B \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3, \C6, \C7, \C8, \C9

	VMOV R3, \A0
	VMOV R4, \A1

	VMOV R5, \B4
	VMOV R6, \B5

	VMOV R7, \C6
	VMOV R8, \C7
	VMOV R9, \C4
	VMOV R10, \C5

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV R3, \A2
	VMOV R4, \A3

	VMOV R11, \C8
	VMOV R12, \C9

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C10, R11
	VMOV \C11, R12

	VMOV R5, \A4
	VMOV R6, \A5
	VMOV R3, \B0
	VMOV R4, \B1

	K_B R3, R4, R5, R6, R7, R8, R11, R12

	VMOV R3, \B2
	VMOV R4, \B3

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C4, R7
	VMOV \C5, R8
	VMOV \C6, R9
	VMOV \C7, R10

	VMOV R3, \B4
	VMOV R4, \B5

	VMOV R9, \C10
	VMOV R10, \C11

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C8, R9
	VMOV \C9, R10
	VMOV \C10, R11
	VMOV \C11, R12

.ENDM

.MACRO K66_C A0 A1 A2 A3 A4 A5 B0 B1 B2 B3 B4 B5 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11

	K44_C \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3, \C6, \C7, \C8, \C9

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B4
	VMOV R6, \B5

	VMOV R7, \C6
	VMOV R8, \C7
	VMOV R9, \C4
	VMOV R10, \C5

	K44_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV R3, \A2
	VMOV R4, \A3

	VMOV R11, \C8
	VMOV R12, \C9

	K44_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C8, R11
	VMOV \C9, R12

	VMOV R3, \B0
	VMOV R4, \B1
	VMOV R5, \A4
	VMOV R6, \A5

	VMOV R11, \C10
	VMOV R12, \C11

	K44_C R3, R4, R5, R6, R7, R8, R11, R12

	VMOV R3, \B2
	VMOV R4, \B3

	K44_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV \C4, R7
	VMOV \C5, R8

	VMOV \C6, R9
	VMOV \C7, R10

	VMOV R3, \B4
	VMOV R4, \B5

	VMOV R9, \C8
	VMOV R10, \C9

	K44_C R3,R4,R5,R6, R9, R10, R11, R12

	VMOV \C8, R9
	VMOV \C9, R10
	VMOV \C10, R11
	VMOV \C11, R12

.ENDM

.MACRO K86_B A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13

	K66_B \A0, \A1, \A2, \A3, \A4, \A5, \B0, \B1, \B2, \B3, \B4, \B5, \C0, \C1, \C2, \C3, \C4, \C5, \C8, \C9, \C10, \C11, \C12, \C13

	K62_C \B0, \B1, \B2, \B3, \B4, \B5, \A6, \A7, \C6, \C7, \C8, \C9, \C10, \C11, \C12, \C13

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
.global fpmul434_asm
fpmul434_asm:

	PUSH {R3-R12,LR}

	VLDM R0!, {S0-S7}
	VLDM R1!, {S8-S15}

	K88_A S0, S1, S2, S3, S4, S5, S6, S7, S8, S9 , S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31

	VSTM R2!, {S16-S23}

	VPUSH {S0-S5}

	VLDM R0, {S0-S5} 

	K86_B S8, S9 ,S10, S11, S12, S13, S14, S15, S0, S1, S2, S3, S4, S5, S24, S25, S26, S27, S28, S29, S30, S31, S16, S17, S18, S19, S20, S21

	VPOP {S0-S5}

	VLDM R1, {S8-S13}

	VPUSH {S16-S21}

	K86_B S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S24, S25, S26, S27, S28, S29, S30, S31, S16, S17, S18, S19, S20, S21

	VSTM R2!, {S24-S31}

	VLDM R0, {S0-S5}

	VPOP {S22-S27}
	//    A0  A1  A2  A3  A4  A5  B0  B1   B2   B3   B4   B5   C0   C1   C2   C3   C4   C5   C6   C7   C8   C9  C10  C11
    //K66_C S0, S1, S2, S3, S4, S5, S8, S9, S10, S11, S12, S13, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27

	K44_B S0, S1, S2, S3, S8, S9, S10, S11, S16, S17, S18, S19,S22, S23, S24, S25

	VMOV R3, S0
	VMOV R4, S1

	VMOV R5, S12
	VMOV R6, S13

	VMOV R7, S22
	VMOV R8, S23
	VMOV R9, S20
	VMOV R10, S21

	K_C R3, R4, R5, R6, R7, R8, R9, R10

	VMOV R3, S2
	VMOV R4, S3

	VMOV R11, S24
	VMOV R12, S25

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV S26, R11
	VMOV S27, R12

	VMOV R5, S4
	VMOV R6, S5
	VMOV R3, S8
	VMOV R4, S9

	K_B R3, R4, R5, R6, R7, R8, R11, R12

	VMOV R3, S10
	VMOV R4, S11

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV S20, R7
	VMOV S21, R8
	VMOV S22, R9
	VMOV S23, R10

	VMOV R3, S12
	VMOV R4, S13

	VMOV R9, S26
	VMOV R10, S27

	K_C R3, R4, R5, R6, R9, R10, R11, R12

	VMOV S24, R9
	VMOV S25, R10
	VMOV S26, R11
	VMOV S27, R12

	VSTM R2!, {S16-S27}

	POP {R3-R12,LR}
	BX LR