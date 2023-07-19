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
    IO_DATA     : inout  std_logic_vector(15 downto 0)
);
end AudioMonitor;

architecture a of AudioMonitor is

	 type state_type is ( filling, full );
	 type sample_type is array (0 to 29999999) of std_logic_vector(15 downto 0);

    signal out_en       : std_logic;
    signal output_data  : std_logic_vector(15 downto 0);
	 
	 signal average	   : natural range 0 to integer'high := 0;
	 signal next_index 	: natural range 0 to 29999999 := 0;
	 signal last_index	: natural range 0 to 29999999;
	 signal divisor		: integer := 30000000;
	 signal removed		: integer;
	 signal sample 	   : sample_type;
	 signal state		   : state_type := filling;

begin

    -- Latch data on rising edge of CS to keep it stable during IN
    process (CS) begin
        if rising_edge(CS) then
            output_data <= std_logic_vector(to_unsigned(average, 16));
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
    process (RESETN, SYS_CLK)
    begin
        if (RESETN = '0') then
		  
				-- reset values
				next_index <= 0;
				state <= filling;
				divisor <= 30000000;
				
        elsif (rising_edge(AUD_NEW)) then
		  
				case state is				
					when filling =>																	-- FILLING - average to point of filling

						sample(next_index) <= AUD_DATA;												-- add data
						next_index <= (next_index + 1) mod divisor;									-- move next_index marker
						
						if (next_index = 0) then
							state <= full;															-- indicate full if array is maxed
							last_index <= divisor - 1;												-- specify the last index if the next is 0
						else
							last_index <= next_index - 1;											-- specify the last index
						end if;
						
						average <= average * (last_index);											-- get the sum
						average <= average + abs to_integer(signed(sample(next_index)));			-- add newest data
						average <= average / (last_index + 1);										-- average
						
					
					when full =>																	-- FULL - average entire array
						
						removed <= abs to_integer(signed(sample(next_index)));						-- keep removed data for later
						sample(next_index) <= AUD_DATA;												-- replace data
						next_index <= (next_index + 1) mod divisor;									-- move next_index marker
						
						average <= average * divisor;
						average <= average - removed + abs to_integer(signed(sample(next_index)));	-- correct the sum
						average <= average / divisor;
				end case;
				
        end if;
    end process;

end a;