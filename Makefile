####  Makefile for compilation using GNU GCC on ARM-based Cortex-M4 microcontroller  ####

OPT=-Ofast     # Optimization option by default

USE_OPT_LEVEL=_FAST_

INLINING_SETTINGS=-finline-functions -finline-limit=200
LDSCRIPT = src/stm32f407x6.ld
CC=gcc
PREFIX	= arm-none-eabi
ARMCC	= $(PREFIX)-$(CC)

RANLIB=ranlib

ARCH_FLAGS  = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -MD -DSTM32F4
CFLAGS		= -c $(OPT) -std=c99 -D $(USE_OPT_LEVEL) -D _ARM_CM4_ -D __NIX__ -D _NO_CACHE_MEM_ -D _DISABLE_CACHE_MEM_ $(INLINING_SETTINGS) \
	          -I./src/libopencm3/include -fno-common 
LDFLAGS		+= --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group -T$(LDSCRIPT) -nostartfiles -Wl,--gc-sections $(ARCH_FLAGS)

ifeq "$(USE_OPT_LEVEL)" "_GENERIC_"
EXTRA_OBJECTS_377=objs377/fp_generic.o
EXTRA_OBJECTS_434=objs434/fp_generic.o
EXTRA_OBJECTS_503=objs503/fp_generic.o
EXTRA_OBJECTS_610=objs610/fp_generic.o
EXTRA_OBJECTS_751=objs751/fp_generic.o
else ifeq "$(USE_OPT_LEVEL)" "_FAST_"
EXTRA_OBJECTS_377=objs377/fp_generic.o
EXTRA_OBJECTS_434=objs434/fp_arm_cm4.o objs434/fp_arm_cm4_asm.o
EXTRA_OBJECTS_503=objs503/fp_arm_cm4.o objs503/fp_arm_cm4_asm.o
EXTRA_OBJECTS_610=objs610/fp_arm_cm4.o objs610/fp_arm_cm4_asm.o
EXTRA_OBJECTS_751=objs751/fp_arm_cm4.o objs751/fp_arm_cm4_asm.o
endif
OBJECTS_377=objs377/P377.o $(EXTRA_OBJECTS_377) objs/random.o objs/fips202.o objs/test_extras.o objs/stm32f4_wrapper.o
OBJECTS_434=objs434/P434.o $(EXTRA_OBJECTS_434) objs/random.o objs/fips202.o objs/test_extras.o objs/stm32f4_wrapper.o
OBJECTS_503=objs503/P503.o $(EXTRA_OBJECTS_503) objs/random.o objs/fips202.o objs/test_extras.o objs/stm32f4_wrapper.o
OBJECTS_610=objs610/P610.o $(EXTRA_OBJECTS_610) objs/random.o objs/fips202.o objs/test_extras.o objs/stm32f4_wrapper.o
OBJECTS_751=objs751/P751.o $(EXTRA_OBJECTS_751) objs/random.o objs/fips202.o objs/test_extras.o objs/stm32f4_wrapper.o
OBJECTS_434_COMP=objs434comp/P434_compressed.o $(EXTRA_OBJECTS_434) objs/random.o objs/fips202.o
OBJECTS_503_COMP=objs503comp/P503_compressed.o $(EXTRA_OBJECTS_503) objs/random.o objs/fips202.o
OBJECTS_610_COMP=objs610comp/P610_compressed.o $(EXTRA_OBJECTS_610) objs/random.o objs/fips202.o
OBJECTS_751_COMP=objs751comp/P751_compressed.o $(EXTRA_OBJECTS_751) objs/random.o objs/fips202.o


#all: lib377 lib434 arith_tests-p377.bin arith_tests-p434.bin #tests KATS
#all: lib377 sike377/arith_tests-p377.bin
all: lib434 sike434/arith_tests-p434.bin lib503 sike503/arith_tests-p503.bin lib610 sike610/arith_tests-p610.bin lib751 sike751/arith_tests-p751.bin 

all434: lib434 sike434/arith_tests-p434.bin

test: lib434 MISC_TESTS/test.bin

objs377/%.o: src/P377/%.c
	@mkdir -p $(@D)
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) $< -o $@

objs434/%.o: src/P434/%.c
	@mkdir -p $(@D)
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) $< -o $@

objs503/%.o: src/P503/%.c
	@mkdir -p $(@D)
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) $< -o $@

objs610/%.o: src/P610/%.c
	@mkdir -p $(@D)
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) $< -o $@

objs751/%.o: src/P751/%.c
	@mkdir -p $(@D)
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) $< -o $@

