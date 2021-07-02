/********************************************************************************************
* SIDH: an efficient supersingular isogeny cryptography library
*
* Abstract: testing code for field arithmetic, elliptic curve and isogeny functions
*********************************************************************************************/

#include "../src/config.h"
#include "../src/P434/P434_internal.h"
#include "../src/internal.h"
#include "test_extras.h"
#include <stdio.h>


#if (TARGET == TARGET_ARM_CM4)
static unsigned int *DWT_CYCCNT = (unsigned int*)0xE0001004;
static unsigned int *DWT_CTRL = (unsigned int*)0xE0001000;
static unsigned int *SCB_DEMCR = (unsigned int*)0xE000EDFC;

// Benchmark and test parameters  
    #define BENCH_LOOPS            10       // Number of iterations per bench
    #define TEST_LOOPS             10       // Number of iterations per test
    #define SMALL_BENCH_LOOPS      10

#define cpucycles() (*DWT_CYCCNT);

#else  
#if defined(GENERIC_IMPLEMENTATION) || (TARGET == TARGET_ARM) || (TARGET == TARGET_ARM_CM4)
    #define BENCH_LOOPS           100       // Number of iterations per bench
    #define SMALL_BENCH_LOOPS     100       // Number of iterations per bench
    #define TEST_LOOPS             10       // Number of iterations per test
#else
    #define BENCH_LOOPS        100000
    #define SMALL_BENCH_LOOPS   10000       
    #define TEST_LOOPS            100   
#endif
#endif


static void print_test(const char *text)
{
#if (TARGET == TARGET_ARM_CM4)
    unsigned char output[100];

    sprintf((char*)output, "%s", text);
    send_USART_str(output);
#else    
    printf("%s \n", text);
#endif
}


#if (TARGET == TARGET_ARM_CM4)
static void print_bench(const char *s, unsigned int cycles)
{
  unsigned char output[100];

  sprintf((char*)output, "%s %8u cycles", s, cycles);
  send_USART_str(output);
}
#else

static void print_bench(const char *s, unsigned long long cycles)
{
  printf("%s %8llu cycles \n", s, cycles);
}
#endif


