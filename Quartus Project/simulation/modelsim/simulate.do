transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

alias com {
	 echo "\[exec\] com"
	eval vcom -2008 -work work {../../Bloques/IP/Mux4x1Bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/ShifterLogic.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/ShifterArith.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Plus4.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux16x32Bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux8x1.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux3x32bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux2x4bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux2x1bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux2x32bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux32x32bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Comparator32u.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Comparator32.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/NOP.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Adder.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Multiply.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/MultiplyU.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Divider.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/DividerU.vhd}
	eval vcom -2008 -work work {../../Bloques/Execute/ALU_Logic.vhd}
	eval vcom -2008 -work work {../../Bloques/Execute/ALU_ExtendBit.vhd}
	eval vcom -2008 -work work {../../Bloques/Decode/RegisterFile.vhd}
	eval vcom -2008 -work work {../../Bloques/Decode/InstDecoder.vhd}
	eval vcom -2008 -work work {../../Bloques/Decode/immGenerator.vhd}
	eval vcom -2008 -work work {../../Bloques/Fetch/ResetPC.vhd}
	eval vcom -2008 -work work {../../Bloques/Fetch/register32.vhd}
	eval vcom -2008 -work work {../../Bloques/EV19_Types.vhd}
	eval vcom -2008 -work work {../../Bloques/EV19_Constants.vhd}
	eval vcom -2008 -work work {../../Bloques/EV19_ISA.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux4x8bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux2x16bit.vhd}
	eval vcom -2008 -work work {../../Bloques/IP/Mux2x5bit.vhd}
	eval vcom -2008 -work work {../../Bloques/Memory/MePipelineReg.vhd}
	eval vcom -2008 -work work {../../Bloques/Execute/ExPipelineReg.vhd}
	eval vcom -2008 -work work {../../Bloques/Decode/DePipelineReg.vhd}
	eval vcom -2008 -work work {../../Bloques/Execute/ShiftBlock.vhd}
	eval vcom -2008 -work work {../../Bloques/Execute/ByteEnableBlock.vhd}
	eval vcom -2008 -work work {../../Bloques/Decode/ControlStore.vhd}
	eval vcom -2008 -work work {../../Bloques/ForwardingHazardUnit.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Core.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Fetch.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Decode.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Execute.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/ExecuteALU.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/ExecuteBranch.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Writeback.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Memory.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/LoadBlock.vhd}
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Writeback.vhd}
	eval vcom -2008 -work work {../../testbenches/CoreTestBench.vhd}

}

alias sim {
	eval vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  CoreTestbench
	do wave.do
	run -all
	wave zoom full;
}

alias signals {
	do wave.do
}

alias updateROM {
	eval vcom -2008 -work work {../../testbenches/CoreTestBench.vhd}
	restart
	run -all
	wave zoom full;
}

alias updateFetch {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Fetch/Fetch.bdf
	file copy -force  ../../Bloques/Fetch/Fetch.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Fetch.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}

alias updateDecode {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Decode/Decode.bdf
	file copy -force  ../../Bloques/Decode/Decode.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Decode.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}

alias updateExecute {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Execute/Execute.bdf
	file copy -force  ../../Bloques/Execute/Execute.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Execute.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}



alias updateExecuteALU {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Execute/ExecuteALU.bdf
	file copy -force  ../../Bloques/Execute/ExecuteALU.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/ExecuteALU.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}

alias updateExecuteBranch {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Execute/ExecuteBranch.bdf
	file copy -force  ../../Bloques/Execute/ExecuteBranch.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/ExecuteBranch.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}


alias updateWriteback {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Writeback/Writeback.bdf
	file copy -force  ../../Bloques/Writeback/Writeback.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Writeback.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}


alias updateMemory {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Memory/Memory.bdf
	file copy -force  ../../Bloques/Memory.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Memory.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}

alias updateLoadBlock {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Memory/LoadBlock.bdf
	file copy -force  ../../Bloques/LoadBlock.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/LoadBlock.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}

alias updateCore {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Core.bdf
	file copy -force  ../../Bloques/Core.vhd 					../../Bloques/VHDL(simulacion) 
	eval vcom -2008 -work work {../../Bloques/VHDL(simulacion)/Core.vhd}
	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}


alias updateBDF {
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Core.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Fetch/Fetch.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Decode/Decode.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Execute/Execute.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Execute/ExecuteALU.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Execute/ExecuteBranch.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Memory/Memory.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Memory/LoadBlock.bdf
	exec quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=../../Bloques/Writeback/Writeback.bdf
	
	file copy -force  ../../Bloques/Core.vhd 					../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Fetch/Fetch.vhd 			../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Decode/Decode.vhd 			../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Execute/Execute.vhd 		../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Execute/ExecuteALU.vhd 		../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Execute/ExecuteBranch.vhd	../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Memory/Memory.vhd 			../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Memory/LoadBlock.vhd 		../../Bloques/VHDL(simulacion) 
	file copy -force  ../../Bloques/Writeback/Writeback.vhd 	../../Bloques/VHDL(simulacion) 

	"com"

	delete wave *
	do wave.do
	restart
	run -all
	wave zoom full;
}

alias h {
  echo "COMANDOS"
  echo
  echo "com        -- Compila todo"
  echo
  echo "sim        -- Simula"
  echo
  echo "signals    -- Abre las ventanas con todas las señales"
  echo
  echo "updateROM  -- Recompila el testbench"
  echo
  echo "updateBDF  -- Regenera los VHDL despues de cambiar un .bdf"
  echo
}

