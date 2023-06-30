-- Module Generates Video Sync Signals for Video Montor Interface.
-- RGB and Sync outputs tie directly to monitor conector pins.
-- Stores graphics data for the train sim.
--
-- Kevin Johnson, 2016, modified 2022

library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY ALTERA_MF;
LIBRARY LPM;
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY VGA_PPU IS
	PORT(	v_clk_in   : IN	STD_LOGIC;
			cmd_en, cmd_clk    : IN STD_LOGIC;
			cmd        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			horiz_sync_out, 
			vert_sync_out, video_blank, video_clock, row_end	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			red, green, blue : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
END VGA_PPU;

ARCHITECTURE a OF VGA_PPU IS
	SIGNAL horiz_sync, vert_sync : STD_LOGIC;
	SIGNAL video_on_int, video_on_v, video_on_h : STD_LOGIC;
	
	SIGNAL h_count, v_count :STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL hp_count, vp_count :STD_LOGIC_VECTOR(4 DOWNTO 0); -- count pixels within sprites
	SIGNAL hs_count, vs_count :STD_LOGIC_VECTOR(4 DOWNTO 0); -- count sprites
	
	SIGNAL bg_spritenum : STD_LOGIC_VECTOR(4 downto 0); -- index of current bg sprite
	SIGNAL bg_color : STD_LOGIC_VECTOR(4 DOWNTO 0); -- current bg color
	SIGNAL fg_spritenum : STD_LOGIC_VECTOR(4 downto 0); -- index of current fg sprite
	SIGNAL fg_color : STD_LOGIC_VECTOR(4 DOWNTO 0); -- current fg color
	
	SIGNAL horiz_sync_d1, vert_sync_d1, horiz_sync_d2, vert_sync_d2 : STD_LOGIC;
	SIGNAL hp_count_d1, vp_count_d1, hp_count_d2, vp_count_d2 :STD_LOGIC_VECTOR(4 DOWNTO 0); -- count pixels within sprites
	SIGNAL hs_count_d1, vs_count_d1, hs_count_d2, vs_count_d2 :STD_LOGIC_VECTOR(4 DOWNTO 0); -- count sprites
	
	SIGNAL red_bg, blue_bg, green_bg : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL red_fg, blue_fg, green_fg : STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	
-- To select a different screen resolution, clock rate, and refresh rate
-- pick a set of new video timing constant values from table at end of code section
-- enter eight new sync timing constants below and
-- adjust PLL frequency output to pixel clock rate from table
-- using MegaWizard to edit video_PLL.vhd
-- Horizontal Timing Constants  
	CONSTANT H_pixels_across: 	Natural := 1024;
	CONSTANT H_sync_low: 		Natural := 1048;
	CONSTANT H_sync_high: 		Natural := 1184;
	CONSTANT H_end_count: 		Natural := 1344;
-- Vertical Timing Constants
	CONSTANT V_pixels_down: 	Natural := 768;
	CONSTANT V_sync_low: 		Natural := 771;
	CONSTANT V_sync_high: 		Natural := 777;
	CONSTANT V_end_count: 		Natural := 806;
-- Sprite info
	CONSTANT sprite_width: 		Natural := 31; -- 32-1
	CONSTANT sprite_height: 	Natural := 31; -- 32-1

BEGIN

 
-- video_on is high only when RGB pixel data is being displayed
-- used to blank color signals at screen edges during retrace
video_on_int <= video_on_H AND video_on_V;
-- output pixel clock and video on for external user logic
video_clock <= v_clk_in;

	-- ROM for the background sprite pixels
	-- Sprites are 32x32, arranged in a 32x768 image.
	-- Linearized to 24,576 pixels, 5-bit color each.
	-- Address is [spriteIndex*1024]+[row*32]+[column]
	BGPixels : altsyncram
	GENERIC MAP (
		intended_device_family => "Cyclone",
		width_a          => 5,
		widthad_a        => 15,
		numwords_a       => 24576,
		operation_mode   => "ROM",
		outdata_reg_a    => "UNREGISTERED",
		indata_aclr_a    => "NONE",
		wrcontrol_aclr_a => "NONE",
		address_aclr_a   => "NONE",
		outdata_aclr_a   => "NONE",
		init_file        => "BackgroundSprites.mif",
		lpm_hint         => "ENABLE_RUNTIME_MOD=NO",
		lpm_type         => "altsyncram"
	)
	PORT MAP (
		clock0    => v_clk_in,
		address_a => (bg_spritenum & "0000000000") + (vp_count_d1 & "00000") + hp_count_d1,
		q_a       => bg_color
	);

	-- Use altsyncram to store background layout.
	-- Screen is 32x24 tiles.   Address is (rrrrr ccccc).
	-- There are 32 possible tiles, so data is 5 bits.
	BGLayout : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK1",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		intended_device_family => "Cyclone II",
		lpm_type => "altsyncram",
		numwords_a => 768,
		numwords_b => 768,
		operation_mode => "DUAL_PORT",
		outdata_aclr_b => "NONE",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		init_file        => "BackgroundLayout.mif",
		widthad_a => 10,
		widthad_b => 10,
		width_a => 5,
		width_b => 5,
		width_byteena_a => 1
	)
	PORT MAP (
		wren_a => cmd(15) and cmd_en,
		clock0 => cmd_clk,
		clock1 => v_clk_in,
		address_a => cmd(9 downto 0),
		address_b => vs_count & hs_count,
		data_a => cmd(14 downto 10),
		q_b => bg_spritenum
	);
	
	-- ROM for the foreground sprite pixels
	-- Sprites are 32x32, arranged in a 32x768 image.
	-- Linearized to 24,576 pixels, 5-bit color each.
	-- Address is [spriteIndex*1024]+[row*32]+[column]
	FGPixels : altsyncram
	GENERIC MAP (
		intended_device_family => "Cyclone",
		width_a          => 5,
		widthad_a        => 15,
		numwords_a       => 24576,
		operation_mode   => "ROM",
		outdata_reg_a    => "UNREGISTERED",
		indata_aclr_a    => "NONE",
		wrcontrol_aclr_a => "NONE",
		address_aclr_a   => "NONE",
		outdata_aclr_a   => "NONE",
		init_file        => "ForegroundSprites.mif",
		lpm_hint         => "ENABLE_RUNTIME_MOD=NO",
		lpm_type         => "altsyncram"
	)
	PORT MAP (
		clock0    => v_clk_in,
		address_a => (fg_spritenum & "0000000000") + (vp_count_d1 & "00000") + hp_count_d1,
		q_a       => fg_color
	);

	-- Use altsyncram to store foreground layout.
	-- Screen is 32x24 tiles.   Address is (rrrrr ccccc).
	-- There are 32 possible tiles, so data is 5 bits.
	FGLayout : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK1",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		intended_device_family => "Cyclone II",
		lpm_type => "altsyncram",
		numwords_a => 768,
		numwords_b => 768,
		operation_mode => "DUAL_PORT",
		outdata_aclr_b => "NONE",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		init_file        => "ForegroundLayout.mif",
		widthad_a => 10,
		widthad_b => 10,
		width_a => 5,
		width_b => 5,
		width_byteena_a => 1
	)
	PORT MAP (
		wren_a => (not cmd(15)) and cmd_en,
		clock0 => cmd_clk,
		clock1 => v_clk_in,
		address_a => cmd(9 downto 0),
		address_b => vs_count & hs_count,
		data_a => cmd(14 downto 10),
		q_b => fg_spritenum
	);
	
	