ifeq "$(USE_OPT_LEVEL)" "_GENERIC_"			
objs377/fp_generic.o: src/P377/generic/fp_generic.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P377/generic/fp_generic.c -o objs377/fp_generic.o

objs434/fp_generic.o: src/P434/generic/fp_generic.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P434/generic/fp_generic.c -o objs434/fp_generic.o

objs503/fp_generic.o: src/P503/generic/fp_generic.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P503/generic/fp_generic.c -o objs503/fp_generic.o

objs610/fp_generic.o: src/P610/generic/fp_generic.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P610/generic/fp_generic.c -o objs610/fp_generic.o

objs751/fp_generic.o: src/P751/generic/fp_generic.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P751/generic/fp_generic.c -o objs751/fp_generic.o
else ifeq "$(USE_OPT_LEVEL)" "_FAST_"

objs434/fp_arm_cm4.o: src/P434/ARM_CM4/fp_arm_cm4.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P434/ARM_CM4/fp_arm_cm4.c -o objs434/fp_arm_cm4.o

objs434/fp_arm_cm4_asm.o: src/P434/ARM_CM4/fp_arm_cm4_asm.S
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P434/ARM_CM4/fp_arm_cm4_asm.S -o objs434/fp_arm_cm4_asm.o

objs503/fp_arm_cm4.o: src/P503/ARM_CM4/fp_arm_cm4.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P503/ARM_CM4/fp_arm_cm4.c -o objs503/fp_arm_cm4.o

objs503/fp_arm_cm4_asm.o: src/P503/ARM_CM4/fp_arm_cm4_asm.S
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P503/ARM_CM4/fp_arm_cm4_asm.S -o objs503/fp_arm_cm4_asm.o

objs610/fp_arm_cm4.o: src/P610/ARM_CM4/fp_arm_cm4.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P610/ARM_CM4/fp_arm_cm4.c -o objs610/fp_arm_cm4.o

objs610/fp_arm_cm4_asm.o: src/P610/ARM_CM4/fp_arm_cm4_asm.S
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P610/ARM_CM4/fp_arm_cm4_asm.S -o objs610/fp_arm_cm4_asm.o

objs751/fp_arm_cm4.o: src/P751/ARM_CM4/fp_arm_cm4.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P751/ARM_CM4/fp_arm_cm4.c -o objs751/fp_arm_cm4.o

objs751/fp_arm_cm4_asm.o: src/P751/ARM_CM4/fp_arm_cm4_asm.S
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/P751/ARM_CM4/fp_arm_cm4_asm.S -o objs751/fp_arm_cm4_asm.o

endif

objs/random.o: src/random/random.c
	@mkdir -p $(@D)
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/random/random.c -o objs/random.o

objs/fips202.o: src/sha3/fips202.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/sha3/fips202.c -o objs/fips202.o

objs/stm32f4_wrapper.o: src/stm32f4_wrapper.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) src/stm32f4_wrapper.c -Wno-overflow -o objs/stm32f4_wrapper.o

objs/test_extras.o: tests/test_extras.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) tests/test_extras.c -o objs/test_extras.o

objs377/arith_tests-p377.o: tests/arith_tests-p377.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) tests/arith_tests-p377.c -o objs377/arith_tests-p377.o

objs434/arith_tests-p434.o: tests/arith_tests-p434.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) tests/arith_tests-p434.c -o objs434/arith_tests-p434.o

objs503/arith_tests-p503.o: tests/arith_tests-p503.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) tests/arith_tests-p503.c -o objs503/arith_tests-p503.o

objs610/arith_tests-p610.o: tests/arith_tests-p610.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) tests/arith_tests-p610.c -o objs610/arith_tests-p610.o

objs751/arith_tests-p751.o: tests/arith_tests-p751.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) tests/arith_tests-p751.c -o objs751/arith_tests-p751.o

MISC_TESTS/test.o: MISC_TESTS/test.c
	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) MISC_TESTS/test.c -o MISC_TESTS/test.o


lib377: $(OBJECTS_377)
	rm -rf lib377 sike377 sidh377
	mkdir lib377 sike377 sidh377
	$(PREFIX)-ar cr lib377/libsidh.a $(OBJECTS_377)

lib434: $(OBJECTS_434)
	rm -rf lib434 sike434 sidh434
	mkdir lib434 sike434 sidh434
	$(PREFIX)-ar cr lib434/libsidh.a $(OBJECTS_434)

