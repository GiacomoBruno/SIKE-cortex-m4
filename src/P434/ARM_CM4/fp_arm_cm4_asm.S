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

.thumb_func
.global fp_mul_64_asm
fp_mul_64_asm:

	push {r4-r11}
	ldmia r0!, {r4-r5}
	ldmia r1!, {r6,r7}

	mov r10, #0
	mov r11, #0

	umull r8, r9, r4, r6
	umlal r9, r10, r5, r6
	umlal r9, r11, r4,r7
	umaal r10, r11, r5, r7



	stmia r2!, {r8-r11}
	pop {r4-r11}
	bx lr

//


.macro KARATSUBA_64 A0 A1 B0 B1 C0 C1 C2 C3
	mov \C2, #0
	mov \C3, #0

	umull \C0, \C1, \A0, \B0
	umlal \C1, \C2, \A1, \B0
	umlal \C1, \C3, \A0, \B1
	umaal \C2, \C3, \A1, \B1

.endm

.macro KARATSUBA_64_C A0 A1 B0 B1 C0 C1 C2 C3
	//C0 contains T0 (r9)
	//C2 contains T1 (r10)
	mov \C1, #0
	mov \C3, #0

	umlal \C0, \C1, \A0, \B0
	umaal \C1, \C2, \A1, \B0
	umlal \C1, \C3, \A0, \B1
	umaal \C2, \C3, \A1, \B1

.endm

.macro KARATSUBA_128 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7 T0 T1 T2 T3
//assume a0-t1 are FPU registers (sn)
//assume r3-r12 are free to use

	vmov r3, \A0	//A0
	vmov r4, \A1	//A1
	vmov r5, \B0	//B0
	vmov r6, \B1	//B1

	mov r9, #0
	mov r10, #0

	umull r7, r8, r3, r5
	umlal r8, r9, r4, r5
	umlal r8, r10, r3, r6
	umaal r9, r10, r4, r6

	vmov \C0, r7
	vmov \C1, r8

	vmov r3, \A2
	vmov r4, \A3

	mov r7, #0
	mov r8, #0
	umlal r9, r7, r3, r5
	umaal r7, r10, r4, r5
	umlal r7, r8, r3, r6
	umaal r10, r8, r4, r6

	vmov \T0, r10
	vmov \T1, r8

	vmov r3, \A0
	vmov r4, \A1
	vmov r5, \B2
	vmov r6, \B3

	mov r11, #0
	mov r12, #0
	umlal r9, r11, r3, r5
	umaal r11, r7, r4, r5
	umlal r11, r12, r3, r6
	umaal r7, r12, r4, r6

	vmov \T2, r7
	vmov \T3, r12
	
	vmov \C2, r9
	vmov \C3, r11

	vmov r3, \A2
	vmov r4, \A3
	vmov r5, \B2
	vmov r6, \B3

	mov r9, #0
	mov r10, #0
	
	umull r7, r8, r3, r5
	umlal r8, r9, r4, r5
	umlal r8, r10, r3, r6
	umaal r9, r10, r4, r6

	vmov r3, \T0
	vmov r4, \T1
	vmov r5, \T2
	vmov r6, \T3

	mov r12, #0
	adds r7 , r7, r3
	adcs r8, r8, r4
	adcs r9, r9, r12
	adcs r10, r10, r12

	adds r7, r7, r5
	adcs r8, r8, r6
	adcs r9, r9, r12
	adcs r10, r10, r12

	vmov \C4, r7
	vmov \C5, r8
	vmov \C6, r9
	vmov \C7, r10

.endm

.thumb_func
.global fp_mul_128_asm
fp_mul_128_asm:

	push {r3-r12, lr}
	vldm r0, {s0-s3}
	vldm r1, {s4-s7}

	KARATSUBA_128 s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10,s11, s12, s13, s14, s15, s16, s17, s18,s19

	vstm r2, {s8-s15}

	pop {r3-r12, lr}
	bx lr

