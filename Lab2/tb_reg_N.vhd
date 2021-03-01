-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_reg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the register N-Bits wide
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
entity tb_reg_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_reg_N;

architecture mixed of tb_reg_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component reg_N is
  port(i_CLK        : in  std_logic;                        -- Clock input
       i_RST        : in  std_logic;                        -- Reset input
       i_WE         : in  std_logic;                        -- Write enable input
       i_D          : in  std_logic_vector(31 downto 0);    -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, rst, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_WE    : std_logic;
signal s_iD    : std_logic_vector(31 downto 0);
signal s_oQ    : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: reg_N
  port map( i_CLK   => CLK,
            i_RST   => rst,
            i_WE    => s_WE,
            i_D     => s_iD,
            o_Q     => s_oQ);
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
    wait for gCLK_HPER*2;
    rst   <= '0';
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    
    -- Test Case 1: 
    -- Write a simple number 7 into the register
    s_iD <= "00000000000000000000000000000111";
    s_WE <= '1';
    wait for gCLK_HPER*2;
    -- Expected output after two positive clocks should be o_Q = 7

    -- Test case 2:
    -- Change the inocoming data to 8 and have WE = 0, the output, o_Q should not change after two clock cycles and should
    -- be 7 instead of 8.
    s_iD <= "00000000000000000000000000001000";
    s_WE <= '0';
    wait for gCLK_HPER*2;
    -- Expected output after two positive edge clock cycles should be 
    --  WE = 0, i_D = 8, o_Q = 7

    -- Test Case 3:
    -- Add a new value of 0xFFFFFFFF into the register with WE set to 1, but reset the value at the same time
    s_iD  <= "11111111111111111111111111111111";
    s_WE  <= '1';
    rst   <= '1';
    wait for gCLK_HPER*2;
    -- Expected output after two positive edge clock cycles should be 
    --  WE = 1, i_D = 0xFFFFFFFF, o_Q = 0
    
    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;