lib503: $(OBJECTS_503)
	rm -rf lib503 sike503 sidh503
	mkdir lib503 sike503 sidh503
	$(PREFIX)-ar cr lib503/libsidh.a $(OBJECTS_503)

lib610: $(OBJECTS_610)
	rm -rf lib610 sike610 sidh610
	mkdir lib610 sike610 sidh610
	$(PREFIX)-ar cr lib610/libsidh.a $(OBJECTS_610)

lib751: $(OBJECTS_751)
	rm -rf lib751 sike751 sidh751
	mkdir lib751 sike751 sidh751
	$(PREFIX)-ar cr lib751/libsidh.a $(OBJECTS_751)

lib434comp: $(OBJECTS_434_COMP)
	rm -rf lib434comp sike434_compressed sidh434_compressed
	mkdir lib434comp sike434_compressed sidh434_compressed
	$(AR) lib434comp/libsidh.a $^
	$(RANLIB) lib434comp/libsidh.a

lib503comp: $(OBJECTS_503_COMP)
	rm -rf lib503comp sike503_compressed sidh503_compressed
	mkdir lib503comp sike503_compressed sidh503_compressed
	$(PREFIX)-ar cr lib503comp/libsidh.a $^
	$(RANLIB) lib503comp/libsidh.a

lib610comp: $(OBJECTS_610_COMP)
	rm -rf lib610comp sike610_compressed sidh610_compressed
	mkdir lib610comp sike610_compressed sidh610_compressed
	$(PREFIX)-ar cr lib610comp/libsidh.a $^
	$(RANLIB) lib610comp/libsidh.a

lib751comp: $(OBJECTS_751_COMP)
	rm -rf lib751comp sike751_compressed sidh751_compressed
	mkdir lib751comp sike751_compressed sidh751_compressed
	$(PREFIX)-ar cr lib751comp/libsidh.a $^
	$(RANLIB) lib751comp/libsidh.a

sike377/arith_tests-p377.bin: objs377/arith_tests-p377.elf
	$(PREFIX)-objcopy -Obinary objs377/arith_tests-p377.elf sike377/arith_tests-p377.bin

objs377/arith_tests-p377.elf: objs377/arith_tests-p377.o objs/test_extras.o $(LDSCRIPT) lib377/libsidh.a 
	$(ARMCC) -o objs377/arith_tests-p377.elf objs377/arith_tests-p377.o objs/test_extras.o lib377/libsidh.a $(LDFLAGS) src/libopencm3/lib/libopencm3_stm32f4.a

sike434/arith_tests-p434.bin: objs434/arith_tests-p434.elf
	$(PREFIX)-objcopy -Obinary objs434/arith_tests-p434.elf sike434/arith_tests-p434.bin

objs434/arith_tests-p434.elf: objs434/arith_tests-p434.o objs/test_extras.o $(LDSCRIPT) lib434/libsidh.a 
	$(ARMCC) -o objs434/arith_tests-p434.elf objs434/arith_tests-p434.o objs/test_extras.o lib434/libsidh.a $(LDFLAGS) src/libopencm3/lib/libopencm3_stm32f4.a

sike503/arith_tests-p503.bin: objs503/arith_tests-p503.elf
	$(PREFIX)-objcopy -Obinary objs503/arith_tests-p503.elf sike503/arith_tests-p503.bin

objs503/arith_tests-p503.elf: objs503/arith_tests-p503.o objs/test_extras.o $(LDSCRIPT) lib503/libsidh.a 
	$(ARMCC) -o objs503/arith_tests-p503.elf objs503/arith_tests-p503.o objs/test_extras.o lib503/libsidh.a $(LDFLAGS) src/libopencm3/lib/libopencm3_stm32f4.a

sike610/arith_tests-p610.bin: objs610/arith_tests-p610.elf
	$(PREFIX)-objcopy -Obinary objs610/arith_tests-p610.elf sike610/arith_tests-p610.bin

objs610/arith_tests-p610.elf: objs610/arith_tests-p610.o objs/test_extras.o $(LDSCRIPT) lib610/libsidh.a 
	$(ARMCC) -o objs610/arith_tests-p610.elf objs610/arith_tests-p610.o objs/test_extras.o lib610/libsidh.a $(LDFLAGS) src/libopencm3/lib/libopencm3_stm32f4.a

sike751/arith_tests-p751.bin: objs751/arith_tests-p751.elf
	$(PREFIX)-objcopy -Obinary objs751/arith_tests-p751.elf sike751/arith_tests-p751.bin

