	component EV19_SoC is
		port (
			adc_0_external_interface_sclk : out   std_logic;                                        -- sclk
			adc_0_external_interface_cs_n : out   std_logic;                                        -- cs_n
			adc_0_external_interface_dout : in    std_logic                     := 'X';             -- dout
			adc_0_external_interface_din  : out   std_logic;                                        -- din
			clk_clk                       : in    std_logic                     := 'X';             -- clk
			dip_export                    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			enablepredictor_config        : in    std_logic                     := 'X';             -- config
			key_export                    : in    std_logic                     := 'X';             -- export
			keyboard_CLK                  : inout std_logic                     := 'X';             -- CLK
			keyboard_DAT                  : inout std_logic                     := 'X';             -- DAT
			led_export                    : out   std_logic_vector(7 downto 0);                     -- export
			reset_reset_n                 : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk                 : out   std_logic;                                        -- clk
			sdram_wire_addr               : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                 : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n              : out   std_logic;                                        -- cas_n
			sdram_wire_cke                : out   std_logic;                                        -- cke
			sdram_wire_cs_n               : out   std_logic;                                        -- cs_n
			sdram_wire_dq                 : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n              : out   std_logic;                                        -- ras_n
			sdram_wire_we_n               : out   std_logic;                                        -- we_n
			vga_CLK                       : out   std_logic;                                        -- CLK
			vga_HS                        : out   std_logic;                                        -- HS
			vga_VS                        : out   std_logic;                                        -- VS
			vga_BLANK                     : out   std_logic;                                        -- BLANK
			vga_SYNC                      : out   std_logic;                                        -- SYNC
			vga_R                         : out   std_logic_vector(7 downto 0);                     -- R
			vga_G                         : out   std_logic_vector(7 downto 0);                     -- G
			vga_B                         : out   std_logic_vector(7 downto 0)                      -- B
		);
	end component EV19_SoC;

	u0 : component EV19_SoC
		port map (
			adc_0_external_interface_sclk => CONNECTED_TO_adc_0_external_interface_sclk, -- adc_0_external_interface.sclk
			adc_0_external_interface_cs_n => CONNECTED_TO_adc_0_external_interface_cs_n, --                         .cs_n
			adc_0_external_interface_dout => CONNECTED_TO_adc_0_external_interface_dout, --                         .dout
			adc_0_external_interface_din  => CONNECTED_TO_adc_0_external_interface_din,  --                         .din
			clk_clk                       => CONNECTED_TO_clk_clk,                       --                      clk.clk
			dip_export                    => CONNECTED_TO_dip_export,                    --                      dip.export
			enablepredictor_config        => CONNECTED_TO_enablepredictor_config,        --          enablepredictor.config
			key_export                    => CONNECTED_TO_key_export,                    --                      key.export
			keyboard_CLK                  => CONNECTED_TO_keyboard_CLK,                  --                 keyboard.CLK
			keyboard_DAT                  => CONNECTED_TO_keyboard_DAT,                  --                         .DAT
			led_export                    => CONNECTED_TO_led_export,                    --                      led.export
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --                    reset.reset_n
			sdram_clk_clk                 => CONNECTED_TO_sdram_clk_clk,                 --                sdram_clk.clk
			sdram_wire_addr               => CONNECTED_TO_sdram_wire_addr,               --               sdram_wire.addr
			sdram_wire_ba                 => CONNECTED_TO_sdram_wire_ba,                 --                         .ba
			sdram_wire_cas_n              => CONNECTED_TO_sdram_wire_cas_n,              --                         .cas_n
			sdram_wire_cke                => CONNECTED_TO_sdram_wire_cke,                --                         .cke
			sdram_wire_cs_n               => CONNECTED_TO_sdram_wire_cs_n,               --                         .cs_n
			sdram_wire_dq                 => CONNECTED_TO_sdram_wire_dq,                 --                         .dq
			sdram_wire_dqm                => CONNECTED_TO_sdram_wire_dqm,                --                         .dqm
			sdram_wire_ras_n              => CONNECTED_TO_sdram_wire_ras_n,              --                         .ras_n
			sdram_wire_we_n               => CONNECTED_TO_sdram_wire_we_n,               --                         .we_n
			vga_CLK                       => CONNECTED_TO_vga_CLK,                       --                      vga.CLK
			vga_HS                        => CONNECTED_TO_vga_HS,                        --                         .HS
			vga_VS                        => CONNECTED_TO_vga_VS,                        --                         .VS
			vga_BLANK                     => CONNECTED_TO_vga_BLANK,                     --                         .BLANK
			vga_SYNC                      => CONNECTED_TO_vga_SYNC,                      --                         .SYNC
			vga_R                         => CONNECTED_TO_vga_R,                         --                         .R
			vga_G                         => CONNECTED_TO_vga_G,                         --                         .G
			vga_B                         => CONNECTED_TO_vga_B                          --                         .B
		);