bool fp_test()
{ // Tests for the field arithmetic
    bool OK = true;
    int n, passed;
    felm_t a, b, c, d, e, f, ma, mb, mc, md, me, mf;

    print_test("\n--------------------------------------------------------------------------------------------------------\n\n"); 
    print_test("Testing field arithmetic over GF(p434): \n\n"); 

    // Field addition over the prime p434
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fprandom434_test(a); fprandom434_test(b); fprandom434_test(c); fprandom434_test(d); fprandom434_test(e); fprandom434_test(f); 

        fpadd434(a, b, d); fpadd434(d, c, e);                 // e = (a+b)+c
        fpadd434(b, c, d); fpadd434(d, a, f);                 // f = a+(b+c)
        fpcorrection434(e);
        fpcorrection434(f);
        if (compare_words(e, f, NWORDS_FIELD)!=0) { passed=0; break; }

        fpadd434(a, b, d);                                     // d = a+b 
        fpadd434(b, a, e);                                     // e = b+a
        fpcorrection434(d);
        fpcorrection434(e);
        if (compare_words(d, e, NWORDS_FIELD)!=0) { passed=0; break; }

        fpzero434(b);
        fpadd434(a, b, d);                                     // d = a+0 
        if (compare_words(a, d, NWORDS_FIELD)!=0) { passed=0; break; }
        
        fpzero434(b);
        fpcopy434(a, d);     
        fpneg434(d);                      
        fpadd434(a, d, e);                                     // e = a+(-a)
        fpcorrection434(e);
        if (compare_words(e, b, NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p) addition tests ............................................ PASSED");
    else { print_test("  GF(p) addition tests... FAILED"); print_test("\n"); return false; }


    // Field subtraction over the prime p434
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fprandom434_test(a); fprandom434_test(b); fprandom434_test(c); fprandom434_test(d); fprandom434_test(e); fprandom434_test(f); 

        fpsub434(a, b, d); fpsub434(d, c, e);                 // e = (a-b)-c
        fpadd434(b, c, d); fpsub434(a, d, f);                 // f = a-(b+c)
        fpcorrection434(e);
        fpcorrection434(f);
        if (compare_words(e, f, NWORDS_FIELD)!=0) { passed=0; break; }

        fpsub434(a, b, d);                                     // d = a-b 
        fpsub434(b, a, e);                                         
        fpneg434(e);                                           // e = -(b-a)
        fpcorrection434(d);
        fpcorrection434(e);
        if (compare_words(d, e, NWORDS_FIELD)!=0) { passed=0; break; }

        fpzero434(b);
        fpsub434(a, b, d);                                     // d = a-0 
        if (compare_words(a, d, NWORDS_FIELD)!=0) { passed=0; break; }
        
        fpzero434(b);
        fpcopy434(a, d);                 
        fpsub434(a, d, e);                                     // e = a+(-a)
        fpcorrection434(e);
        if (compare_words(e, b, NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p) subtraction tests ......................................... PASSED");
    else { print_test("  GF(p) subtraction tests... FAILED"); print_test("\n"); return false; }
    
    // Field multiplication over the prime p434
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {    
        fprandom434_test(a); fprandom434_test(b); fprandom434_test(c);  
        fprandom434_test(ma); fprandom434_test(mb); fprandom434_test(mc); fprandom434_test(md); fprandom434_test(me); fprandom434_test(mf); 

        to_mont(a, ma);
        fpcopy434(ma, mc);
        from_mont(mc, c);
        if (compare_words(a, c, NWORDS_FIELD)!=0) { passed=0; break; }
        
        to_mont(a, ma); to_mont(b, mb); to_mont(c, mc); 
        fpmul434_mont(ma, mb, md); fpmul434_mont(md, mc, me);                          // e = (a*b)*c
        fpmul434_mont(mb, mc, md); fpmul434_mont(md, ma, mf);                          // f = a*(b*c)
        from_mont(me, e);
        from_mont(mf, f);
        if (compare_words(e, f, NWORDS_FIELD)!=0) { passed=0; break; }
      
        to_mont(a, ma); to_mont(b, mb); to_mont(c, mc); 
        fpadd434(mb, mc, md); fpmul434_mont(ma, md, me);                               // e = a*(b+c)
        fpmul434_mont(ma, mb, md); fpmul434_mont(ma, mc, mf); fpadd434(md, mf, mf);    // f = a*b+a*c
        from_mont(me, e);
        from_mont(mf, f);
        if (compare_words(e, f, NWORDS_FIELD)!=0) { passed=0; break; }
       
        to_mont(a, ma); to_mont(b, mb);
        fpmul434_mont(ma, mb, md);                                                      // d = a*b 
        fpmul434_mont(mb, ma, me);                                                      // e = b*a 
        from_mont(md, d);
        from_mont(me, e);
        if (compare_words(d, e, NWORDS_FIELD)!=0) { passed=0; break; }
        
        to_mont(a, ma);
        fpzero434(b); b[0] = 1; to_mont(b, mb);
        fpmul434_mont(ma, mb, md);                                                      // d = a*1  
        from_mont(ma, a);
        from_mont(md, d);                
        if (compare_words(a, d, NWORDS_FIELD)!=0) { passed=0; break; }
        
        fpzero434(b); to_mont(b, mb);
        fpmul434_mont(ma, mb, md);                                                      // d = a*0  
        from_mont(mb, b);
        from_mont(md, d);                
        if (compare_words(b, d, NWORDS_FIELD)!=0) { passed=0; break; } 
    }
    if (passed==1) print_test("  GF(p) multiplication tests ...................................... PASSED");
    else { print_test("  GF(p) multiplication tests... FAILED"); print_test("\n"); return false; }

    // Field squaring over the prime p434
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fprandom434_test(a);
        
        to_mont(a, ma);
        fpsqr434_mont(ma, mb);                                 // b = a^2
        fpmul434_mont(ma, ma, mc);                             // c = a*a 
        if (compare_words(mb, mc, NWORDS_FIELD)!=0) { passed=0; break; }

        fpzero434(a); to_mont(a, ma);
        fpsqr434_mont(ma, md);                                 // d = 0^2 
        if (compare_words(ma, md, NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p) squaring tests............................................. PASSED");
    else { print_test("  GF(p) squaring tests... FAILED"); print_test("\n"); return false; }
    
    // Field inversion over the prime p434
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fprandom434_test(a); 
        to_mont(a, ma);
        fpzero434(d); d[0]=1; to_mont(d, md);
        fpcopy434(ma, mb);                            
        fpinv434_mont(ma);                                
        fpmul434_mont(ma, mb, mc);                             // c = a*a^-1 
        if (compare_words(mc, md, NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p) inversion tests............................................ PASSED");
    else { print_test("  GF(p) inversion tests... FAILED"); print_test("\n"); return false; }
    
    return OK;
}


bool fp2_test()
{ // Tests for the quadratic extension field arithmetic
    bool OK = true;
    int n, passed;
    f2elm_t a, b, c, d, e, f, ma, mb, mc, md, me, mf;

    print_test("\n--------------------------------------------------------------------------------------------------------\n\n"); 
    print_test("Testing quadratic extension arithmetic over GF(p434^2): \n\n"); 

    // Addition over GF(p434^2)
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fp2random434_test((digit_t*)a); fp2random434_test((digit_t*)b); fp2random434_test((digit_t*)c); fp2random434_test((digit_t*)d); fp2random434_test((digit_t*)e); fp2random434_test((digit_t*)f); 

        fp2add434(a, b, d); fp2add434(d, c, e);                 // e = (a+b)+c
        fp2add434(b, c, d); fp2add434(d, a, f);                 // f = a+(b+c)
        if (compare_words((digit_t*)e, (digit_t*)f, 2*NWORDS_FIELD)!=0) { passed=0; break; }

        fp2add434(a, b, d);                                     // d = a+b 
        fp2add434(b, a, e);                                     // e = b+a
        if (compare_words((digit_t*)d, (digit_t*)e, 2*NWORDS_FIELD)!=0) { passed=0; break; }

        fp2zero434(b);
        fp2add434(a, b, d);                                     // d = a+0 
        if (compare_words((digit_t*)a, (digit_t*)d, 2*NWORDS_FIELD)!=0) { passed=0; break; }
        
        fp2zero434(b);
        fp2copy434(a, d);     
        fp2neg434(d);                      
        fp2add434(a, d, e);                                     // e = a+(-a)
        if (compare_words((digit_t*)e, (digit_t*)b, 2*NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p^2) addition tests .......................................... PASSED");
    else { print_test("  GF(p^2) addition tests... FAILED"); print_test("\n"); return false; }

    // Subtraction over GF(p434^2)
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fp2random434_test((digit_t*)a); fp2random434_test((digit_t*)b); fp2random434_test((digit_t*)c); fp2random434_test((digit_t*)d); fp2random434_test((digit_t*)e); fp2random434_test((digit_t*)f); 

        fp2sub434(a, b, d); fp2sub434(d, c, e);                 // e = (a-b)-c
        fp2add434(b, c, d); fp2sub434(a, d, f);                 // f = a-(b+c)
        if (compare_words((digit_t*)e, (digit_t*)f, 2*NWORDS_FIELD)!=0) { passed=0; break; }

        fp2sub434(a, b, d);                                     // d = a-b 
        fp2sub434(b, a, e);                                         
        fp2neg434(e);                                           // e = -(b-a)
        if (compare_words((digit_t*)d, (digit_t*)e, 2*NWORDS_FIELD)!=0) { passed=0; break; }

        fp2zero434(b);
        fp2sub434(a, b, d);                                     // d = a-0 
        if (compare_words((digit_t*)a, (digit_t*)d, 2*NWORDS_FIELD)!=0) { passed=0; break; }
        
        fp2zero434(b);
        fp2copy434(a, d);                 
        fp2sub434(a, d, e);                                     // e = a+(-a)
        if (compare_words((digit_t*)e, (digit_t*)b, 2*NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p^2) subtraction tests ....................................... PASSED");
    else { print_test("  GF(p^2) subtraction tests... FAILED"); print_test("\n"); return false; }

    // Multiplication over GF(p434^2)
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {    
        fp2random434_test((digit_t*)a); fp2random434_test((digit_t*)b); fp2random434_test((digit_t*)c);  
        fp2random434_test((digit_t*)ma); fp2random434_test((digit_t*)mb); fp2random434_test((digit_t*)mc); fp2random434_test((digit_t*)md); fp2random434_test((digit_t*)me); fp2random434_test((digit_t*)mf); 

        to_fp2mont(a, ma);
        fp2copy434(ma, mc);
        from_fp2mont(mc, c);
        if (compare_words((digit_t*)a, (digit_t*)c, 2*NWORDS_FIELD)!=0) { passed=0; break; }
        
        to_fp2mont(a, ma); to_fp2mont(b, mb); to_fp2mont(c, mc); 
        fp2mul434_mont(ma, mb, md); fp2mul434_mont(md, mc, me);                          // e = (a*b)*c
        fp2mul434_mont(mb, mc, md); fp2mul434_mont(md, ma, mf);                          // f = a*(b*c)
        from_fp2mont(me, e);
        from_fp2mont(mf, f);
        if (compare_words((digit_t*)e, (digit_t*)f, 2*NWORDS_FIELD)!=0) { passed=0; break; }
      
        to_fp2mont(a, ma); to_fp2mont(b, mb); to_fp2mont(c, mc); 
        fp2add434(mb, mc, md); fp2mul434_mont(ma, md, me);                               // e = a*(b+c)
        fp2mul434_mont(ma, mb, md); fp2mul434_mont(ma, mc, mf); fp2add434(md, mf, mf);   // f = a*b+a*c
        from_fp2mont(me, e);
        from_fp2mont(mf, f);
        if (compare_words((digit_t*)e, (digit_t*)f, 2*NWORDS_FIELD)!=0) { passed=0; break; }
       
        to_fp2mont(a, ma); to_fp2mont(b, mb);
        fp2mul434_mont(ma, mb, md);                                                      // d = a*b 
        fp2mul434_mont(mb, ma, me);                                                      // e = b*a 
        from_fp2mont(md, d);
        from_fp2mont(me, e);
        if (compare_words((digit_t*)d, (digit_t*)e, 2*NWORDS_FIELD)!=0) { passed=0; break; }
        
        to_fp2mont(a, ma);
        fp2zero434(b); b[0][0] = 1; to_fp2mont(b, mb);
        fp2mul434_mont(ma, mb, md);                                                      // d = a*1  
        from_fp2mont(md, d);               
        if (compare_words((digit_t*)a, (digit_t*)d, 2*NWORDS_FIELD)!=0) { passed=0; break; }
        
        fp2zero434(b); to_fp2mont(b, mb);
        fp2mul434_mont(ma, mb, md);                                                      // d = a*0 
        from_fp2mont(md, d);               
        if (compare_words((digit_t*)b, (digit_t*)d, 2*NWORDS_FIELD)!=0) { passed=0; break; } 
    }
    if (passed==1) print_test("  GF(p^2) multiplication tests .................................... PASSED");
    else { print_test("  GF(p^2) multiplication tests... FAILED"); print_test("\n"); return false; }

    // Squaring over GF(p434^2)
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fp2random434_test((digit_t*)a);
        
        to_fp2mont(a, ma);
        fp2sqr434_mont(ma, mb);                                 // b = a^2
        fp2mul434_mont(ma, ma, mc);                             // c = a*a 
        from_fp2mont(mb, b);               
        from_fp2mont(mc, c);               
        if (compare_words((digit_t*)b, (digit_t*)c, 2*NWORDS_FIELD)!=0) { passed=0; break; }

        fp2zero434(a); to_fp2mont(a, ma);
        fp2sqr434_mont(ma, md);                                 // d = 0^2 
        from_fp2mont(md, d);               
        if (compare_words((digit_t*)a, (digit_t*)d, 2*NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p^2) squaring tests........................................... PASSED");
    else { print_test("  GF(p^2) squaring tests... FAILED"); print_test("\n"); return false; }
    
    // Inversion over GF(p434^2)
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        fp2random434_test((digit_t*)a);    
        
        to_fp2mont(a, ma);
        fp2zero434(d); d[0][0]=1; to_fp2mont(d, md);
        fp2copy434(ma, mb);                            
        fp2inv434_mont(ma);                                
        fp2mul434_mont(ma, mb, mc);                             // c = a*a^-1              
        from_fp2mont(mc, c);  
        if (compare_words((digit_t*)c, (digit_t*)d, 2*NWORDS_FIELD)!=0) { passed=0; break; }
    }
    if (passed==1) print_test("  GF(p^2) inversion tests.......................................... PASSED");
    else { print_test("  GF(p^2) inversion tests... FAILED"); print_test("\n"); return false; }
    
    return OK;
}


bool fp_run()
{
    bool OK = true;
    int n;
    unsigned long long cycles, cycles1, cycles2;
    felm_t a, b, c;
    dfelm_t aa;
        
    print_test("\n--------------------------------------------------------------------------------------------------------\n\n"); 
    print_test("Benchmarking field arithmetic over GF(p434): \n\n"); 
        
    fprandom434_test(a); fprandom434_test(b); fprandom434_test(c);

    // GF(p) addition using p434
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fpadd434(a, b, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p) addition runs in .......................................... ", cycles/BENCH_LOOPS); print_unit;
    print_test("\n");

    // GF(p) subtraction using p434
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fpsub434(a, b, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p) subtraction runs in ....................................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p) multiplication using p434
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fpmul434_mont(a, b, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p) multiplication runs in .................................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p) reduction using p434
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        mp_mul(a, b, aa, NWORDS_FIELD);

        cycles1 = cpucycles(); 
        rdc_mont(aa, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p) reduction runs in ......................................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p) inversion
    cycles = 0;
    for (n=0; n<SMALL_BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fpinv434_mont(a);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p) inversion (exponentiation) runs in ........................ ", cycles/SMALL_BENCH_LOOPS);
    print_test("\n"); 
    
    return OK;
}


bool fp2_run()
{
    bool OK = true;
    int n;
    unsigned long long cycles, cycles1, cycles2;
    f2elm_t a, b, c;
        
    print_test("\n--------------------------------------------------------------------------------------------------------\n\n"); 
    print_test("Benchmarking quadratic extension arithmetic over GF(p434^2): \n\n"); 
    
    fp2random434_test((digit_t*)a); fp2random434_test((digit_t*)b); fp2random434_test((digit_t*)c);

    // GF(p^2) addition
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fp2add434(a, b, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p^2) addition runs in ........................................ ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p^2) subtraction
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fp2sub434(a, b, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p^2) subtraction runs in ..................................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p^2) multiplication
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fp2mul434_mont(a, b, c);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p^2) multiplication runs in .................................. ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p^2) squaring
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fp2sqr434_mont(a, b);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p^2) squaring runs in ........................................ ", cycles/BENCH_LOOPS);
    print_test("\n");

    // GF(p^2) inversion
    cycles = 0;
    for (n=0; n<SMALL_BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        fp2inv434_mont(a);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  GF(p^2) inversion (exponentiation) runs in ...................... ", cycles/SMALL_BENCH_LOOPS);
    print_test("\n");
    
    return OK;
}