objs751/arith_tests-p751.elf: objs751/arith_tests-p751.o objs/test_extras.o $(LDSCRIPT) lib751/libsidh.a 
	$(ARMCC) -o objs751/arith_tests-p751.elf objs751/arith_tests-p751.o objs/test_extras.o lib751/libsidh.a $(LDFLAGS) src/libopencm3/lib/libopencm3_stm32f4.a

MISC_TESTS/test.bin: MISC_TESTS/test.elf
	$(PREFIX)-objcopy -Obinary MISC_TESTS/test.elf MISC_TESTS/test.bin

MISC_TESTS/test.elf: MISC_TESTS/test.o objs/test_extras.o $(LDSCRIPT) lib434/libsidh.a 
	$(ARMCC) -o MISC_TESTS/test.elf MISC_TESTS/test.o objs/test_extras.o lib434/libsidh.a $(LDFLAGS) src/libopencm3/lib/libopencm3_stm32f4.a


#$(CC) $(CFLAGS) -L./lib434comp tests/test_SIDHp434_compressed.c tests/test_extras.c -lsidh $(LDFLAGS) -o sidh434_compressed/test_SIDH $(ARM_SETTING)




#sidh377/test_SIDH.bin: sidh377/test_SIDH.elf
#	$(PREFIX)-objcopy -Obinary sidh377/test_SIDH.elf sidh377/test_SIDH.bin

#sidh377/test_SIDH.elf: test_SIDH.o $(LDSCRIPT) lib377/libsidh.a 
#	$(ARMCC) -o sidh377/test_SIDH.elf tests/arith_tests-p377.o tests/test_extras.o lib377/libsidh.a $(LDFLAGS) libopencm3/lib/libopencm3_stm32f4.a

#tests: lib377 lib434
#	$(CC) $(CFLAGS) -L./lib377 tests/arith_tests-p377.c tests/test_extras.c -lsidh $(LDFLAGS) -o arith_tests-p377 $(ARM_SETTING)
#	$(CC) $(CFLAGS) -L./lib434 tests/arith_tests-p434.c tests/test_extras.c -lsidh $(LDFLAGS) -o arith_tests-p434 $(ARM_SETTING)
#	$(CC) $(CFLAGS) -L./lib377 tests/test_SIDHp377.c tests/test_extras.c -lsidh $(LDFLAGS) -o sidh377/test_SIDH $(ARM_SETTING)
#	$(CC) $(CFLAGS) -L./lib434 tests/test_SIDHp434.c tests/test_extras.c -lsidh $(LDFLAGS) -o sidh434/test_SIDH $(ARM_SETTING)
#	$(CC) $(CFLAGS) -L./lib377 tests/test_SIKEp377.c tests/test_extras.c -lsidh $(LDFLAGS) -o sike377/test_SIKE $(ARM_SETTING)
#	$(CC) $(CFLAGS) -L./lib434 tests/test_SIKEp434.c tests/test_extras.c -lsidh $(LDFLAGS) -o sike434/test_SIKE $(ARM_SETTING)

# AES
#AES_OBJS=objs/aes.o objs/aes_c.o

#objs/%.o: tests/aes/%.c
#	@mkdir -p $(@D)
#	$(ARMCC) -c $(CFLAGS) $(ARCH_FLAGS) $< -o $@

#lib377_for_KATs: $(OBJECTS_377) $(AES_OBJS)
#	$(AR) lib377/libsidh_for_testing.a $^
#	$(RANLIB) lib377/libsidh_for_testing.a

#lib434_for_KATs: $(OBJECTS_434) $(AES_OBJS)
#	$(AR) lib434/libsidh_for_testing.a $^
#	$(RANLIB) lib434/libsidh_for_testing.a

#KATS: lib377_for_KATs lib434_for_KATs
#	$(CC) $(CFLAGS) -L./lib377 tests/PQCtestKAT_kem377.c tests/rng/rng.c -lsidh_for_testing $(LDFLAGS) -o sike377/PQCtestKAT_kem $(ARM_SETTING)
#	$(CC) $(CFLAGS) -L./lib434 tests/PQCtestKAT_kem434.c tests/rng/rng.c -lsidh_for_testing $(LDFLAGS) -o sike434/PQCtestKAT_kem $(ARM_SETTING)

check: tests

.PHONY: clean

clean:
	rm -rf *.req objs377* objs434* objs503* objs610* objs751* objs lib377* lib434* lib503* lib610* lib751* sidh377* sidh434* sidh503* sidh610* sidh751* sike377* sike434* sike503* sike610* sike751* arith_tests-* MISC_TESTS/test.o MISC_TESTS/test.elf MISC_TESTS/test.bin

