
module VGASubsystem (
	char_buffer_control_slave_address,
	char_buffer_control_slave_byteenable,
	char_buffer_control_slave_chipselect,
	char_buffer_control_slave_read,
	char_buffer_control_slave_write,
	char_buffer_control_slave_writedata,
	char_buffer_control_slave_readdata,
	char_buffersource_slave_byteenable,
	char_buffersource_slave_chipselect,
	char_buffersource_slave_read,
	char_buffersource_slave_write,
	char_buffersource_slave_writedata,
	char_buffersource_slave_readdata,
	char_buffersource_slave_waitrequest,
	char_buffersource_slave_address,
	pixel_buffer_master_readdatavalid,
	pixel_buffer_master_waitrequest,
	pixel_buffer_master_address,
	pixel_buffer_master_lock,
	pixel_buffer_master_read,
	pixel_buffer_master_readdata,
	pixel_buffer_slave_address,
	pixel_buffer_slave_byteenable,
	pixel_buffer_slave_read,
	pixel_buffer_slave_write,
	pixel_buffer_slave_writedata,
	pixel_buffer_slave_readdata,
	rgb_resampler_slave_read,
	rgb_resampler_slave_readdata,
	sys_clk_clk,
	sys_reset_reset_n,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B,
	vga_clk_clk,
	vga_reset_reset_n);	

	input		char_buffer_control_slave_address;
	input	[3:0]	char_buffer_control_slave_byteenable;
	input		char_buffer_control_slave_chipselect;
	input		char_buffer_control_slave_read;
	input		char_buffer_control_slave_write;
	input	[31:0]	char_buffer_control_slave_writedata;
	output	[31:0]	char_buffer_control_slave_readdata;
	input		char_buffersource_slave_byteenable;
	input		char_buffersource_slave_chipselect;
	input		char_buffersource_slave_read;
	input		char_buffersource_slave_write;
	input	[7:0]	char_buffersource_slave_writedata;
	output	[7:0]	char_buffersource_slave_readdata;
	output		char_buffersource_slave_waitrequest;
	input	[12:0]	char_buffersource_slave_address;
	input		pixel_buffer_master_readdatavalid;
	input		pixel_buffer_master_waitrequest;
	output	[31:0]	pixel_buffer_master_address;
	output		pixel_buffer_master_lock;
	output		pixel_buffer_master_read;
	input	[15:0]	pixel_buffer_master_readdata;
	input	[1:0]	pixel_buffer_slave_address;
	input	[3:0]	pixel_buffer_slave_byteenable;
	input		pixel_buffer_slave_read;
	input		pixel_buffer_slave_write;
	input	[31:0]	pixel_buffer_slave_writedata;
	output	[31:0]	pixel_buffer_slave_readdata;
	input		rgb_resampler_slave_read;
	output	[31:0]	rgb_resampler_slave_readdata;
	input		sys_clk_clk;
	input		sys_reset_reset_n;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
	input		vga_clk_clk;
	input		vga_reset_reset_n;
endmodule
