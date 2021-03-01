-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_MIPS_processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MIPS processor
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O
use work.mypack.all;            -- For input array [32,32];

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_MIPS_processor is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_MIPS_processor;

architecture mixed of tb_MIPS_processor is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component MIPS_processor is
   port(i_CLK        : in  std_logic;                        -- Clock input
        i_RST        : in  std_logic;                        -- Reset input
        i_WE         : in  std_logic;                        -- Write Enabled input
        i_C          : in  std_logic;                        -- Carry input
        i_nAdd_Sub   : in  std_logic;                        -- Addition or subtraction bit
        i_ALUSrc     : in  std_logic;                        -- Register value or Immediate
        i_sRD        : in  std_logic_vector(4 downto 0);     -- Write select input
        i_sRS        : in  std_logic_vector(4 downto 0);     -- Select bits for source register
        i_sRT        : in  std_logic_vector(4 downto 0);     -- Select bits for target register
        imm          : in  std_logic_vector(31 downto 0);    -- Immdeiate data entry
        o_Q          : out std_logic_vector(31 downto 0);    -- Output from target register
        o_C          : out std_logic);                       -- Carry Output (Overflow)
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.\
signal s_iRST, s_iC, s_AddSub, s_ALUSrc, s_oC, s_iWE   : std_logic;
signal s_sRD, s_sRS, s_sRT  :  std_logic_vector(4 downto 0);
signal s_imm, s_oQ    : std_logic_vector(31 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: MIPS_processor
  port map( i_CLK  => CLK,
            i_RST  => s_iRST,
            i_WE   => s_iWE,
            i_C    => s_iC,
            i_nAdd_Sub => s_AddSub,
            i_ALUSrc   => s_ALUSrc,
            i_sRD  => s_sRD,
            i_sRS  => s_sRS,
            i_sRT  => s_sRT,
            imm    => s_imm,
            o_Q    => s_oQ,
            o_C    => s_oC);
            
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
    s_iRST <= '0';
    s_iWE  <= '1';
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    
    --Preset some values
    s_iC <= '0';
    s_iRST <= '0';
    s_sRT <= "00000";
    
    -- Test Case 1: 
    -- addi $1, $0, 1
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000001";
    s_sRD <= "00001";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x1
    --    s_oC should be 0x0

    -- Test Case 2: 
    -- addi $2, $0, 2
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000010";
    s_sRD <= "00010";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x2
    --    s_oC should be 0x0
    
    -- Test Case 3: 
    -- addi $3, $0, 3
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000011";
    s_sRD <= "00011";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x3
    --    s_oC should be 0x0

    -- Test Case 4: 
    -- addi $4, $0, 4
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000100";
    s_sRD <= "00100";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x4
    --    s_oC should be 0x0

    -- Test Case 5: 
    -- addi $5, $0, 5
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000101";
    s_sRD <= "00101";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x5
    --    s_oC should be 0x0

    -- Test Case 6: 
    -- addi $6, $0, 6
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000110";
    s_sRD <= "00110";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x6
    --    s_oC should be 0x0

    -- Test Case 7: 
    -- addi $7, $0, 7
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000000111";
    s_sRD <= "00111";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x7
    --    s_oC should be 0x0

    -- Test Case 8: 
    -- addi $8, $0, 8
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000001000";
    s_sRD <= "01000";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x8
    --    s_oC should be 0x0

    -- Test Case 9: 
    -- addi $9, $0, 9
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000001001";
    s_sRD <= "01001";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x9
    --    s_oC should be 0x0

    -- Test Case 10: 
    -- addi $10, $0, 10
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "00000000000000000000000000001010";
    s_sRD <= "01010";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xA
    --    s_oC should be 0x0

    -- Test Case 11: 
    -- add $11, $1, $2
    s_sRS <= "00001"; --Add the value $1
    s_sRT <= "00010"; --Value to be added
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "01011";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x3
    --    s_oC should be 0x0

    -- Test Case 12: 
    -- sub $12, $11, $3
    s_sRS <= "01011"; --Subtract the value $11
    s_sRT <= "00011"; --Value to be subtracted
    s_AddSub <= '1'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "01100";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x0
    --    s_oC should be 0x0

    -- Test Case 13: 
    -- add $13, $12, $4
    s_sRS <= "01100"; --Add the value in register $12
    s_sRT <= "00100"; --Value to be added
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "01101";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x4
    --    s_oC should be 0x0

    -- Test Case 14: 
    -- sub $14, $13, $5
    s_sRS <= "01101"; --Subtract the value in register $13
    s_sRT <= "00101"; --Value to subtract
    s_AddSub <= '1'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "01110";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xFFFFFFFF (-1)
    --    s_oC should be 0x0

    -- Test Case 15: 
    -- add $15, $14, $6
    s_sRS <= "01110"; --Add the value in register $14
    s_sRT <= "00110"; --Value to be added
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "01111";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x5
    --    s_oC should be 0x1

    -- Test Case 16: 
    -- sub $16, $15, $7
    s_sRS <= "01111"; --Subtract the value in register $15
    s_sRT <= "00111"; --Value to subtract by
    s_AddSub <= '1'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "10000";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xFFFFFFFE (-2)
    --    s_oC should be 0x0

    -- Test Case 17: 
    -- add $17, $16, $8
    s_sRS <= "10000"; --Add the value in register $16
    s_sRT <= "01000"; --Value to be added
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "10001";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x6
    --    s_oC should be 0x1

    -- Test Case 18: 
    -- sub $18, $17, $9
    s_sRS <= "10001"; --Subtract the value in register $17
    s_sRT <= "01001"; --Value to subtract by
    s_AddSub <= '1'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "10010";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xFFFFFFFD (-3)
    --    s_oC should be 0x0

    -- Test Case 19: 
    -- add $19, $18, $10
    s_sRS <= "10010"; --Add the value in register $18
    s_sRT <= "01010"; --Value to be added
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "10011";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x7
    --    s_oC should be 0x1

    -- Test Case 20: 
    -- addi $20, $0, -35
    s_sRS <= "00000"; --Add the value in register $0 (0x0)
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '1'; -- 1 is immediate, 0 is RT 
    s_imm <= "11111111111111111111111111100011"; -- The value -35 in binary
    s_sRD <= "10100";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xFFFFFFE3 (-35)
    --    s_oC should be 0x0

    -- Test Case 21: 
    -- add $21, $19, $20
    s_sRS <= "10011"; --Add the value in register $19
    s_sRT <= "10100"; --Value to be added
    s_AddSub <= '0'; -- 0 is add, 1 is subtract
    s_ALUSrc <= '0'; -- 1 is immediate, 0 is RT 
    s_sRD <= "10101";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xFFFFFFEA (-28)
    --    s_oC should be 0x0

    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;