
module EV19_SoC (
	adc_0_external_interface_sclk,
	adc_0_external_interface_cs_n,
	adc_0_external_interface_dout,
	adc_0_external_interface_din,
	clk_clk,
	dip_export,
	enablepredictor_config,
	key_export,
	keyboard_CLK,
	keyboard_DAT,
	led_export,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B);	

	output		adc_0_external_interface_sclk;
	output		adc_0_external_interface_cs_n;
	input		adc_0_external_interface_dout;
	output		adc_0_external_interface_din;
	input		clk_clk;
	input	[3:0]	dip_export;
	input		enablepredictor_config;
	input		key_export;
	inout		keyboard_CLK;
	inout		keyboard_DAT;
	output	[7:0]	led_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
endmodule
