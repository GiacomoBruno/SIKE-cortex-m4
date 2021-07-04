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
.global mul434_asm
mul434_asm:
	push {r3-r12,lr}
	
	vldm r0, {s0-s13}

//A divided in: A0 A1 A2 A3 A4 A5 A6
//AH+AL divided in: a0 a1 a2 a3

// s0, s1 <= a0 where a0 = A0 + A4
	vmov r4, s0
	vmov r5, s1
	vmov r6, s8
	vmov r7, s9

	adds r4, r4, r6
	adcs r5, r5, r7

	vmov s0, r4
	vmov s1, r5

// s2, s3 <= a1 where a1 = A1 + A5
	vmov r4, s2
	vmov r5, s3
	vmov r6, s10
	vmov r7, s11

	adcs r4, r4, r6
	adcs r5, r5, r7

	vmov s2, r4
	vmov s3, r5

// s4, s5 <= a2 where a2 = A2 + A6
	vmov r4, s4
	vmov r5, s5
	vmov r6, s12
	vmov r7, s13

	adcs r4, r4, r6
	adcs r5, r5, r7

	vmov s4, r4
	vmov s5, r5

// s6, s7 <= a3 where a3 = A3 + 0
	vmov r4, s6
	vmov r5, s7
	mov r9, #0x0

	adcs r4, r4, r9
	adcs r5, r5, r9

	vmov s6, r4
	vmov s7, r5
//

// SAVE MASK IN r9
	adc 	r9, r9, r9
	vldm 	r1, {s8-s15}
//

//B divided in: B0 B1 B2 B3 B4 B5 B6
//BH+BL divided in: b0 b1 b2 b3

// s8,  s9 <= b0 where b0 = B0 + B4
	vmov 	r4, s8
	vmov 	r5, s9
	vmov 	r6, s16
	vmov 	r7, s17

	adds 	r4, r4, r6
	adcs 	r5, r5, r7

	vmov 	s8, r4
	vmov 	s9, r5

// s10, s11 <= b1 where b1 = B1 + B5
	vmov 	r4, s10
	vmov 	r5, s11
	vmov 	r6, s18
	vmov 	r7, s19

	adcs 	r4, r4, r6
	adcs 	r5, r5, r7

	vmov 	s10, r4
	vmov 	s11, r5

// s12, s13 <= b2 where b2 = B2 + B6
	vmov 	r4, s12
	vmov 	r5, s13
	vmov 	r6, s20
	vmov 	r7, s21

	adcs 	r4, r4, r6
	adcs 	r5, r5, r7

	vmov 	s12, r4
	vmov 	s13, r5

// s14, s15 <= b3 where b3 = B3 + 0
	vmov 	r4, s14
	vmov 	r5, s15
	mov 	r3, #0x0

	adcs 	r4, r4, r3
	adcs 	r5, r5, r3

	vmov 	s14, r4
	vmov 	s15, r5

// SAVE MASK IN r8 then get -MASK
	adc 	r8, r3, r3

	sub 	r8, r3, r8
	sub 	r9, r3, r9
//

	
	pop	 {r3-r12,lr}
	bx lr