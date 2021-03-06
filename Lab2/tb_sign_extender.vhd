-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_sign_extender.vhd
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
entity tb_sign_extender is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_sign_extender;

architecture mixed of tb_sign_extender is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component sign_extender is
     port(i_Signed   :  in  std_logic;
          i_Data     :  in  std_logic_vector(15 downto 0);
          o_Data     :  out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.\
signal s_iSigned   : std_logic;
signal s_iData     : std_logic_vector(15 downto 0);
signal s_oData     : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: sign_extender
  port map( i_Signed  =>  s_iSigned,
            i_Data    =>  s_iData,
            o_Data    =>  s_oData);
            
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
    -- Set signed to 1 for a signed number, i_Data = 0xFFFF (-1)
    s_iSigned <= '1';
    s_iData <= "1111111111111111";
    wait for gCLK_HPER*2;
    -- Expected output should be...
    --    s_oData = 0xFFFFFFFF (-1)

    -- Test Case 2: 
    -- Set signed to 0 for a unsigned number, i_Data = 0xFFFF (65535)
    s_iSigned <= '0';
    s_iData <= "1111111111111111";
    wait for gCLK_HPER*2;
    -- Expected output should be...
    --    s_oData = 0x0000FFFF (65535)

    -- Test Case 3: 
    -- Set signed to 1 for a signed number, i_Data = 0x0069 (105)
    s_iSigned <= '1';
    s_iData <= "0000000001101001";
    wait for gCLK_HPER*2;
    -- Expected output should be...
    --    s_oData = 0x00000069 (105)
    
    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;