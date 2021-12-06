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

void unit_test(void (*f)(const digit_t* a,const digit_t* b, digit_t* c, const unsigned int nwords), void (*asmf)(const digit_t* a,const digit_t* b, digit_t* c, const unsigned int nwords), const char* testname)
{
    felm_t a;
    felm_t b;
    dfelm_t c1;
    dfelm_t c2;
    unsigned int cycle1, cycle2, s_cycle, e_cycle;

    s_cycle = cpucycles();

    fprandom434_test(a);
    fprandom434_test(b);
    fprandom434_test(c1);
    fprandom434_test(c2);
    //for(int i = 0; i < NWORDS_FIELD*2; i++) c1[i] = 0;
    //for(int i = 0; i < NWORDS_FIELD*2; i++) c2[i] = 0;
    unsigned char output[200];

    //BUFFER CYCLES FOR MORE ACCURATE RESULTS
    s_cycle = cpucycles();
    f(a,b,c1,NWORDS_FIELD);
    e_cycle = cpucycles();

    s_cycle = 0;
    e_cycle = 0;

    s_cycle = cpucycles();
    f(a,b,c1,NWORDS_FIELD);
    e_cycle = cpucycles();

    cycle1 = e_cycle - s_cycle;

    s_cycle = cpucycles();
    asmf(a,b,c2,NWORDS_FIELD);
    e_cycle = cpucycles();
    cycle2 = e_cycle - s_cycle;


    if(compare_words(c1, c2, NWORDS_FIELD*2) != 0)
    {
        sprintf((char*)output, "Test <%s> failed!\n", testname);
        send_USART_str(output);

        for(int i = 0; i < NWORDS_FIELD*2; i++)
        {
            sprintf((char*)output, "\t%8x\t%8x", c1[i], c2[i]);
            send_USART_str(output);
        }
    }

    sprintf((char*)output, "Test <%s> completed: \nTimings: \n\tf1 = %5u cycles \n\tf2 = %5u cycles\n", testname, cycle1, cycle2);
    send_USART_str(output);

}

void rdc_mont_test(void (*f)(digit_t* ma, digit_t* mc), const char* testname)
{
    felm_t a;
    felm_t b;
    dfelm_t c1;
    unsigned int cycle, s_cycle, e_cycle;

    s_cycle = cpucycles();

    fprandom434_test(a);
    fprandom434_test(b);
    fprandom434_test(c1);

    //for(int i = 0; i < NWORDS_FIELD*2; i++) c1[i] = 0;
    //for(int i = 0; i < NWORDS_FIELD*2; i++) c2[i] = 0;
    unsigned char output[200];

    //BUFFER CYCLES FOR MORE ACCURATE RESULTS
    s_cycle = cpucycles();
    mp_mul(a,b,c1,NWORDS_FIELD);
    e_cycle = cpucycles();

    s_cycle = 0;
    e_cycle = 0;

    felm_t temp = {0};

    s_cycle = cpucycles();
    f(c1,temp);
    e_cycle = cpucycles();
    cycle = e_cycle - s_cycle;

    sprintf((char*)output, "Test <%s> completed: \nTimings: \n\trdc = %5u cycles\n", testname, cycle);
    send_USART_str(output);
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

    for(int i = 0; i < 10; i++){
        unit_test(mp_mul, mp_mul_asm, "TEST 434");
    }

    for(int i = 0; i < 10; i++)
    {
        rdc_mont_test(rdc_mont, "TEST RDC MONT");
    }



#if (TARGET == TARGET_ARM_CM4)
    signal_host();
#endif
    return 0;
}