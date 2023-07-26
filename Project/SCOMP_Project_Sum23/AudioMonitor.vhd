-- AudioMonitor.vhd
-- Created 2023
--
-- This SCOMP peripheral directly passes data from an input bus to SCOMP's I/O bus.

library IEEE;
library lpm;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use lpm.lpm_components.all;

entity AudioMonitor is
port(
    CS          : in  std_logic;
    IO_WRITE    : in  std_logic;
    SYS_CLK     : in  std_logic;  -- SCOMP's clock
    RESETN      : in  std_logic;
    AUD_DATA    : in  std_logic_vector(15 downto 0);
    AUD_NEW     : in  std_logic;
    IO_DATA     : inout  std_logic_vector(15 downto 0);
	 AVERAGE_S   :	out std_logic_vector(15 downto 0);
	 window_sum1	:out std_logic_vector(31 downto 0);
	 window_sum2	:out std_logic_vector(31 downto 0)
	 
);
end AudioMonitor;

architecture a of AudioMonitor is

    signal parsed_data 	: signed(15 downto 0); --data from audio monitor 16 bit signed audio data
    signal out_en       : std_logic;
    signal output_data  : std_logic_vector(15 downto 0);
	 signal average	   : signed(15 downto 0) := (others => '0');
	 signal average_temp : signed(31 downto 0);
	 signal window_sum 	: signed(31 downto 0) := (others => '0');
	 signal next_sum 		: signed(31 downto 0) := (others => '0');
	 signal next_index 	: natural range 0 to 11999999 := 0;
	 signal count 			: natural range 0 to 11999999 := 0;
	 signal previou 		: natural range 0 to 11999999 := 0;
	 signal divisor		: integer := 12000000;
	 signal max				: natural range 0 to 12000000 := 0;

begin

    -- Latch data on rising edge of CS to keep it stable during IN
    process (CS) begin
        if rising_edge(CS) then
            output_data <= std_logic_vector(average);
        end if;
    end process;
    -- Drive IO_DATA when needed.
    out_en <= CS AND ( NOT IO_WRITE );
    with out_en select IO_DATA <=
        output_data        when '1',
        "ZZZZZZZZZZZZZZZZ" when others;

    -- This template device just copies the input data
    -- to IO_DATA by latching the data every time a new
    -- value is ready.
    process (RESETN, AUD_NEW)
    begin
        if (RESETN = '0') then
		  
				-- reset values
				parsed_data <= x"0000";
				window_sum <= (others => '0');
				average <= (others => '0');
				
			
        elsif (rising_edge(AUD_NEW)) then
				parsed_data <= signed(AUD_DATA);
				
				if (count < 12000000) then
					window_sum <= window_sum + abs(parsed_data);
					window_sum1 <= std_logic_vector(window_sum);
					count <= count + 1;
					max <= count;
					average_temp <= window_sum / to_signed(max, window_sum'length);
					average <= resize(average_temp, average'length);
					
				else
					
					average <= abs(parsed_data) + ((average - abs(parsed_data)) / to_signed(max, window_sum'length));
				end if;
				
																
				
       end if; 
    end process;

end a;