.macro KARATSUBA_256

	//A0 * B0
	KARATSUBA_128 s0,s1,s2,s3, s8,s9,s10,s11, s16,s17,s18,s19, s20,s21,s22,s23, s28,s29,s30,s31

	//vstm r2!, {s16-s19}	//first 4 32bit result can already be saved
	vpush {s16-s19}

	//A1 * B0
	KARATSUBA_128 s4,s5,s6,s7, s8,s9,s10,s11, s16,s17,s18,s19, s24,s25,s26,s27, s28,s29,s30,s31
	
	//l(a1b0) + h(a0b0) | h(a1b0) = a1b0
		vmov r3, s16
		vmov r4, s17
		vmov r5, s18
		vmov r6, s19

		vmov r7, s20
		vmov r8, s21
		vmov r9, s22
		vmov r10, s23

		adds r3, r3, r7
		adcs r4, r4, r8
		adcs r5, r5, r9
		adcs r6, r6, r10

		vmov r7, s24
		vmov r8, s25
		vmov r9, s26
		vmov r10, s27

		adcs r7, #0
		adcs r8, #0
		adcs r9, #0
		adcs r10, #0

		vmov s24, r7
		vmov s25, r8
		vmov s26, r9
		vmov s27, r10

		vmov s16, r3
		vmov s17, r4
		vmov s18, r5
		vmov s19, r6
	//

	//A0 * B1
	KARATSUBA_128 s0,s1,s2,s3, s12,s13,s14,s15, s8,s9,s10,s11, s20,s21,s22,s23, s28,s29,s30,s31

	//l(a1b0) + a0b1 = a0b1, save l(a0b1) (c1)
		vmov r3, s8
		vmov r4, s9
		vmov r5, s10
		vmov r6, s11

		vmov r7, s16
		vmov r8, s17
		vmov r9, s18
		vmov r10, s19

		adds r3, r3, r7
		adcs r4, r4, r8
		adcs r5, r5, r9
		adcs r6, r6, r10

		vmov r7, s20
		vmov r8, s21

		adcs r7, #0
		adcs r8, #0

		vmov s20, r7
		vmov s21, r8

		//stmia r2!, {r3-r6}
		push {r3-r6}
	//

	//A1* B1
	KARATSUBA_128 s4,s5,s6,s7, s12,s13,s14,s15, s0,s1,s2,s3, s16,s17,s18,s19, s28,s29,s30,s31

	//h(a1b0) + h(a0b1) + a1b1
		vmov r3, s20
		vmov r4, s21
		vmov r5, s22
		vmov r6, s23

		vmov r7, s24
		vmov r8, s25
		vmov r9, s26
		vmov r10, s27

		adds r3, r3, r7
		adcs r4, r4, r8
		adcs r5, r5, r9
		adcs r6, r6, r10

		vmov r7, s16
		vmov r8, s17
		vmov r9, s18
		vmov r10, s19


		adcs r7, #0
		adcs r8, #0
		adcs r9, #0
		adcs r10, #0

		vmov s16, r7
		vmov s17, r8
		vmov s18, r9
		vmov s19, r10

		vmov r7, s0
		vmov r8, s1
		vmov r9, s2
		vmov r10, s3

		adds r3, r3, r7
		adcs r4, r4, r8
		adcs r5, r5, r9
		adcs r6, r6, r10

		vmov r7, s16
		vmov r8, s17
		vmov r9, s18
		vmov r10, s19

		adcs r7, #0
		adcs r8, #0
		adcs r9, #0
		adcs r10, #0

		//stmia r2!, {r3-r10}
		push {r3-r10}
	//

	vpop {s16-s31}

.endm
.thumb_func
.global fp_mul_256_asm
fp_mul_256_asm:
	push {r3-r12, lr}
	vldm r0, {s0-s7}
	vldm r1, {s8-s15}

	KARATSUBA_256

	vstm r2!, {s28-s31} //C0
	vstm r2!, {s24-s27}	//C1
	vstm r2!, {s16-s23} //C2-C3

	pop {r3-r12, lr}
	bx lr

