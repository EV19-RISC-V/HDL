################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../libfixmath/fix16.c \
../libfixmath/fix16_exp.c \
../libfixmath/fix16_sqrt.c \
../libfixmath/fix16_trig.c \
../libfixmath/fract32.c \
../libfixmath/uint32.c 

OBJS += \
./libfixmath/fix16.o \
./libfixmath/fix16_exp.o \
./libfixmath/fix16_sqrt.o \
./libfixmath/fix16_trig.o \
./libfixmath/fract32.o \
./libfixmath/uint32.o 

C_DEPS += \
./libfixmath/fix16.d \
./libfixmath/fix16_exp.d \
./libfixmath/fix16_sqrt.d \
./libfixmath/fix16_trig.d \
./libfixmath/fract32.d \
./libfixmath/uint32.d 


# Each subdirectory must supply rules for building sources it contributes
libfixmath/%.o: ../libfixmath/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mstrict-align -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\libfixmath" -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\Drivers" -std=gnu11 -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


