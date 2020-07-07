################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include libfixmath/subdir.mk
-include Drivers/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
EV19_RISCV.hex \

SECONDARY_LIST += \
EV19_RISCV.lst \

SECONDARY_SIZE += \
EV19_RISCV.siz \


# All Target
all: EV19_RISCV.elf secondary-outputs

# Tool invocations
EV19_RISCV.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU RISC-V Cross C Linker'
	riscv-none-embed-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mstrict-align -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall -T "C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\EV19_RISCV\linkerScript.ld" -nostartfiles -Xlinker --gc-sections -Wl,-Map,"EV19_RISCV.map" --specs=nosys.specs -v -o "EV19_RISCV.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

EV19_RISCV.hex: EV19_RISCV.elf
	@echo 'Invoking: GNU RISC-V Cross Create Flash Image'
	riscv-none-embed-objcopy -O ihex -j .text --reverse-bytes=4 "EV19_RISCV.elf" "ROM.hex"  && "C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\hex2mif.exe" 16384 ROM.hex && riscv-none-embed-objcopy -O ihex -j .data --reverse-bytes=4 "EV19_RISCV.elf"  "RAM.hex" && "C:\Users\Tobias\Desktop\13 - EV19_RISCV (integrado en Platform Designer)\software\Eclipse Workspace\hex2mif.exe" 4096 "RAM.hex" && quartus_stp -t programmer.tcl
	@echo 'Finished building: $@'
	@echo ' '

EV19_RISCV.lst: EV19_RISCV.elf
	@echo 'Invoking: GNU RISC-V Cross Create Listing'
	riscv-none-embed-objdump --source --all-headers --demangle --disassemble --line-numbers "EV19_RISCV.elf" > "EV19_RISCV.lst"
	@echo 'Finished building: $@'
	@echo ' '

EV19_RISCV.siz: EV19_RISCV.elf
	@echo 'Invoking: GNU RISC-V Cross Print Size'
	riscv-none-embed-size --format=berkeley "EV19_RISCV.elf"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(SECONDARY_FLASH)$(SECONDARY_LIST)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_UPPER_DEPS)$(C_DEPS) EV19_RISCV.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

.PHONY: all clean dependents

-include ../makefile.targets