.thumb_func
.global fp_mul_448_asm
fp_mul_448_asm:
	push {r3-r12, lr}
	//load A0 A1
	vldm r0, {s0-s7}
	vldm r1, {s8-s15}

	//CALCULATE A0 * B0
	KARATSUBA_256 

	//OUTPUT C0
	vstm r2!, {s28-s31}
	vstm r2!, {s24-s27}

	//SAVE C1
	vpush {s20-s23}
	vpush {s16-s19}

	//pushed 8 registers => total stack = 8

	mov r12, #0
	//LOAD A1
	vldr s0, [r0, #32]
	vldr s1, [r0, #36]
	vldr s2, [r0, #40]
	vldr s3, [r0, #44]
	vldr s4, [r0, #48]
	vldr s5, [r0, #52]
	vmov s6, r12
	vmov s7, r12

	//LOAD B0
	vldm r1!, {s8-s15}

	//CALCULATE A1 * B0
	KARATSUBA_256

	//ADD h(A0B0) to A1B0
	vmov r3, s28
	vmov r4, s29
	vmov r5, s30
	vmov r6, s31
	//TAKE l(h(A0B0))
	pop {r7-r10}
	//popped 4 registers => total stack = 4

	adds r3, r3, r7
	adcs r4, r4, r8
	adcs r5, r5, r9
	adcs r6, r6, r10

	//TAKE h(h(A0B0))
	pop {r7-r10}
	//popped 4 registers => total stack = 0

	vmov r11, s24
	vmov r12, s25

	adcs r7, r7, r11
	adcs r8, r8, r12

	vmov r11, s26
	vmov r12, s27

	adcs r9, r9, r11
	adcs r10, r10, r11

	//save h(A1B0) = C2
	vmov r11, s16
	adcs r11, r11, #0
	vmov s16, r11
	adcs r11, #0
	adcs r11, #0
	vmov s17, r11
	vmov r11, s18
	adcs r11, #0
	vmov s18, r11
	vmov r11, s19
	adcs r11, #0
	vmov s19, r11
	vpush {s16-s23}
	//save h(A0B0)+l(A1B0) = C1
	push {r3-r10}

	//pushed 16 registers => total stack = 16

	//LOAD A0 and B1
	vldm r0!, {s0-s7}
	vldm r1, {s8-s13}

	mov r12, #0
	vmov s15, r12
	vmov s14, r12

	//CALCULATE A0 * B1
	KARATSUBA_256


	//take l(C1)
	pop {r3-r6}

	vmov r7, s28
	vmov r8, s29
	vmov r9, s30
	vmov r10, s31

	adds r7, r7, r3
	adcs r8, r8, r4
	adcs r9, r9, r5
	adcs r10, r10, r6

	stm r2!, {r7-r10}

	vmov r7, s24
	vmov r8, s25
	vmov r9, s26
	vmov r10, s27

	//take h(C1)
	pop {r3-r6}

	adds r7, r7, r3
	adcs r8, r8, r4
	adcs r9, r9, r5
	//adcs r10, r10, r6
	mov r10, r6
	stm r2!, {r7-r10}


	//{s28-s31} //C0
	//{s24-s27}	//C1
	//{s16-s23} //C2-C3



	pop {r3-r10}




	pop {r3-r12, lr}
	bx lr







//REAL KARATSUBA 

//REAL KARATSUBA STUFF
.MACRO KARATSUBA96 A0 A1 B0 C0 C1 C2

    MOV \C2, #0
    UMULL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0

.ENDM

.MACRO KARATSUBA96_SUMC0C1 A0 A1 B0 C0 C1 C2

    MOV \C2, #0

    UMLAL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0

.ENDM

.MACRO KARATSUBA96_C0C1_SUM_C2 A0 A1 B0 C0 C1 C2

    UMLAL \C0, \C1, \A0, \B0
    UMAAL \C1, \C2, \A1, \B0

.ENDM

.MACRO KARATSUBA128 A0 A1 B0 B1 C0 C1 C2 C3
    
    MOV \C2, #0
    MOV \C3, #0
    UMULL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0
    UMLAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1

.ENDM

.MACRO KARATSUBA128_SUMC0C1 A0 A1 B0 B1 C0 C1 C2 C3

    MOV \C1, #0
    MOV \C3, #0

	//C0+(A0*B0)
	UMLAL \C0, \C1, \A0, \B0
	//C1+C2+(A1*B0)
	UMAAL \C1, \C2, \A1, \B0
	//C1+(A0*B1)
	UMLAL \C1, \C3, \A0, \B1
	//C2+C3+(A1*B1)
	UMAAL \C2, \C3, \A1, \B1

.ENDM

.MACRO KARATSUBA128_C0C1_SUM_C2C3 A0 A1 B0 B1 C0 C1 C2 C3
	//C0C1 = C0 | C2
	//C2C3 = C1 | C3

	//C0 + C1 + (A0*B0)
    UMAAL \C0, \C1, \A0, \B0
    //C1 + C2 + (A1*B0)
	UMAAL \C1, \C2, \A1, \B0
    //C1 + C3 + (A0*B1)
	UMAAL \C1, \C3, \A0, \B1
    //C2 + C3 + (A1*B1)
	UMAAL \C2, \C3, \A1, \B1


.ENDM

.MACRO KARATSUBA192 A0 A1 A2 B0 B1 B2 C0 C1 C2 C3 C4 C5

	KARATSUBA128 \A0, \A1, \B0, \B1, \C0, \C1, \C2, \C3

	KARATSUBA96_SUMC0C1 \B0, \B1, \A2, \C2, \C3, \C4

	KARATSUBA96_SUMC0C1 \A0, \A1, \B2, \C2, \C3, \C5

	UMAAL \C4, \C5, \A2, \B2 

.ENDM

.MACRO KARATSUBA256 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7

	//A0A1*B0B1
	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1
	KARATSUBA128 R3, R4, R5, R6, R7, R8, R9, R10
	VMOV \C0, R7
	VMOV \C1, R8
	
	VMOV R7, \A2
	VMOV R8, \A3

	//A2A3*B0B1 + R9R10
	KARATSUBA128_SUMC0C1 R7, R8, R5, R6, R9, R11, R10, R12


	VMOV R5, \B2
	VMOV R6, \B3
	//A0A1*B2B3 + R9R11
	KARATSUBA128_SUMC0C1 R3, R4, R5, R6, R9, R7, R11, R8 

	VMOV \C2, R9
	VMOV \C3, R7

	//A2A3*B2B13 + R9R10
	VMOV R3, \A2
	VMOV R4, \A3
	KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R10, R11, R12, R8

	VMOV \C4, R10
	VMOV \C5, R11
	VMOV \C6, R12
	VMOV \C7, R8


.ENDM

.MACRO KARATSUBA256_SUMC0C1C2C3 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7

	//A0A1*B0B1 + C0C1
	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	VMOV R7, \C0
	VMOV R9, \C1

	KARATSUBA128_SUMC0C1 		R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C0, R7
	VMOV \C1, R8

	//A2A3*B0B1 + C2C3 + K1
	VMOV R7, \A2
	VMOV R8, \A3
	VMOV R11, \C2
	VMOV R12, \C3


	KARATSUBA128_C0C1_SUM_C2C3 	R7, R8, R5, R6, R9, R11, R10, R12

	VMOV R5, \B2
	VMOV R6, \B3
	//A0A1*B2B3 + K1
	KARATSUBA128_SUMC0C1       	R3, R4, R5, R6, R9, R7, R11, R8
	VMOV \C2, R9
	VMOV \C3, R7

	VMOV R3, \A2
	VMOV R4, \A3

	//A2A3*B2B3 +K2+K3
	KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R10, R11, R12, R8

	VMOV \C4, R10
	VMOV \C5, R11
	VMOV \C6, R12
	VMOV \C7, R8

.ENDM

.MACRO KARATSUBA256_C0C1C2C3_SUM_C4C5C6C7 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7
	
	VMOV R3, \A0
    VMOV R4, \A1
    VMOV R5, \B0
    VMOV R6, \B1
	
	//COPY BOTH C0 
	VMOV R7, \C0
	VMOV R9, \C1
	VMOV R8, \C4
	VMOV R10, \C5
	// K0 = C0 C1 C2 C3
	// K1 = C4 C5 C6 C7

	//A0 * B0 + LOW(K0) + LOW(K1)
    KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R7, R8, R9, R10

	VMOV \C0, R7
	VMOV \C1, R8

	VMOV R7, \C2
	VMOV R8, \C3

	VMOV R3, \A2
	VMOV R4, \A3

	//A1 * B0 + R9|R10 + high(k0)
	KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R9, R7, R10, R8

	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B2
	VMOV R6, \B3

	VMOV R11, \C6
	VMOV R12, \C7

	//A0 * B1 + R9|R7 + HIGH(K1)
	KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R9, R11, R7, R12

	VMOV \C2, R9
	VMOV \C3, R11

	VMOV R3, \A2
	VMOV R4, \A3

	//A1 * B1 + R10|R8 + R7|R12
	KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R10, R7, R8, R12

	VMOV \C4, R10
	VMOV \C5, R7
	VMOV \C6, R8
	VMOV \C7, R12

.ENDM

.MACRO KARATSUBA_2X4_SUMC0C1C2C3 A0 A1 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5

	//A0A1*B0B1 + C0C1
	MOV R8, #0
    MOV R10, #0
	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	VMOV R7, \C0
	VMOV R9, \C1

	//C0+(A0*B0)
	UMLAL R7, R8, R3, R5
	//C1+C2+(A1*B0)
	UMAAL R8, R9, R4, R5
	//C1+(A0*B1)
	UMLAL R8, R10, R3, R6
	//C2+C3+(A1*B1)
	UMAAL R9, R10, R4, R6

	VMOV \C0, R7
	VMOV \C1, R8

	//A0A1*B2B3 + R9 | R10 + C2 | C4
	//C0C1 = C0 | C2
	//C2C3 = C1 | C3

	VMOV R5, \B2
	VMOV R6, \B3
	// R9 = \C0 = R9 
	// R7 = \C1 = \C2
	// R10 = \C2 = R10
	// R8 = \C3 = \C3
	VMOV R8, \C3
	VMOV R7, \C2


	//C0 + C1 + (A0*B0)
    UMAAL R7, R9, R3, R5
    //C1 + C2 + (A1*B0)
	UMAAL R8, R9, R4, R5
    //C1 + C3 + (A0*B1)
	UMAAL R8, R10, R3, R6
    //C2 + C3 + (A1*B1)
	UMAAL R9, R10, R4, R6

	VMOV \C2, R7
	VMOV \C3, R8
	VMOV \C4, R9
	VMOV \C5, R10

.ENDM

.MACRO KARATSUBA2X4_C0C1C2C3_SUM_C4C5 A0 A1 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5

	//A0A1*B0B1 + C0C1 + C4C5

	//C0C1 = C0 | C2
	//C2C3 = C1 | C3
	VMOV R3, \A0
	VMOV R4, \A1
	VMOV R5, \B0
	VMOV R6, \B1

	VMOV R7, \C0
	VMOV R8, \C4
	VMOV R9, \C1
	VMOV R10, \C5

	//C0 + C1 + (A0*B0)
    UMAAL R7, R8, R3, R5
    //C1 + C2 + (A1*B0)
	UMAAL R8, R9, R4, R5
    //C1 + C3 + (A0*B1)
	UMAAL R8, R10, R3, R6
    //C2 + C3 + (A1*B1)
	UMAAL R9, R10, R4, R6

	VMOV \C0, R7
	VMOV \C1, R8

	//A0A1*B2B3 + R9 | R10 + C2 | C4
	//C0C1 = C0 | C2
	//C2C3 = C1 | C3

	VMOV R5, \B2
	VMOV R6, \B3
	// R9 = \C0 = R9 
	// R7 = \C1 = \C2
	// R10 = \C2 = R10
	// R8 = \C3 = \C3
	VMOV R8, \C3
	VMOV R7, \C2


	//C0 + C1 + (A0*B0)
    UMAAL R7, R9, R3, R5
    //C1 + C2 + (A1*B0)
	UMAAL R8, R9, R4, R5
    //C1 + C3 + (A0*B1)
	UMAAL R8, R10, R3, R6
    //C2 + C3 + (A1*B1)
	UMAAL R9, R10, R4, R6

	VMOV \C2, R7
	VMOV \C3, R8
	VMOV \C4, R9
	VMOV \C5, R10

.ENDM

.MACRO KARATSUBA_8X6_SUMC0C1C2C3C4C5C6C7 A0 A1 A2 A3 A4 A5 B0 B1 B2 B3 B4 B5 B6 B7 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13

	//A0A1A2A3*B0B1B2B3 + C0C1C2C3
	KARATSUBA256_SUMC0C1C2C3 \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3,\C4, \C5, \C6, \C7

	//A0A1A2A3*B4B5B6B7 + C8C9C10C11 + C4C5C6C7
	KARATSUBA256_C0C1C2C3_SUM_C4C5C6C7 \A0, \A1, \A2, \A3, \B4, \B5, \B6, \B7, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11

	//A4A5*B0B1B2B3 + C4C5C6C7
	
	//a4a5*b0b1 + c4c5 => c4 c5 t0 t1

	vmov r3, \A4
	vmov r4, \A5
	vmov r5, \b0
	vmov r6, \b1

	mov r8, #0
	mov r10, #0

	vmov r7, \c4
	vmov r9, \c5
	umaal, r7, r8, r3, r5
	umaal r8, r9, r4, r5
	umlal r8, r10, r3, r6
	umaal r9, r10, r4, r6

	//a4a5*b2b3 + r9r10 + c6c7



	KARATSUBA_2X4_SUMC0C1C2C3 \A4, \A5, \B0, \B1, \B2, \B3, \C4, \C5, \C6, \C7, \C12, \C13

	//A4A5*B4B5B6B7B + C8C9C10C11 + C12C13
	KARATSUBA2X4_C0C1C2C3_SUM_C4C5 \A4, \A5, \B4, \B5, \B6, \B7, \C8, \C9, \C10, \C11, \C12, \C13

.ENDM

.MACRO KARATSUBA512 A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 B6 B7 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15

	KARATSUBA256 \A0, \A1, \A2, \A3, \B0, \B1, \B2, \B3, \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7

	KARATSUBA256_SUMC0C1C2C3 \A4, \A5, \A6, \A7, \B0, \B1, \B2, \B3, \C4, \C5, \C6, \C7, \C8, \C9, \C10, \C11

	KARATSUBA256_SUMC0C1C2C3 \A0, \A1, \A2, \A3, \B4, \B5, \B6, \B7, \C4, \C5, \C6, \C7,  \C12, \C13, \C14, \C15

	KARATSUBA256_C0C1C2C3_SUM_C4C5C6C7  \A4, \A5, \A6, \A7,\B4, \B5, \B6, \B7, \C8, \C9, \C10, \C11, \C12, \C13, \C14, \C15

.ENDM

.MACRO KARATSUBA986
	VLDM R0, {S0-S7}
	VLDM R1!, {S8-S15}
	KARATSUBA512 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31
	VSTM R2!, {S16-S23}

	//r0[14] r1[14]

	VLDR S0, [R0, #32]
	VLDR S1, [R0, #36]
	VLDR S2, [R0, #40]
	VLDR S3, [R0, #44]
	VLDR S4, [R0, #48]
	VLDR S5, [R0, #52]
	//a8 a9 a10 a11 a12 a13 * b0 b1 b2 b3 b4 b5 b6 b7
	//                                A0 A1 A2 A3 A4 A5 B0 B1  B2  B3  B4  B5  B6  B7  C0  C1  C2  C3  C4  C5  C6  C7  C8  C9 C10 C11 C12 C13
	KARATSUBA_8X6_SUMC0C1C2C3C4C5C6C7 S0 S1 S2 S3 S4 S5 S8 S9 S10 S11 S12 S13 S14 S15 S24 S25 S26 S27 S28 S29 S30 S31 S16 S17 S18 S19 S20 S21

	VLDM R0!, {S0-S7}
	VLDM R1, {S8-S13} 
	VPUSH {S20-S21}
	//                                A0 A1  A2  A3  A4  A5 B0 B1 B2 B3 B4 B5 B6 B7  C0  C1  C2  C3  C4  C5  C6  C7  C8  C9 C10 C11 C12 C13
	KARATSUBA_8X6_SUMC0C1C2C3C4C5C6C7 S8 S9 S10 S11 S12 S13 S0 S1 S2 S3 S4 S5 S6 S7 S24 S25 S26 S27 S28 S29 S30 S31 S14 S15 S20 S21 S22 S23

	VSTM R2!, {S24-S31}
	VPOP {S20-S21}

.ENDM


.thumb_func
.global fp_mul_192
fp_mul_192:

	push {r3-r12, lr}

	ldm r0!, {R3-R5}
	ldm r1!, {R10-R12}

	KARATSUBA192 R3, R4, R5, R10, R11, R12, R6, R7, R8, R9, R0, R1

	stm r2!, {R6-r9}
	stm r2!, {r0-r1}
	
	pop {r3-r12,lr}
	bx lr
//

.thumb_func
.global fp_mul_256
fp_mul_256:

	push {r3-r12, lr}

	vldm r0!, {s0-s3}
	vldm r1!, {s4-s7}

	KARATSUBA256 s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15

	vstm r2!, {s8-s15}
	
	pop {r3-r12,lr}
	bx lr

//

.thumb_func
.global fp_mul_512
fp_mul_512:
	PUSH {R3-R12, LR}

	VLDM R0, {S0-S7}
	VLDM R1, {S8-S15}

	KARATSUBA512 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31
	VSTM R2, {S16-S31}

	POP {R3-R12, LR}
	BX LR

//

.thumb_func
.global fp_mul_986
fp_mul_986:
	PUSH {R3-R12, LR}

	KARATSUBA986

	POP {R3-R12, LR}
	BX LR
//

.thumb_func
.global fp_KARATSUBA_8X6_SUMC0C1C2C3C4C5C6C7
fp_KARATSUBA_8X6_SUMC0C1C2C3C4C5C6C7:
	push {r3-r12, lr}
	vldm R0!, {S0-S5}
	vldm r1!, {S6-S13}
	//vldm r0!, {S14-S21}
	mov r12, #0
	vmov s14, r12
	vmov s15, r12
	vmov s16, r12
	vmov s17, r12
	vmov s18, r12
	vmov s19, r12
	vmov s20, r12
	vmov s21, r12
	//							      A0 A1 A2 A3 A4 A5 B0 B1 B2 B3  B4  B5  B6  B7  C0  C1  C2  C3  C4  C5  C6  C7  C8  C9 C10 C11 C12 C13
	KARATSUBA_8X6_SUMC0C1C2C3C4C5C6C7 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 s11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27
	
	vstm r2!,{s14-s27}

	pop {r3-r12, lr}
	bx lr

