/********************************************************************************************
* SIDH: an efficient supersingular isogeny cryptography library
*
* Abstract: portable modular arithmetic for P434
*********************************************************************************************/

#include "../P434_internal.h"
#include "../../internal.h"


// Global constants
extern const uint64_t p434[NWORDS64_FIELD];
extern const uint64_t p434p1[NWORDS64_FIELD]; 
extern const uint64_t p434x2[NWORDS64_FIELD];  
extern const uint64_t p434x4[NWORDS64_FIELD];


__inline void mp_sub434_p2(const digit_t* a, const digit_t* b, digit_t* c)
{ // Multiprecision subtraction with correction with 2*p, c = a-b+2p. 
    unsigned int i, borrow = 0;

    for (i = 0; i < NWORDS_FIELD; i++) {
        SUBC(borrow, a[i], b[i], borrow, c[i]); 
    }

    borrow = 0;
    for (i = 0; i < NWORDS_FIELD; i++) {
        ADDC(borrow, c[i], ((digit_t*)p434x2)[i], borrow, c[i]); 
    }
} 


__inline void mp_sub434_p4(const digit_t* a, const digit_t* b, digit_t* c)
{ // Multiprecision subtraction with correction with 4*p, c = a-b+4p. 
    unsigned int i, borrow = 0;

    for (i = 0; i < NWORDS_FIELD; i++) {
        SUBC(borrow, a[i], b[i], borrow, c[i]); 
    }

    borrow = 0;
    for (i = 0; i < NWORDS_FIELD; i++) {
        ADDC(borrow, c[i], ((digit_t*)p434x4)[i], borrow, c[i]); 
    }
} 


__inline void fpadd434(const digit_t* a, const digit_t* b, digit_t* c)
{ // Modular addition, c = a+b mod p434.
  // Inputs: a, b in [0, 2*p434-1] 
  // Output: c in [0, 2*p434-1] 
  fpadd434_asm(a, b, c);

} 

__inline void fpsub434(const digit_t* a, const digit_t* b, digit_t* c)
{ // Modular subtraction, c = a-b mod p434.
  // Inputs: a, b in [0, 2*p434-1] 
  // Output: c in [0, 2*p434-1] 

  fpsub434_asm(a, b, c);
  
}


__inline void fpneg434(digit_t* a)
{ // Modular negation, a = -a mod p434.
  // Input/output: a in [0, 2*p434-1] 
    fneg434_asm(a,a);

}


void fpdiv2_434(const digit_t* a, digit_t* c)
{ // Modular division by two, c = a/2 mod p434.
  // Input : a in [0, 2*p434-1] 
  // Output: c in [0, 2*p434-1] 
    
    unsigned int i, carry = 0;
    digit_t mask;
        
    mask = 0 - (digit_t)(a[0] & 1);    // If a is odd compute a+p434
    for (i = 0; i < NWORDS_FIELD; i++) {
        ADDC(carry, a[i], ((digit_t*)p434)[i] & mask, carry, c[i]); 
    }

    mp_shiftr1(c, NWORDS_FIELD);
} 


void fpcorrection434(digit_t* a)
{ // Modular correction to reduce field element a in [0, 2*p434-1] to [0, p434-1].
    //
    fpcorrection434_asm(a, a);

   //unsigned int i, borrow = 0;
   //digit_t mask;

   //for (i = 0; i < NWORDS_FIELD; i++) {
   //    SUBC(borrow, a[i], ((digit_t*)p434)[i], borrow, a[i]); 
   //}
   //mask = 0 - (digit_t)borrow;

   //borrow = 0;
   //for (i = 0; i < NWORDS_FIELD; i++) {
   //    ADDC(borrow, a[i], ((digit_t*)p434)[i] & mask, borrow, a[i]); 
   //}
   // a[0] = mask;
}

void digit_x_digit(const digit_t a, const digit_t b, digit_t *c)
{
    fp_umull_asm(a,b,c);
}


