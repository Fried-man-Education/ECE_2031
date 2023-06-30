-- DIG_OUT.VHD (a peripheral module for SCOMP)
-- 2006.10.08
--
-- This module drives parallel outputs, latching data on the rising edge of CS.


LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY DIG_OUT IS
  PORT(
    RESETN      : IN  STD_LOGIC;
    CS          : IN  STD_LOGIC;
    DOUT        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END DIG_OUT;


ARCHITECTURE a OF DIG_OUT IS
  SIGNAL BLED : STD_LOGIC_VECTOR(15 DOWNTO 0);

  BEGIN
    DOUT <= BLED;


    PROCESS (RESETN, CS)
      BEGIN
        IF (RESETN = '0') THEN
          BLED <= x"0000";
        ELSIF (RISING_EDGE(CS)) THEN
          BLED <= IO_DATA;
        END IF;
      END PROCESS;
  END a;

