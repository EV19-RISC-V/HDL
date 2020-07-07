quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Core.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Fetch/Fetch.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Decode/Decode.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Execute/Execute.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Execute/LongInstruction.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Execute/ExecuteALU.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Execute/ExecuteBranch.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Memory/Memory.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Memory/LoadBlock.bdf
quartus_map --read_settings_files=on --write_settings_files=off EV19_RISCV -c EV19_RISCV --convert_bdf_to_vhdl=./Bloques/Writeback/Writeback.bdf

move /Y .\Bloques\Core.vhd 			.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Fetch\Fetch.vhd 		.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Decode\Decode.vhd 		.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Execute\Execute.vhd 		.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Execute\LongInstruction.vhd 	.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Execute\ExecuteALU.vhd 	.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Execute\ExecuteBranch.vhd	.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Memory\Memory.vhd 		.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Memory\LoadBlock.vhd 		.\Bloques\VHDL(simulacion) 
move /Y .\Bloques\Writeback\Writeback.vhd 	.\Bloques\VHDL(simulacion) 

pause