.syntax unified
.cpu cortex-m4
.text
    .thumb


.MACRO KARATSUBA6128 A0 A1 B0 B1 C0 C1 C2 C3
    
    MOV \C2, #0
    MOV \C3, #0
    UMULL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0
    UMLAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1

.ENDM

.MACRO KARATSUBA128_SUMC0C1 A0 A1 B0 B1 C0 C1 C2 C3

    MOV \C2, #0
    MOV \C3, #0

    UMLAL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0
    UMLAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1

.ENDM

.MACRO KARATSUBA128_C0C1_SUM_C2C3 A0 A1 B0 B1 C0 C1 C2 C3


    UMAAL \C0, \C1, \A0, \B0
    UMAAL \C1, \C2, \A1, \B0
    UMAAL \C1, \C3, \A0, \B1
    UMAAL \C2, \C3, \A1, \B1


.ENDM

.MACRO KARATSUBA48 A0 A1 B0 C0 C1 C2

    MOV \C2, #0
    UMULL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0

.ENDM

.MACRO KARATSUBA48_SUMC0C1 A0 A1 B0 C0 C1 C2

    MOV \C2, #0

    UMLAL \C0, \C1, \A0, \B0
    UMLAL \C1, \C2, \A1, \B0

.ENDM



.MACRO KARATSUBA96 A0 A1 A2 B0 B1 B2 C0 C1 C2 C3 C4 C5

    //A0 A1 * B0 B1

    VMOV R3, \A0
    VMOV R4, \A1
    VMOV R5, \B0
    VMOV R6, \B1

    KARATSUBA128 R3, R4, R5, R6, R8, R9, R10, R11
    VMOV \C0, R8
    VMOV \C1, R9

    VMOV R8, \A2
    VMOV R9, \B2
    KARATSUBA48_SUMC0C1 R5, R6, R8, R10, R11, R12

    KARATSUBA48_SUMC0C1 R3, R4, R9, R10, R11, R5

    UMAAL R12, R5, R8, R9

    VMOV \C2, R10
    VMOV \C3, R11
    VMOV \C4, R12
    VMOV \C5, R5

.ENDM

.MACRO KARATSUBA256 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7

    VMOV R3, \A0
    VMOV R4, \A1
    VMOV R5, \B0
    VMOV R6, \B1

    //A0 * B0
    KARATSUBA128 R3, R4, R5, R6, R7, R8, R9, R10

    VMOV \C0, R7
    VMOV \C1, R8

    
    VMOV R3, \A2
    VMOV R4, \A3
    //A1 * B0 + R9 R10
    KARATSUBA128_SUMC0C1 R3, R4, R5, R6, R9, R10, R7, R8
    
    VMOV R3, \A0
    VMOV R4, \A1
    VMOV R5, \B2
    VMOV R6, \B3
    //A0 * B1 + R9 R10
    KARATSUBA128_SUMC0C1 R3, R4, R5, R6, R9, R10, R11, R12

    VMOV \C2, R9
    VMOV \C3, R10


    VMOV R3, \A2
    VMOV R4, \A3
    //A1*B1 + R11 R12 + R7 R8
    KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R7, R11, R8, R12


    VMOV \C4, R7
    VMOV \C5, R11
    VMOV \C6, R8
    VMOV \C7, R12

.ENDM

.MACRO KARATSUBA256_SUMC0C1C2C3 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C5 C7
    VMOV R3, \A0
    VMOV R4, \A1
    VMOV R5, \B0
    VMOV R6, \B1

    //A0 * B0 + C0C1
    KARATSUBA128_SUMC0C1 R3, R4, R5, R6, R7, R8, R9, R10
    //STORE C0
    VMOV \C0, R7
    VMOV \C1, R8

    VMOV R7, \C2
    VMOV R8, \C3

    VMOV R3, \A2
    VMOV R4, \A3
    //A1*B0 + R9 R10
    KARATSUBA128_SUMC0C1 R3, R4, R5, R6, R9, R10, R11, R12

    VMOV R3, \A0
    VMOV R4, \A1
    VMOV R5, \B2
    VMOV R6, \B3
    //A0*B1 + R9 R10 + C2C3
    KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R7, R9, R8, R10
    
    //STORE C1
    VMOV \C2, R7
    VMOV \C3, R9

    VMOV R3, \A2
    VMOV R4, \A3

    //A1*B1 + R8 R10 + R7  R8
    KARATSUBA128_C0C1_SUM_C2C3 R3, R4, R5, R6, R11, R8, R12, R10

    //STORE C2 C3
    VMOV \C4, R11
    VMOV \C5, R8
    VMOV \C6, R12
    VMOV \C7, R10

.ENDM


.MACRO KARATSUBA448 A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13

    KARATSUBA256 A0 A1 A2 A3 B0 B1 B2 B3 C0 C1 C2 C3 C4 C5 C6 C7

    //aggiungere c4-c7 to a1*b0
    KARATSUBA256_SUMC0C1C2C3 A4 A5 A6 A7 B0 B1 B2 B3 C4 C5 C6 C7 C8 C9 C10 C11


.ENDM