signalGeneration : PROCESS
BEGIN
	WAIT UNTIL RISING_EDGE(v_clk_in);
   		pixel_column <= h_count(9 downto 0);
   		pixel_row <= v_count(9 downto 0);

-- Put all video signals through DFFs to elminate any small timing delays that cause a blurry image
	horiz_sync_out <= horiz_sync_d2;
	vert_sync_out <= vert_sync_d2;
	video_blank <= video_on_int;
	
	horiz_sync_d1 <= horiz_sync;
	vert_sync_d1 <= vert_sync;
	horiz_sync_d2 <= horiz_sync_d1;
	vert_sync_d2 <= vert_sync_d1;
	hp_count_d1 <= hp_count;
	vp_count_d1 <= vp_count;
--	hp_count_d2 <= hp_count_d1;
--	vp_count_d2 <= vp_count_d1;
--	hs_count_d1 <= hs_count;
--	vs_count_d1 <= vs_count;
--	hs_count_d2 <= hs_count_d1;
--	vs_count_d2 <= vs_count_d1;
	
-- 		Also turn off RGB color signals at edge of screen during vertical and horizontal retrace

--Generate Horizontal and Vertical Timing Signals for Video Signal
-- H_count counts pixels (#pixels across + extra time for sync signals)
-- 
--  Horiz_sync  ------------------------------------__________--------
--  H_count     0                 #pixels            sync low      end
--
	IF (h_count = H_end_count) THEN
   	h_count <= "00000000000";
   	hp_count <= "00000";
   	hs_count <= "00000";
	ELSE
   	h_count <= h_count + 1;
		IF (hp_count = sprite_width) THEN
			hp_count <= "00000";
			hs_count <= hs_count + 1;
		ELSE
			hp_count <= hp_count + 1;
		END IF;
	END IF;

--Generate Horizontal Sync Signal using H_count
	IF (h_count <= H_sync_high) AND (h_count >= H_sync_low) THEN
 	  	horiz_sync <= '0';
	ELSE
 	  	horiz_sync <= '1';
	END IF;
--Generate row end Signal using H_count
	IF (h_count >= H_pixels_across) AND (v_count < V_pixels_down) THEN
 	  	row_end <= '1';
	ELSE
 	  	row_end <= '0';
	END IF;

--V_count counts rows of pixels (#pixel rows down + extra time for V sync signal)
--  
--  Vert_sync      -----------------------------------------------_______------------
--  V_count         0                        last pixel row      V sync low       end
--
	IF (v_count >= V_end_count) AND (h_count >= H_sync_low) THEN
   		v_count <= "00000000000";
   		vp_count <= "00000";
   		vs_count <= "00000";
	ELSIF (h_count = H_sync_low) THEN
   		v_count <= v_count + 1;
   		IF (vp_count = sprite_height) THEN
				vp_count <= "00000";
				vs_count <= vs_count + 1;
			ElSE
				vp_count <= vp_count + 1;
			END IF;
	END IF;

-- Generate Vertical Sync Signal using V_count
	IF (v_count <= V_sync_high) AND (v_count >= V_sync_low) THEN
   		vert_sync <= '0';
	ELSE
  		vert_sync <= '1';
	END IF;

-- Generate "Video on" Screen Signals for Pixel Data
-- Video on = 1 indicates pixel are being displayed
-- Video on = 0 retrace - user logic can update display
-- without causing visual glitches.
	IF (h_count < H_pixels_across) THEN
   		video_on_h <= '1';
	ELSE
	   	video_on_h <= '0';
	END IF;

	IF (v_count <= V_pixels_down) THEN
   		video_on_v <= '1';
	ELSE
   		video_on_v <= '0';
	END IF;


END PROCESS;

	red <= red_fg(9 downto 2) WHEN fg_color /= "00000" ELSE red_bg(9 downto 2);
	green <= green_fg(9 downto 2) WHEN fg_color /= "00000" ELSE green_bg(9 downto 2);
	blue <= blue_fg(9 downto 2) WHEN fg_color /= "00000" ELSE blue_bg(9 downto 2);

	WITH bg_color SELECT red_bg <=
"0001011000" WHEN "00000",
"0001111000" WHEN "00001",
"0010110101" WHEN "00010",
"0011110101" WHEN "00011",
"0011100101" WHEN "00100",
"0100000101" WHEN "00101",
"0100011101" WHEN "00110",
"0100111101" WHEN "00111",
"0101010101" WHEN "01000",
"0101111001" WHEN "01001",
"0110010101" WHEN "01010",
"0110111101" WHEN "01011",
"0110100101" WHEN "01100",
"0111110001" WHEN "01101",
"1000010110" WHEN "01110",
"1001011010" WHEN "01111",
"1010111010" WHEN "10000",
"1010100110" WHEN "10001",
"1011101010" WHEN "10010",
"1010001110" WHEN "10011",
"1011010110" WHEN "10100",
"1011110110" WHEN "10101",
"1011100110" WHEN "10110",
"1100111110" WHEN "10111",
"1101100111" WHEN "11000",
"1110111011" WHEN "11001",
"1101001110" WHEN "11010",
"1110111011" WHEN "11011",
"1110100011" WHEN "11100",
"1111000111" WHEN "11101",
"1110101111" WHEN "11110",
"1110111011" WHEN "11111";

	WITH bg_color SELECT green_bg <=
"0001011100" WHEN "00000",
"0010000000" WHEN "00001",
"0010111101" WHEN "00010",
"0010110001" WHEN "00011",
"0011101001" WHEN "00100",
"0100001101" WHEN "00101",
"0100100101" WHEN "00110",
"0101000001" WHEN "00111",
"0101011001" WHEN "01000",
"0101111101" WHEN "01001",
"0110000101" WHEN "01010",
"0110101101" WHEN "01011",
"0110101101" WHEN "01100",
"0110111101" WHEN "01101",
"0111110001" WHEN "01110",
"0111101001" WHEN "01111",
"0111010001" WHEN "10000",
"0111100101" WHEN "10001",
"0111100101" WHEN "10010",
"1001101010" WHEN "10011",
"1010101110" WHEN "10100",
"1011000110" WHEN "10101",
"1011101110" WHEN "10110",
"1100001010" WHEN "10111",
"1100101010" WHEN "11000",
"1101010010" WHEN "11001",
"1101010111" WHEN "11010",
"1101101011" WHEN "11011",
"1101101111" WHEN "11100",
"1101101111" WHEN "11101",
"1101111111" WHEN "11110",
"1110001111" WHEN "11111";

	WITH bg_color SELECT blue_bg <=
"0001010100" WHEN "00000",
"0001110100" WHEN "00001",
"0010110001" WHEN "00010",
"0001111100" WHEN "00011",
"0011100001" WHEN "00100",
"0100000001" WHEN "00101",
"0100011001" WHEN "00110",
"0100110101" WHEN "00111",
"0101001101" WHEN "01000",
"0101110001" WHEN "01001",
"0101010001" WHEN "01010",
"0101010101" WHEN "01011",
"0110011101" WHEN "01100",
"0101001001" WHEN "01101",
"0101101101" WHEN "01110",
"0101011001" WHEN "01111",
"0101010001" WHEN "10000",
"0101011001" WHEN "10001",
"0101010101" WHEN "10010",
"0110111001" WHEN "10011",
"0111101001" WHEN "10100",
"0111011101" WHEN "10101",
"1011100010" WHEN "10110",
"1000000110" WHEN "10111",
"0111110101" WHEN "11000",
"1000100110" WHEN "11001",
"1101001010" WHEN "11010",
"1000011110" WHEN "11011",
"1000111110" WHEN "11100",
"1000001010" WHEN "11101",
"1000101010" WHEN "11110",
"1000010110" WHEN "11111";

WITH fg_color SELECT red_fg <=
"1111110111" WHEN "00000",
"0000000000" WHEN "00001",
"0000011000" WHEN "00010",
"1100010010" WHEN "00011",
"1100110010" WHEN "00100",
"1100111010" WHEN "00101",
"1100011110" WHEN "00110",
"1101100111" WHEN "00111",
"1110100111" WHEN "01000",
"1111010011" WHEN "01001",
"0010101000" WHEN "01010",
"1111110011" WHEN "01011",
"1111111011" WHEN "01100",
"0001101100" WHEN "01101",
"0101001001" WHEN "01110",
"0101001001" WHEN "01111",
"0110010001" WHEN "10000",
"0000000000" WHEN "10001",
"0000000000" WHEN "10010",
"0000000000" WHEN "10011",
"0000000000" WHEN "10100",
"0000000000" WHEN "10101",
"0000000000" WHEN "10110",
"0000000000" WHEN "10111",
"0000000000" WHEN "11000",
"0000000000" WHEN "11001",
"0000000000" WHEN "11010",
"0000000000" WHEN "11011",
"0000000000" WHEN "11100",
"1100001010" WHEN "11101",
"1111111111" WHEN "11110",
"1111110011" WHEN "11111";

WITH fg_color SELECT green_fg <=
"0000010100" WHEN "00000",
"0000000100" WHEN "00001",
"0000000000" WHEN "00010",
"0000000000" WHEN "00011",
"0000000000" WHEN "00100",
"0000000000" WHEN "00101",
"0000010000" WHEN "00110",
"0000000000" WHEN "00111",
"0000000100" WHEN "01000",
"0000000000" WHEN "01001",
"0011110001" WHEN "01010",
"0000000000" WHEN "01011",
"0000000000" WHEN "01100",
"0101010001" WHEN "01101",
"0101001001" WHEN "01110",
"0101010001" WHEN "01111",
"1001001110" WHEN "10000",
"0100000101" WHEN "10001",
"0100001001" WHEN "10010",
"0100001101" WHEN "10011",
"0100010001" WHEN "10100",
"0100010101" WHEN "10101",
"0100100001" WHEN "10110",
"0100110101" WHEN "10111",
"0100111001" WHEN "11000",
"0101000101" WHEN "11001",
"0101000101" WHEN "11010",
"0101001101" WHEN "11011",
"0101010001" WHEN "11100",
"1011011110" WHEN "11101",
"1111111111" WHEN "11110",
"1111111111" WHEN "11111";

WITH fg_color SELECT blue_fg <=
"1111111111" WHEN "00000",
"0000000000" WHEN "00001",
"0000000000" WHEN "00010",
"0000000000" WHEN "00011",
"0000001000" WHEN "00100",
"0000000000" WHEN "00101",
"0000000000" WHEN "00110",
"0000000100" WHEN "00111",
"0000001000" WHEN "01000",
"0000000000" WHEN "01001",
"0000100100" WHEN "01010",
"0000001100" WHEN "01011",
"0000000000" WHEN "01100",
"0000001100" WHEN "01101",
"0000000000" WHEN "01110",
"0101000101" WHEN "01111",
"0001110000" WHEN "10000",
"1100010010" WHEN "10001",
"1100011110" WHEN "10010",
"1100101010" WHEN "10011",
"1100110110" WHEN "10100",
"1100111010" WHEN "10101",
"1101100011" WHEN "10110",
"1110011111" WHEN "10111",
"1110101011" WHEN "11000",
"1111001011" WHEN "11001",
"1111010011" WHEN "11010",
"1111101011" WHEN "11011",
"1111110011" WHEN "11100",
"1010101010" WHEN "11101",
"0000000100" WHEN "11110",
"1111101111" WHEN "11111";
	
END a;
--
-- Common Video Modes - pixel clock and sync counter values
--
--  Mode       Refresh  Hor. Sync    Pixel clock  Interlaced?  VESA?
--  ------------------------------------------------------------
--  640x480     60Hz      31.5khz     25.175Mhz       No         No
--  640x480     63Hz      32.8khz     28.322Mhz       No         No
--  640x480     70Hz      36.5khz     31.5Mhz         No         No
--  640x480     72Hz      37.9khz     31.5Mhz         No        Yes
--  800x600     56Hz      35.1khz     36.0Mhz         No        Yes
--  800x600     56Hz      35.4khz     36.0Mhz         No         No
--  800x600     60Hz      37.9khz     40.0Mhz         No        Yes
--  800x600     60Hz      37.9khz     40.0Mhz         No         No
--  800x600     72Hz      48.0khz     50.0Mhz         No        Yes
--  1024x768    60Hz      48.4khz     65.0Mhz         No        Yes
--  1024x768    60Hz      48.4khz     62.0Mhz         No         No
--  1024x768    70Hz      56.5khz     75.0Mhz         No        Yes
--  1024x768    70Hz      56.25khz    72.0Mhz         No         No
--  1024x768    76Hz      62.5khz     85.0Mhz         No         No
--  1280x1024   59Hz      63.6khz    110.0Mhz         No         No
--  1280x1024   61Hz      64.24khz   110.0Mhz         No         No
--  1280x1024   74Hz      78.85khz   135.0Mhz         No         No
--
-- Pixel clock within 5% works on most monitors.
-- Faster clocks produce higher refresh rates at the same resolution on
-- most new monitors up to the maximum rate.
-- Some older monitors may not support higher refresh rates
-- or may only sync at specific refresh rates - VESA modes most common.
-- Pixel clock within 5% works on most old monitors.
-- Refresh rates below 60Hz will have some flicker.
-- Bad values such as very high refresh rates may damage some monitors
-- that do not support faster refreseh rates - check monitor specs.
--
-- Small adjustments to the sync low count ranges can be used to move
-- video image left, right (H), down or up (V) on the monitor
--
--
-- 640x480@60Hz Non-Interlaced mode
-- Horizontal Sync = 31.5kHz
-- Timing: H=(0.95us, 3.81us, 1.59us), V=(0.35ms, 0.064ms, 1.02ms)
--
--	          clock     horizontal timing         vertical timing      flags
--             Mhz    pix.col low  high end    pix.rows low  high end
--640x480    25.175     640  664   760  800        480  491   493  525
--                              <->                        <->    
--  sync pulses: Horiz----------___------   Vert-----------___-------
--
-- Alternate 640x480@60Hz Non-Interlaced mode
-- Horizontal Sync = 31.5kHz
-- Timing: H=(1.27us, 3.81us, 1.27us) V=(0.32ms, 0.06ms, 1.05ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--640x480      25.175  640  672  768  800    480  490  492  525
--
--
-- 640x480@63Hz Non-Interlaced mode (non-standard)
-- Horizontal Sync = 32.8kHz
-- Timing: H=(1.41us, 1.41us, 5.08us) V=(0.24ms, 0.092ms, 0.92ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--640x480      28.322  640  680  720  864    480  488  491  521
--
--
-- 640x480@70Hz Non-Interlaced mode (non-standard)
-- Horizontal Sync = 36.5kHz
-- Timing: H=(1.27us, 1.27us, 4.57us) V=(0.22ms, 0.082ms, 0.82ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--640x480      31.5    640  680  720  864    480  488  491  521
--
--
-- VESA 640x480@72Hz Non-Interlaced mode
-- Horizontal Sync = 37.9kHz
-- Timing: H=(0.76us, 1.27us, 4.06us) V=(0.24ms, 0.079ms, 0.74ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--640x480      31.5    640  664  704  832    480  489  492  520
--
--
-- VESA 800x600@56Hz Non-Interlaced mode
-- Horizontal Sync = 35.1kHz
-- Timing: H=(0.67us, 2.00us, 3.56us) V=(0.03ms, 0.063ms, 0.70ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--800x600      36      800  824  896 1024    600  601  603  625
--
--
-- Alternate 800x600@56Hz Non-Interlaced mode
-- Horizontal Sync = 35.4kHz
-- Timing: H=(0.89us, 4.00us, 1.11us) V=(0.11ms, 0.057ms, 0.79ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--800x600      36      800  832  976 1016    600  604  606  634
--
--
-- VESA 800x600@60Hz Non-Interlaced mode
-- Horizontal Sync = 37.9kHz
-- Timing: H=(1.00us, 3.20us, 2.20us) V=(0.03ms, 0.106ms, 0.61ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--800x600      40      800  840  968 1056    600  601  605  628 +hsync +vsync
--
--
-- Alternate 800x600@60Hz Non-Interlaced mode
-- Horizontal Sync = 37.9kHz
-- Timing: H=(1.20us, 3.80us, 1.40us) V=(0.13ms, 0.053ms, 0.69ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--800x600      40      800 848 1000 1056     600  605  607  633
--
--
-- VESA 800x600@72Hz Non-Interlaced mode
-- Horizontal Sync = 48kHz
-- Timing: H=(1.12us, 2.40us, 1.28us) V=(0.77ms, 0.13ms, 0.48ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--800x600      50      800  856  976 1040    600  637  643  666  +hsync +vsync
--
--
-- VESA 1024x768@60Hz Non-Interlaced mode
-- Horizontal Sync = 48.4kHz
-- Timing: H=(0.12us, 2.22us, 2.58us) V=(0.06ms, 0.12ms, 0.60ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1024x768     65     1024 1032 1176 1344    768  771  777  806 -hsync -vsync
--
--
-- 1024x768@60Hz Non-Interlaced mode (non-standard dot-clock)
-- Horizontal Sync = 48.4kHz
-- Timing: H=(0.65us, 2.84us, 0.65us) V=(0.12ms, 0.041ms, 0.66ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1024x768     62     1024 1064 1240 1280   768  774  776  808
--
--
-- VESA 1024x768@70Hz Non-Interlaced mode
-- Horizontal Sync=56.5kHz
-- Timing: H=(0.32us, 1.81us, 1.92us) V=(0.05ms, 0.14ms, 0.51ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1024x768     75     1024 1048 1184 1328    768  771  777  806 -hsync -vsync
--
--
-- 1024x768@70Hz Non-Interlaced mode (non-standard dot-clock)
-- Horizontal Sync=56.25kHz
-- Timing: H=(0.44us, 1.89us, 1.22us) V=(0.036ms, 0.11ms, 0.53ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1024x768     72     1024 1056 1192 1280    768  770  776  806   -hsync -vsync
--
--
-- 1024x768@76Hz Non-Interlaced mode
-- Horizontal Sync=62.5kHz
-- Timing: H=(0.09us, 1.41us, 2.45us) V=(0.09ms, 0.048ms, 0.62ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1024x768     85     1024 1032 1152 1360    768  784  787  823
--
--
-- 1280x1024@59Hz Non-Interlaced mode (non-standard)
-- Horizontal Sync=63.6kHz
-- Timing: H=(0.36us, 1.45us, 2.25us) V=(0.08ms, 0.11ms, 0.65ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1280x1024   110     1280 1320 1480 1728   1024 1029 1036 1077
--
--
-- 1280x1024@61Hz, Non-Interlaced mode
-- Horizontal Sync=64.25kHz
-- Timing: H=(0.44us, 1.67us, 1.82us) V=(0.02ms, 0.05ms, 0.41ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1280x1024   110     1280 1328 1512 1712   1024 1025 1028 1054
--
--
-- 1280x1024@74Hz, Non-Interlaced mode
-- Horizontal Sync=78.85kHz
-- Timing: H=(0.24us, 1.07us, 1.90us) V=(0.04ms, 0.04ms, 0.43ms)
--
-- name        clock   horizontal timing     vertical timing      flags
--1280x1024   135     1280 1312 1456 1712   1024 1027 1030 1064
--
--	VGA female connector: 15 pin small "D" connector
--                   _________________________
--                   \   5   4   3   2   1   /
--                    \   10  X   8   7   6 /
--                     \ 15  14  13 12  11 /
--                      \_________________/
--   Signal Name    Pin Number   Notes
--   -----------------------------------------------------------------------
--   RED video          1        Analog signal, around 0.7 volt, peak-to-peak  75 ohm 
--   GREEN video        2        Analog signal, sround 0.7 volt, peak-to-peak  75 ohm 
--   BLUE video         3        Analog signal, around 0.7 volt, peak-to-peak  75 ohm
--   Monitor ID #2      4        
--   Digital Ground     5        Ground for the video system.
--   RED ground         6  \     The RGB color video signals each have a separate
--   GREEN ground       7  |     ground connection.  
--   BLUE ground        8  /      
--   KEY                9        (X = Not present)
--   SYNC ground       10        TTL return for the SYNC lines.
--   Monitor ID #0     11        
--   Monitor ID #1     12        
--   Horizontal Sync   13        Digital levels (0 to 5 volts, TTL output)
--   Vertical Sync     14        Digital levels (0 to 5 volts, TTL output)
--   Not Connected     15        (Not used)
--