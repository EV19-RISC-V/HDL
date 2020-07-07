################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../main.c 

S_UPPER_SRCS += \
../startup.S 

OBJS += \
./main.o \
./startup.o 

S_UPPER_DEPS += \
./startup.d 

C_DEPS += \
./main.d 


# Each subdirectory must supply rules for building sources it contributes
main.o: ../main.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mstrict-align -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\libfixmath" -std=gnu11 -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"main.d" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

%.o: ../%.S
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross Assembler'
	riscv-none-embed-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mstrict-align -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall -x assembler-with-cpp -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\libfixmath" -I"C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\Drivers" -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


