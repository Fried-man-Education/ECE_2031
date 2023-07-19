-- AudioMonitor.vhd
-- Created 2023
--
-- This SCOMP peripheral directly passes data from an input bus to SCOMP's I/O bus.

library IEEE;
library lpm;

use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
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
	 type sample_type is array (0 to 15) of std_logic_vector(15 downto 0); -- (sample size tbd)

    signal out_en       : std_logic;
    signal output_data  : std_logic_vector(15 downto 0);
	 
	 signal average	   : natural range 0 to integer'high;
	 signal next_index 	: natural range 0 to 15;	 							  -- (sample size tbd)
	 signal last_index	: natural range 0 to 15;								  -- (sample size tbd)
	 signal sample 	   : sample_type;
	 signal state		   : state_type;

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
		  
				-- initialize index to add data at
				next_index <= 0;
				state <= filling;
				
        elsif (rising_edge(AUD_NEW)) then
		  
				case state is				
					when filling =>									-- FILLING - average to point of filling
						if (next_index = 0) then					-- (sample size tbd)
							state <= full;								-- indicate full if array is maxed
							last_index <= 14;							-- specify the last index if the next is 0
						else
							last_index <= next_index - 1;			-- specify the last index
						end if;
						for i in 0 to 15 loop						-- loop over all size (tbd)
							if i <= last_index then					-- only add if i < size
								average <= average + to_integer(unsigned(sample(i)));
							end if;
						end loop;
						average <= average / (last_index + 1);	-- average of size to what has been filled
						
					when full =>										-- FULL - average entire array
						average <= average / 15;
				end case;
        end if;
    end process;

end a;