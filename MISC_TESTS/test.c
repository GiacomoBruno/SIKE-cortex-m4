/********************************************************************************************
* SIDH: an efficient supersingular isogeny cryptography library
*
* Abstract: testing code for field arithmetic, elliptic curve and isogeny functions
*********************************************************************************************/

#include "../src/config.h"
#include "../src/P434/P434_internal.h"
#include "../src/internal.h"
#include "../tests/test_extras.h"
#include <stdio.h>
#include <stdarg.h>


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


void print_felm_t(felm_t n, const char *name)
{
    unsigned char output1[100];
    sprintf((char*)output1, "%s", name);
    send_USART_str(output1);
    for(int i = 0; i < NWORDS_FIELD; i++)
    {
        unsigned char output[100];
        sprintf((char*)output, "%x", n[i]);
        send_USART_str(output);
    }

    sprintf((char*)output1, "\n");
    send_USART_str(output1);
}

void print_digit_t_array(digit_t* n, int length, const char* name)
{
    unsigned char output1[100];
    sprintf((char*)output1, "%s", name);
    send_USART_str(output1);
    for(int i = 0; i < length; i++)
    {
        unsigned char output[100];
        sprintf((char*)output, "%x", n[i]);
        send_USART_str(output);
    }

    sprintf((char*)output1, "\n");
    send_USART_str(output1);
}

void default_a(felm_t a)
{
    /*a:
692506413
3631789060
1073719144
3657232683

738825850
1685346213
672509892
3679971748

955981918
346443432
609625491
2371477316
2428402499
100630

*/
    a[0]        =      692506413;
    a[1]        =      3631789060;
    a[2]        =      1073719144;
    a[3]        =      3657232683;
    a[4]        =      738825850;
    a[5]        =      1685346213;
    a[6]        =      672509892;
    a[7]        =      3679971748;
    a[8]        =      955981918;
    a[9]        =      346443432;
    a[10]       =      609625491;
    a[11]       =      2371477316;
    a[12]       =      2428402499;
    a[13]       =      100630;
}


void default_b(felm_t b)
{
    /*b:
2435372950
1376578983
1889495571
3528158780
1208970574
2493798091
3053015490
823158643
1421553377
3854360114
3537520496
1249366358
4271068164
64737*/

    b[0] = 2435372950;
    b[1] = 1376578983;
    b[2] = 1889495571;
    b[3] = 3528158780;
    b[4] = 1208970574;
    b[5] = 2493798091;
    b[6] = 3053015490;
    b[7] = 823158643;
    b[8] = 1421553377;
    b[9] = 3854360114;
    b[10] = 3537520496;
    b[11] = 1249366358;
    b[12] = 4271068164;
    b[13] = 64737;


}

void default_c(felm_t c)
{
    /*
2885545510
3180603157
645886178
3008698858
3386645481
2688087034
4065453692
1500630097
943733405
320716748
4024819499
987730411
279370091
111411
*/
    c[0]        =      0;
    c[1]        =      0;
    c[2]        =      0;
    c[3]        =      0;
    c[4]        =      0;
    c[5]        =      0;
    c[6]        =      0;
    c[7]        =      0;
    c[8]        =      0;
    c[9]        =      0;
    c[10]       =      0;
    c[11]       =      0;
    c[12]       =      0;
    c[13]       =      0;
}

/*


Bench 128 bit multiplication using standard algorithm:      1100 cycles


RESULT
83842f5e    83842f5e
4d0a56de    4d0a56de
3a303f01    3a303f01
94b61c8b    94b61c8b
383e8d4f    383e8d4f
cc8127d4    cc8127d4
48fafacc    48fafacc
b311b8ce    b311b8ce


Bench 128 bit multiplication using karatsuba algorithm:       199 cycles


RESULT


*/