void _digit_x_digit(const digit_t a, const digit_t b, digit_t* c)
{ // Digit multiplication, digit * digit -> 2-digit result    

    register digit_t al, ah, bl, bh, temp;
    digit_t albl, albh, ahbl, ahbh, res1, res2, res3, carry;
    digit_t mask_low = (digit_t)(-1) >> (sizeof(digit_t)*4), mask_high = (digit_t)(-1) << (sizeof(digit_t)*4);

    al = a & mask_low;                        // Low part
    ah = a >> (sizeof(digit_t) * 4);          // High part
    bl = b & mask_low;
    bh = b >> (sizeof(digit_t) * 4);

    albl = al*bl;
    albh = al*bh;
    ahbl = ah*bl;
    ahbh = ah*bh;
    c[0] = albl & mask_low;                   // C00

    res1 = albl >> (sizeof(digit_t) * 4);
    res2 = ahbl & mask_low;
    res3 = albh & mask_low;  
    temp = res1 + res2 + res3;
    carry = temp >> (sizeof(digit_t) * 4);
    c[0] ^= temp << (sizeof(digit_t) * 4);    // C01   

    res1 = ahbl >> (sizeof(digit_t) * 4);
    res2 = albh >> (sizeof(digit_t) * 4);
    res3 = ahbh & mask_low;
    temp = res1 + res2 + res3 + carry;
    c[1] = temp & mask_low;                   // C10 
    carry = temp & mask_high; 
    c[1] ^= (ahbh & mask_high) + carry;       // C11
}


void mp_mul_kara_64(const digit_t* a, const digit_t* b, digit_t* c)
{
    fp_mul_64_asm(a,b,c);
}

void mp_mul_128_asm(const digit_t* a, const digit_t* b, digit_t* c)
{
    fp_mul_128_asm(a,b,c);
}

void mp_mul_256_asm(const digit_t* a, const digit_t* b, digit_t* c)
{
    digit_t a0b0[8];
    digit_t a0b1[8];
    digit_t a1b0[8];
    digit_t a1b1[8];
    unsigned int carry = 0;

    fp_mul_128_asm(a,b,a0b0);
    fp_mul_128_asm(a,&(b[4]), a0b1);
    fp_mul_128_asm(&(a[4]), b, a1b0);
    fp_mul_128_asm(&(a[4]), &(b[4]), a1b1);

    //a0b0[0-3] => c[0-3]
    c[0] = a0b0[0];
    c[1] = a0b0[1];
    c[2] = a0b0[2];
    c[3] = a0b0[3];

    //a0b1 + a1b0 => c[4-11]
    ADDC(carry, a0b1[0], a1b0[0], carry, c[4]   );
    ADDC(carry, a0b1[1], a1b0[1], carry, c[5]   );
    ADDC(carry, a0b1[2], a1b0[2], carry, c[6]   );
    ADDC(carry, a0b1[3], a1b0[3], carry, c[7]   );
    ADDC(carry, a0b1[4], a1b0[4], carry, c[8]   );
    ADDC(carry, a0b1[5], a1b0[5], carry, c[9]   );
    ADDC(carry, a0b1[6], a1b0[6], carry, c[10]  );
    ADDC(carry, a0b1[7], a1b0[7], carry, c[11]  );
    //bring carry to c[12]
    ADDC(carry, 0,0, carry, c[12]);

    //a0b0[4-7] + c[4-7] => c[4-7]
    ADDC(carry, c[4], a0b0[4], carry, c[4]   );
    ADDC(carry, c[5], a0b0[5], carry, c[5]   );
    ADDC(carry, c[6], a0b0[6], carry, c[6]   );
    ADDC(carry, c[7], a0b0[7], carry, c[7]   );
    //a1b1[0-3] + c[8-11] + carry = c[8-11]
    ADDC(carry, c[8] , a1b1[0], carry, c[8]   );
    ADDC(carry, c[9] , a1b1[1], carry, c[9]   );
    ADDC(carry, c[10], a1b1[2], carry, c[10]  );
    ADDC(carry, c[11], a1b1[3], carry, c[11]  );
    //a1b1[4-7] + carry=> c[8-11]
    ADDC(carry, 0,     a1b1[4], carry, c[12]);
    ADDC(carry, 0,     a1b1[5], carry, c[13]);
    ADDC(carry, 0,     a1b1[6], carry, c[14]);
    ADDC(carry, 0,     a1b1[7], carry, c[15]);

}