bool ecisog_run()
{
    bool OK = true;
    int n;
    unsigned long long cycles, cycles1, cycles2;
    f2elm_t A24, C24, A4, A, C, coeff[5];
    point_proj_t P, Q;
        
    print_test("\n--------------------------------------------------------------------------------------------------------\n\n"); 
    print_test("Benchmarking elliptic curve and isogeny functions: \n\n"); 

    // Point doubling
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        fp2random434_test((digit_t*)A24); fp2random434_test((digit_t*)C24);

        cycles1 = cpucycles(); 
        xDBL(P, Q, A24, C24);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  Point doubling runs in .......................................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // 4-isogeny of a projective point
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        fp2random434_test((digit_t*)A); fp2random434_test((digit_t*)coeff[0]); fp2random434_test((digit_t*)coeff[1]); fp2random434_test((digit_t*)coeff[2]);

        cycles1 = cpucycles(); 
        get_4_isog(P, A, C, coeff);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  4-isogeny of projective point runs in ........................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // 4-isogeny evaluation at projective point
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        fp2random434_test((digit_t*)A); fp2random434_test((digit_t*)coeff[0]); fp2random434_test((digit_t*)coeff[1]); fp2random434_test((digit_t*)coeff[2]);

        cycles1 = cpucycles(); 
        eval_4_isog(P, coeff);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  4-isogeny evaluation at projective point runs in ................ ", cycles/BENCH_LOOPS);
    print_test("\n");

    // Point tripling
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        fp2random434_test((digit_t*)A4); fp2random434_test((digit_t*)C);

        cycles1 = cpucycles(); 
        xTPL(P, Q, A4, C);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  Point tripling runs in .......................................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // 3-isogeny of a projective point
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        fp2random434_test((digit_t*)A); fp2random434_test((digit_t*)C);

        cycles1 = cpucycles(); 
        get_3_isog(P, A, C, coeff);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  3-isogeny of projective point runs in ........................... ", cycles/BENCH_LOOPS);
    print_test("\n");

    // 3-isogeny evaluation at projective point
    cycles = 0;
    for (n=0; n<BENCH_LOOPS; n++)
    {
        cycles1 = cpucycles(); 
        eval_3_isog(Q, coeff);
        cycles2 = cpucycles();
        cycles = cycles+(cycles2-cycles1);
    }
    print_bench("  3-isogeny evaluation at projective point runs in ................ ", cycles/BENCH_LOOPS);
    print_test("\n");
    
    return OK;
}


int main()
{
#if (TARGET == TARGET_ARM_CM4)
    clock_setup();
    gpio_setup();
    usart_setup(115200);
    rng_setup();

    *SCB_DEMCR = *SCB_DEMCR | 0x01000000;
    *DWT_CYCCNT = 0;               // reset the counter
    *DWT_CTRL = *DWT_CTRL | 1 ;    // enable the counter
#endif
    bool OK = true;

    OK = OK && fp_test();          // Test field operations using p434

    OK = OK && fp_run();           // Benchmark field operations using p434

    OK = OK && fp2_test();         // Test arithmetic functions over GF(p434^2)

    OK = OK && fp2_run();          // Benchmark arithmetic functions over GF(p434^2)

    OK = OK && ecisog_run();       // Benchmark elliptic curve and isogeny functions
#if (TARGET == TARGET_ARM_CM4)
    signal_host();
#endif
    return OK;
}