bool fp_test()
{ // Tests for the field arithmetic
    bool OK = true;
    int n, passed;
    felm_t a, b, c, d, e, f, ma, mb, mc, md, me, mf;
    dfelm_t cc;
    default_a(a); default_b(b); default_c(c);
    digit_t uv[2];


    unsigned long long cycles, cycles1, cycles2;

    cycles1 = cpucycles();
    digit_x_digit(a[0],b[0], uv);
    cycles2 = cpucycles();

    cycles = (cycles2-cycles1);
/*
Bench 512 bit multiplication using standard algorithm:     11035 cycles


RESULT
[0]  83842f5e       83842f5e
[1]  4d0a56de       4d0a56de
[2]  3a303f01       3a303f01
[3]  94b61c8b       94b61c8b
[4]  35b97781       35b97781
[5]  ad2b00da       ad2b00da
[6]  9b767380       9b767380
[7]  9d09b7a5       9d09b7a5
[8]  59034406       59034406
[9]  52a0201c       52a0201c
[10] c1258b4f       c1258b4f
[11] 94e62e33       94e62e33
[12] e13ae8fc       e13ae8fc
[13] c71dd695       c71dd695
[14] 139a77fd       139a77fd-- error
[15] 8e0b93c7       8e0b93c7
[16] d676fdd7       d676fdd7
[17] 1e96721a       1e96721a
[18] 1769654d       1769654d
[19] 86fa3524       86fa3524
[20] 45ebbf7f       45ebbf7f
[21] c9429e92       c9429e92
[22] 441829a2       441829a2
[23] e3145cd7       e3145cd7


Bench 512 bit multiplication using karatsuba algorithm:      4849 cycles

83842f5e
4d0a56de
3a303f01
94b61c8b
35b97781
ad2b00da
9b767380
9d09b7a5
59034406
52a0201c
c1258b4f
94e62e33
e13ae8fc
c71dd695
139a77fd
8e0b93c7
d676fdd7
1e96721a
1769654d
86fa3524
45ebbf7f
c9429e92
441829a2
e3145cd7


Bench 512 bit multiplication using karatsuba algorithm:      4849 cycles


RESULT


*/

  // print_bench("Bench 512 bit multiplication using standard algorithm: ", cycles);
  // print_test("\n");

  // cycles1 = cpucycles();
  // mp_mul(a,b,cc,14);
  // cycles2 = cpucycles();

  // cycles = (cycles2-cycles1);

  // print_bench("Bench 512 bit multiplication using standard algorithm: ", cycles);
  // print_test("\n");
  // print_digit_t_array(cc,24, "RESULT");

  // default_a(a); default_b(b); default_c(c);
  // cycles1 = cpucycles();
  // mp_mul_512_asm(a,b,cc);
  // cycles2 = cpucycles();

  // cycles = (cycles2-cycles1);

  // print_bench("Bench 512 bit multiplication using karatsuba algorithm: ", cycles);
  // print_test("\n");

  // print_digit_t_array(cc,24, "RESULT");

    //print_digit_t_array(uv, 2, "uv");


    print_test("\n--------------------------------------------------------------------------------------------------------\n\n"); 
    print_test("Testing field arithmetic over GF(p434): \n\n"); 


    passed = 1;
    default_a(a); default_b(b); default_c(c);
    fprandom434_test(d); fprandom434_test(e); fprandom434_test(f); 
    mp_mul(a, b, c, NWORDS_FIELD);

    // Field addition over the prime p434
    passed = 1;
    for (n=0; n<TEST_LOOPS; n++)
    {
        //fprandom434_test(a); fprandom434_test(b); fprandom434_test(c); 
        default_a(a); default_b(b); default_c(c);
        fprandom434_test(d); fprandom434_test(e); fprandom434_test(f); 

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
        default_a(a); default_b(b); default_c(c);
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
        //fprandom434_test(a); fprandom434_test(b); fprandom434_test(c);  
        default_a(a); default_b(b); default_c(c);
        fprandom434_test(ma); fprandom434_test(mb); fprandom434_test(mc); fprandom434_test(md); fprandom434_test(me); fprandom434_test(mf); 

        to_mont(a, ma);
        fpcopy434(ma, mc);
        from_mont(mc, c);
        if (compare_words(a, c, NWORDS_FIELD)!=0) { passed=0; break; }

        to_mont(a, ma); to_mont(b, mb); to_mont(c, mc); 
        fpmul434_mont(ma, mb, md); 
        fpmul434_mont(md, mc, me);                          // e = (a*b)*c
        
        fpmul434_mont(mb, mc, md); 
        fpmul434_mont(md, ma, mf);                          // f = a*(b*c)


        from_mont(me, e);
        from_mont(mf, f);

 
        if (compare_words(e, f, NWORDS_FIELD)!=0) { passed=0; break; }

        to_mont(a, ma); to_mont(b, mb); to_mont(c, mc); 

        fpadd434(mb, mc, md); fpmul434_mont(ma, md, me);                               // e = a*(b+c)
        
        fpmul434_mont(ma, mb, md); 
        fpmul434_mont(ma, mc, mf); 

        mp_mul(ma, mb, cc, 14);
        print_digit_t_array(cc, 28, "CC");

        fpadd434(md, mf, mf);    // f = a*b+a*c
        from_mont(me, e);
        from_mont(mf, f);
/*
md          
947b4b9     7092b33
b440d68b    e599852f
ef0ce557    4dd341cf
450779d8    a78e10aa
165d1b7e    b273a073
ae6547a5    829bc605
9ce2ceee    91b97fdc
c1fe8dbc    1ac299f8
ca3253fc    f207c9f3
dcca3ac8    b3a4c62a
670a2412    9c1e23de
25d745b4    d27b0eaf
4db9bb13    ed638648
140b        20842
            

mf          
2e56ce4a    2e56ce4b
e105416f    e105416f
39665f00    39665f00
450606ce    280606ce
5d6cfccc    5b2e7347
6188ec8f    92e19b33
e49b925b    6061eed3
1cacf381    9e7213d8
82a146d0    ef9da6a6
3219dd80    593150c4
d01d5b3     d0409d2
49095c47    49095c47
6aadec60    6aadec60
1da4c       1da4c


////

CC
33b402b6    33b402b6         33b402b6   33b402b6
51b24632    51b24632         51b24632   51b24632
47e31986    47e31986         47e31986   47e31986
d3964f58    d3964f58         d3964f58   d3964f58
c99e2ba     c99e2ba          c99e2ba    c99e2ba
eb380c94    eb380c94         eb380c94   eb380c94
ecdabb57    ecdabb57         ecdabb57   ecdabb57
a003d321    a003d320--error  a003d320   a003d320    
c4924837    c4924837         c4924837   c4924837
84bab2cc    84bab2cc         84bab2cc   84bab2cc
3d101468    3d101467--error  3d101467   3d101467    
fad76498    fad76497--error  fad76497   fad76497    
2ea7e163    2ea7e163         2ea7e163   2ea7e163
eae777ef    eae777ef         eae777ef   eae777ef
7e7ada83    7e7ada83         7e7ada83   7e7ada83
e95a6b83    e95a6b83         e95a6b83   e95a6b83
47f47592    47f47592         47f47592   47f47592
126535bf    126535bf         126535bf   126535bf
6889c9d8    6889c9d8         6889c9d8   6889c9d8
6fc17eb2    6fc17eb2         6fc17eb2   6fc17eb2
fe5eaad9    fe5eaad9         fe5eaad9   fe5eaad9
c8adb77f    c8adb77f         c8adb77f   c8adb77f
d0ea3208    d0ea3208         d0ea3208   d0ea3208
c47f652f    c47f652f         c47f652f   c47f652f
aaf983d7    aaf983d7         aaf983d7   aaf983d7
9e144cc9    9e144cc9         9e144cc9   9e144cc9
40731f34    40731f34         40731f34   40731f34
0           0                0          0

CC
33b402b6
51b24632
47e31986
d3964f58
c99e2ba
eb380c94
ecdabb57
a003d320
c4924837
84bab2cc
3d101467
fad76497
2ea7e163
eae777ef
7e7ada83
e95a6b83
47f47592
126535bf
6889c9d8
6fc17eb2
fe5eaad9
c8adb77f
d0ea3208
c47f652f
aaf983d7
9e144cc9
40731f34
0

*/


        print_felm_t(e, "E");
        print_felm_t(f, "F");
        return false;
        if (compare_words(e, f, NWORDS_FIELD)!=0) { passed=0; break; }

        print_test("test2");

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
        
    //fprandom434_test(a); fprandom434_test(b); fprandom434_test(c);
    default_a(a); default_b(b); default_c(c);

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