void mp_mul_512_asm(const digit_t* a, const digit_t* b, digit_t* c)
{
    digit_t a0b0[16];
    digit_t a0b1[16];
    digit_t a1b0[16];
    digit_t a1b1[16];
    unsigned int carry = 0;

    digit_t a1[8];

    a1[0] = a[8];
    a1[1] = a[9];
    a1[2] = a[10];
    a1[3] = a[11];
    a1[4] = a[12];
    a1[5] = a[13];
    a1[6] = 0;
    a1[7] = 0;

    digit_t b1[8];

    b1[0] = b[8];
    b1[1] = b[9];
    b1[2] = b[10];
    b1[3] = b[11];
    b1[4] = b[12];
    b1[5] = b[13];
    b1[6] = 0;
    b1[7] = 0;

    mp_mul_256_asm(a,b,a0b0);
    mp_mul_256_asm(a,b1, a0b1);
    mp_mul_256_asm(a1, b, a1b0);
    mp_mul_256_asm(a1, b1, a1b1);

    //a0b0[0-7] => c[0-7]

    c[0] = a0b0[0];
    c[1] = a0b0[1];
    c[2] = a0b0[2];
    c[3] = a0b0[3];
    c[4] = a0b0[4];
    c[5] = a0b0[5];
    c[6] = a0b0[6];
    c[7] = a0b0[7];

    //a0b1[0-15] + a1b0[0-15] => c[8-23]
    ADDC(carry, a0b1[0 ], a1b0[0 ], carry, c[8]);
    ADDC(carry, a0b1[1 ], a1b0[1 ], carry, c[9]);
    ADDC(carry, a0b1[2 ], a1b0[2 ], carry, c[10]);
    ADDC(carry, a0b1[3 ], a1b0[3 ], carry, c[11]);
    ADDC(carry, a0b1[4 ], a1b0[4 ], carry, c[12]);
    ADDC(carry, a0b1[5 ], a1b0[5 ], carry, c[13]);
    ADDC(carry, a0b1[6 ], a1b0[6 ], carry, c[14]);
    ADDC(carry, a0b1[7 ], a1b0[7 ], carry, c[15]);
    ADDC(carry, a0b1[8 ], a1b0[8 ], carry, c[16]);
    ADDC(carry, a0b1[9 ], a1b0[9 ], carry, c[17]);
    ADDC(carry, a0b1[10], a1b0[10], carry, c[18]);
    ADDC(carry, a0b1[11], a1b0[11], carry, c[19]);
    ADDC(carry, a0b1[12], a1b0[12], carry, c[20]);
    ADDC(carry, a0b1[13], a1b0[13], carry, c[21]);
    ADDC(carry, a0b1[14], a1b0[14], carry, c[22]);
    ADDC(carry, a0b1[15], a1b0[15], carry, c[23]);
    //bring carry to c[24]
    ADDC(carry, 0, 0, carry, c[24]);

    //a0b0[8-15] + c[8-15] => c[8-15]
    ADDC(carry, c[8 ], a0b0[8 ], carry, c[8 ]);
    ADDC(carry, c[9 ], a0b0[9 ], carry, c[9 ]);
    ADDC(carry, c[10], a0b0[10], carry, c[10]);
    ADDC(carry, c[11], a0b0[11], carry, c[11]);
    ADDC(carry, c[12], a0b0[12], carry, c[12]);
    ADDC(carry, c[13], a0b0[13], carry, c[13]);
    ADDC(carry, c[14], a0b0[14], carry, c[14]);
    ADDC(carry, c[15], a0b0[15], carry, c[15]);

    //a1b1[0-7] + c[16-23] + carry => c[16-23]
    ADDC(carry, a1b1[0], c[16], carry, c[16]);
    ADDC(carry, a1b1[1], c[17], carry, c[17]);
    ADDC(carry, a1b1[2], c[18], carry, c[18]);
    ADDC(carry, a1b1[3], c[19], carry, c[19]);
    ADDC(carry, a1b1[4], c[20], carry, c[20]);
    ADDC(carry, a1b1[5], c[21], carry, c[21]);
    ADDC(carry, a1b1[6], c[22], carry, c[22]);
    ADDC(carry, a1b1[7], c[23], carry, c[23]);

    //a1b1[8-15] + carry => c[24-32]
    ADDC(carry, a1b1[8 ], c[24], carry, c[24]);
    ADDC(carry, a1b1[9 ], c[25], carry, c[25]);
    ADDC(carry, a1b1[10], c[26], carry, c[26]);
    ADDC(carry, a1b1[11], c[27], carry, c[27]);

}

