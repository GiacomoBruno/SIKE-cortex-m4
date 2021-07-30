.syntax unified
.cpu cortex-m4
.text
    .thumb


.macro KARATSUBA_64 A0 A1 B0 B1 C0 C1 C2 C3
    
    mov \C2, #0
    mov \C3, #0
    umull \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0
    umlal \C1, \C3, \A0, \B1
    umaal \C2, \C3, \A1, \B1

.endm

.macro KARATSUBA_64_add_C0 A0 A1 B0 B1 C0 C1 C2 C3

    mov \C1, #0
    mov \C2, #0
    mov \C3, #0
    umlal \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0
    umlal \C1, \C3, \A0, \B1
    umaal \C2, \C3, \A1, \B1

.endm

.macro KARATSUBA_64_add_C0_C1 A0 A1 B0 B1 C0 C1 C2 C3

    mov \C2, #0
    mov \C3, #0
    umlal \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0
    umlal \C1, \C3, \A0, \B1
    umaal \C2, \C3, \A1, \B1

.endm

.macro KARATSUBA_64_add_C0_and_C1 A1 B0 B1 C0 C1 C2 C3

    mov \C2, #0
    mov \C3, #0
    umaal \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0
    umlal \C1, \C3, \A0, \B1
    umaal \C2, \C3, \A1, \B1

.endm

.macro KARATSUBA_48 A0 A1 B0 C0 C1 C2

    mov \C2, #0
    umull \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0

.endm

.macro KARATSUBA_48_add_C0 A0 A1 B0 C0 C1 C2

    mov \C1, #0
    mov \C2, #0
    umlal \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0

.endm

.macro KARATSUBA_48_add_C0_C1 A0 A1 B0 C0 C1 C2
    mov C2, #0
    umlal \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0
.endm

.macro KARATSUBA_48_add_C0_and_C1 A0 A1 B0 C0 C1 C2
    mov C2, #0
    umaal \C0, \C1, \A0, \B0
    umlal \C1, \C2, \A1, \B0
.endm

.macro KARATSUBA_96 A0 A1 A2, B0, B1, B2, C0, C1, C2, C3, C4, C5

    KARATSUBA_64 \A0, \A1, \B0, \B1, \C0, \C1, \C2, \C3

    KARATSUBA_48_add_C0_C1 \B0, \B1, \A2, \C2, \C3, \C4

    KARATSUBA_48_add_C0_C1 \A0, \A1, \B2, \C2, C3, \C5

    umaal \C4, \C5, \A2, \B2
    
.endm