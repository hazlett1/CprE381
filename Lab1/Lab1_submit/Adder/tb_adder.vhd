-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the full adder unit.
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_adder is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_adder;

architecture mixed of tb_adder is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component full_adder is
  port(i_C          : in  std_logic;
       i_A          : in  std_logic;
       i_B          : in  std_logic;
       o_S          : out std_logic;
       o_C          : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iC  : std_logic;
signal s_iA  : std_logic;
signal s_iB  : std_logic;
signal s_oS  : std_logic;
signal s_oC  : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: full_adder
  port map( i_C     => s_iC,
            i_A     => s_iA,
	    i_B     => s_iB,
            o_S     => s_oS,
            o_C     => s_oC);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_iA <= '0';
    s_iB <= '0';
    wait for gCLK_HPER*2;
    -- Expect: s_W internal signal to be 10 after positive edge of clock

    -- Test case 2:
    -- Perform average example of an input activation of 3 and a partial sum of 25. The weight is still 10. 
    s_iA <= '0';
    s_iB <= '1';
    wait for gCLK_HPER*2;

    -- Test Case 3:
    s_iA <= '1';
    s_iB <= '0';
    wait for gCLK_HPER*2;

    -- Test Case 4:
    s_iA <= '1';
    s_iB <= '1';
    s_iC <= '1';
    wait for gCLK_HPER*2;
    -- Expect: o_Y output signal to be 55 = 3*10+25 and o_X output signal to be 3 after two positive edge of clock.

    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;