################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/Keyboard.c \
../Drivers/PS2.c 

OBJS += \
./Drivers/Keyboard.o \
./Drivers/PS2.o 

C_DEPS += \
./Drivers/Keyboard.d \
./Drivers/PS2.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/%.o: ../Drivers/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mstrict-align -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\libfixmath" -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\Drivers" -std=gnu11 -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