void mp_mul(const digit_t* a, const digit_t* b, digit_t* c, const unsigned int nwords)
{ // Multiprecision comba multiply, c = a*b, where lng(a) = lng(b) = nwords.   
    if(nwords == 14)
    {
        mp_mul_512_asm(a,b,c);
        return;
    }
    //return;
    unsigned int i, j;
    digit_t t = 0, u = 0, v = 0, UV[2];
    unsigned int carry = 0;
    
    for (i = 0; i < nwords; i++) {
        for (j = 0; j <= i; j++) {
            MUL(a[j], b[i-j], NULL, UV[0]); 
            ADDC(0, UV[0], v, carry, v);
            ADDC(carry, UV[1], u, carry, u);
            t += carry;
        }
        c[i] = v;
        v = u; 
        u = t;
        t = 0;
    }

    for (i = nwords; i < 2*nwords-1; i++) {
        for (j = i-nwords+1; j < nwords; j++) {
            MUL(a[j], b[i-j], UV+1, UV[0]); 
            ADDC(0, UV[0], v, carry, v); 
            ADDC(carry, UV[1], u, carry, u); 
            t += carry;
        }
        c[i] = v;
        v = u; 
        u = t;
        t = 0;
    }
    c[2*nwords-1] = v; 
}


void rdc_mont(digit_t* ma, digit_t* mc)
{ // Efficient Montgomery reduction using comba and exploiting the special form of the prime p434.
  // mc = ma*R^-1 mod p434x2, where R = 2^448.
  // If ma < 2^448*p434, the output mc is in the range [0, 2*p434-1].
  // ma is assumed to be in Montgomery representation.
    unsigned int i, j, carry, count = p434_ZERO_WORDS;
    digit_t UV[2], t = 0, u = 0, v = 0;

    for (i = 0; i < NWORDS_FIELD; i++) {
        mc[i] = 0;
    }

    for (i = 0; i < NWORDS_FIELD; i++) {
        for (j = 0; j < i; j++) {
            if (j < (i-p434_ZERO_WORDS+1)) { 
                MUL(mc[j], ((digit_t*)p434p1)[i-j], UV+1, UV[0]);
                ADDC(0, UV[0], v, carry, v); 
                ADDC(carry, UV[1], u, carry, u); 
                t += carry; 
            }
        }
        ADDC(0, v, ma[i], carry, v); 
        ADDC(carry, u, 0, carry, u); 
        t += carry; 
        mc[i] = v;
        v = u;
        u = t;
        t = 0;
    }    

    for (i = NWORDS_FIELD; i < 2*NWORDS_FIELD-1; i++) {
        if (count > 0) {
            count -= 1;
        }
        for (j = i-NWORDS_FIELD+1; j < NWORDS_FIELD; j++) {
            if (j < (NWORDS_FIELD-count)) { 
                MUL(mc[j], ((digit_t*)p434p1)[i-j], UV+1, UV[0]);
                ADDC(0, UV[0], v, carry, v); 
                ADDC(carry, UV[1], u, carry, u); 
                t += carry;
            }
        }
        ADDC(0, v, ma[i], carry, v); 
        ADDC(carry, u, 0, carry, u); 
        t += carry; 
        mc[i-NWORDS_FIELD] = v;
        v = u;
        u = t;
        t = 0;
    }
    ADDC(0, v, ma[2*NWORDS_FIELD-1], carry, v); 
    mc[NWORDS_FIELD-1] = v;
}