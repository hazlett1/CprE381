-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_fetch_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the fetch logic
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
entity tb_fetch_logic is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_fetch_logic;

architecture mixed of tb_fetch_logic is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component FetchLogic is
    port(	i_PC   : in std_logic_vector(31 downto 0);  -- Normal shifted by 4 or standard value
		i_BEQ  : in std_logic_vector(31 downto 0); -- BEQ value
		i_Jump : in std_logic_vector(31 downto 0); -- JUMP VALUE
		i_CLK  : in std_logic;
		i_RST  : in std_logic;
		equals : in std_logic;
		branch : in std_logic;
		jump   : in std_logic;
		pcWE   : in std_logic;
		o_PCPlus   : out std_logic_vector(31 downto 0);
		o_Address  : out std_logic_vector(31 downto 0)); -- Output from memory
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_PC, s_BEQ, s_iJump, s_oPC, s_oAddress      : std_logic_vector(31 downto 0);
signal s_RST, s_equals, s_branch, s_jump, s_pcWE   : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: FetchLogic
  port map( i_PC => s_PC,
            i_BEQ => s_BEQ,
            i_Jump => s_iJump,
            i_CLK => CLK,
            i_RST => s_RST,
            equals => s_equals,
            branch => s_branch,
            jump => s_jump,
            pcWE => s_pcWE,
            o_PCPlus => s_oPC,
            o_Address => s_oAddress);
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
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    s_RST <= '0';
    s_pcWE <= '1';

    -- Test Case 1: 
    -- 
    s_PC <= x"40041234";
    s_BEQ <= x"00000000";
    s_iJump <= x"00000000";
    s_equals <= '0';
    s_branch <= '0';
    s_Jump <= '0';
    wait for gCLK_HPER*2;


    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;