-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_alu.vhd
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
entity tb_alu is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_alu;

architecture mixed of tb_alu is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component ALU is
  port(i_A     : in  std_logic_vector(31 downto 0);
       i_B     : in  std_logic_vector(31 downto 0);
       ALUop   : in  std_logic_vector(3 downto 0);
       o_Carry : out std_logic;
       o_Ovf   : out std_logic;
       o_Zero  : out std_logic;
       o_Q     : out std_logic_vector(31 downto 0));   
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iA, s_iB, s_oQ : std_logic_vector(31 downto 0);
signal s_ALUop : std_logic_vector(3 downto 0);
signal s_oCarry, s_oOvf, s_oZero : std_logic;



begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: ALU
  port map( i_A     => s_iA,
            i_B     => s_iB,
            ALUop   => s_ALUop,
            o_Carry => s_oCarry,
            o_Ovf   => s_oOvf,
            o_Zero  => s_oZero,
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
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    
    --Test Case 1
    --Add command
    s_ALUop <= "1000";
    s_iA <= x"00000001";
    s_iB <= x"00000001";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x2
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 2
    --Sub command
    s_ALUop <= "1001";
    s_iA <= x"0000000F";
    s_iB <= x"00000005";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xA
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 2
    --Sub command
    s_ALUop <= "1001";
    s_iA <= x"00000003";
    s_iB <= x"FFFFFFFC";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 3-(-4) = 7
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 3
    --sll command *NOTE barrel shifter grabs 10 downto 6 because in R-Type shamnt is INS[10-6]*
    s_ALUop <= "0010";
    s_iA <= x"0000000F";
    s_iB <= x"00000100";  -- 0x100 sets shamnt = 0x4 (Simulating R-Type Instruction)
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xF0
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 4
    --srl command *NOTE barrel shifter grabs 10 downto 6 because in R-Type shamnt is INS[10-6]*
    s_ALUop <= "0001";
    s_iA <= x"0000000F";
    s_iB <= x"00000080";  -- 0x80 sets shamnt = 0x2 (Simulating R-Type Instruction)
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x3
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 5
    --sra command (POSITIVE) *NOTE barrel shifter grabs 10 downto 6 because in R-Type shamnt is INS[10-6]*
    s_ALUop <= "0011";
    s_iA <= x"000000FF";
    s_iB <= x"00000100";  -- 0x100 sets shamnt = 0x4 (Simulating R-Type Instruction)  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x0xF
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 6
    --sra command (NEGATIVE) *NOTE barrel shifter grabs 10 downto 6 because in R-Type shamnt is INS[10-6]*
    s_ALUop <= "0011";
    s_iA <= x"000000FF";
    s_iB <= x"00000700";  -- 0x700 sets shamnt = -0x4 or 0x1C (Simulating R-Type Instruction)  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xFF0
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 7
    --and command
    s_ALUop <= "0100";
    s_iA <= x"000000F7";
    s_iB <= x"0000008F";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x87
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 8
    --or command
    s_ALUop <= "0101";
    s_iA <= x"000000AB";
    s_iB <= x"00000073";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xFB
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 9
    --xor command
    s_ALUop <= "0110";
    s_iA <= x"000000F7";
    s_iB <= x"0000008F";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x78
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 11
    --nor command
    s_ALUop <= "0111";
    s_iA <= x"000000F7";
    s_iB <= x"0000008F";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xFFFFFF00
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 12
    --lui command
    s_ALUop <= "1100";
    s_iA <= x"00000000";
    s_iB <= x"00004004";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x40040000
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 13
    --slt command
    s_ALUop <= "1011";
    s_iA <= x"00000003";
    s_iB <= x"00000004";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x1
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 14
    --slt command
    s_ALUop <= "1011";
    s_iA <= x"00000004";
    s_iB <= x"00000004";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0x0
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 15
    --lw command *NOTE lw only needs to add the values*
    s_ALUop <= "1010";
    s_iA <= x"00000AB0";
    s_iB <= x"0000000C";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xABC
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

    --Test Case 16
    --sw command *NOTE sw only needs to add the values*
    s_ALUop <= "1010";
    s_iA <= x"00000CA0";
    s_iB <= x"0000000B";  
    wait for gCLK_HPER*2;
    --Expected output
    --  -o_Q     = 0xCAB
    --  -o_Carry = 0
    --  -o_Ovf   = 0
    --  -o_Zero  = 0

  end process;

end mixed;