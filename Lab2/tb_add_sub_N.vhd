-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_add_sub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the adder-subtractor unit with N-bits.
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
entity tb_add_sub_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_add_sub_N;

architecture mixed of tb_add_sub_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component add_sub_N is
  port(i_C          :  in std_logic;
       i_nAdd_Sub   :  in std_logic;
       i_A          :  in std_logic_vector(31 downto 0);
       i_B          :  in std_logic_vector(31 downto 0);
       o_S          : out std_logic_vector(31 downto 0);
       o_C          : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iC        : std_logic;
signal s_nAdd_Sub : std_logic;
signal s_iA        : std_logic_vector(31 downto 0);
signal s_iB        : std_logic_vector(31 downto 0);
signal s_oS        : std_logic_vector(31 downto 0);
signal s_oC        : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: add_sub_N
  port map( i_C        => s_iC,
            i_nAdd_Sub => s_nAdd_Sub,
            i_A        => s_iA,
            i_B        => s_iB,
	    o_S        => s_oS,
	    o_C        => s_oC);
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

    -- Test Case 1:
    -- Performs a simple addition 7+4 = 11 (0xB) 
    s_iA <= "00000000000000000000000000000111";
    s_iB <= "00000000000000000000000000000100";
    s_iC <= '0';
    s_nAdd_Sub <= '0';
    wait for gCLK_HPER*2;
    -- Expected output should be 
    --  7 + 4 = 11 (0xB), o_S = 11 (0xB), o_C = 0.

    -- Test case 2:
    -- Perform a simple subtraction 100 - 60 = 40 (0x28)
    s_iA       <= "00000000000000000000000001100100";
    s_iB       <= "00000000000000000000000000111100";
    s_iC       <= '0';
    s_nAdd_Sub <= '1';
    wait for gCLK_HPER*2;
    -- Expected output should be 
    --  100 - 60 = 40 (0x28), o_S = 40 (0x28), o_C = 0.

    -- Test Case 3:
    -- Perform an addition to set an overflow meaning after adding oC should be 1. Adding an enormous number so I am not going to convert to decimal
    s_iA <= "11111111111111111111111111110000";
    s_iB <= "00000000000000000000000000011111";
    s_iC <= '1';
    s_nAdd_Sub <= '0';
    wait for gCLK_HPER*2;
    -- Expect: 1.1^31 + 15 + 1 (carry bit) = 1.1^31 but should expect o_S = 0x0 but o_C = 1.


    -- Test Case 4:
    -- Perform an subtraction to set the value under 0, subtracting 4 - 7 = -3 or an enormous number
    s_iA <= "00000000000000000000000000000100";
    s_iB <= "00000000000000000000000000000111";
    s_iC <= '0';
    s_nAdd_Sub <= '1';
    wait for gCLK_HPER*2;
    -- Expect: 4-7 = -3 but should expect 0xFFFFFFFD

    -- Test Case 5:
    -- Perform an subtraction to set the value under 0, subtracting 6 - 7 = -1 or an enormous number
    s_iA <= "00000000000000000000000000000110";
    s_iB <= "00000000000000000000000000000111";
    s_iC <= '0';
    s_nAdd_Sub <= '1';
    wait for gCLK_HPER*2;
    -- Expect: 6-7 = -1 but should expect 0xFFFFFFFF

    s_iA <= "00000000000000000000000000000001";
    s_iB <= "00000000000000000000000000001011";
    s_iC <= '0';
    s_nAdd_Sub <= '0';
    wait for gCLK_HPER*2;

    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;