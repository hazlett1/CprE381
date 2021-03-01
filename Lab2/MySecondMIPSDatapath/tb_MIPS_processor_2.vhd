-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_MIPS_processor_2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the second MIPS processor
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
entity tb_MIPS_processor_2 is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_MIPS_processor_2;

architecture mixed of tb_MIPS_processor_2 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component MIPS_processor_2 is
  port(i_CLK        : in  std_logic;                        -- Clock input
       i_Control    : in  std_logic_vector(7 downto 0);     -- Control input 0 RST, i_WE 1, 2 i_C, 3 Add_Sub, 4 ALUSrc, 5 i_Signed, 6 Mem Write/Read, 7 MemToReg
       i_sRD        : in  std_logic_vector(4 downto 0);     -- Write slect bits
       i_sRS        : in  std_logic_vector(4 downto 0);     -- Select bits for source register
       i_sRT        : in  std_logic_vector(4 downto 0);     -- Select bits for target register
       imm          : in  std_logic_vector(15 downto 0);    -- Immdeiate data entry
       o_Q          : out std_logic_vector(31 downto 0);    -- Output from target register
       o_C          : out std_logic);                       -- Carry Output (Overflow)
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_oC : std_logic;
signal s_sRD, s_sRS, s_sRT  :  std_logic_vector(4 downto 0);
signal s_iControl : std_logic_vector(7 downto 0);
signal s_imm : std_logic_vector(15 downto 0);
signal s_oQ    : std_logic_vector(31 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  mips_mem: MIPS_processor_2
  port map( i_CLK     => CLK,
            i_Control => s_iControl,
            i_sRD     => s_sRD,
            i_sRS     => s_sRS,
            i_sRT     => s_sRT,
            imm       => s_imm,
            o_Q       => s_oQ,
            o_C       => s_oC);
            
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
    
    --Preset some values
    s_iControl <= "00000000";
    s_sRT <= "00000";
    
    -- Test Case 1: 
    -- addi $25, $0, 0
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_iControl <= "00110010";
    s_imm <= "0000000000000000";
    s_sRD <= "11001";
    wait for gCLK_HPER*2;
    -- Expected output after 1 positive edge clocks should be...
    --    s_oQ should be 0x0
    --    s_oC should be 0x0

    -- Test Case 2: 
    -- addi $26, $0, 256
    s_sRS <= "00000"; --Add the value in register $0 (0x0) to the immediate
    s_iControl <= "00110010"; 
    s_imm <= "0000000100000000";
    s_sRD <= "11010";
    wait for gCLK_HPER*2;
    -- Expected output after 1 positive edge clocks should be...
    --    s_oQ should be 0x100
    --    s_oC should be 0x0
    
    -- Test Case 3: 
    -- lw $1, 0($25) = addi $1, $25, 0
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000000";
    s_sRD <= "00001";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x1
    --    s_oC should be 0x0

    -- Test Case 4: 
    -- lw $2, 4($2) = addi $2, $2, 4/4=1
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000001";
    s_sRD <= "00010";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x2
    --    s_oC should be 0x0

    -- Test Case 5: 
    -- add $1, $1, $2
    s_sRS <= "00001"; --Add the value in register $0 to the immediate
    s_sRT <= "00010"; -- Add $2 to $1
    s_sRD <= "00001";
    s_iControl <= "00100010";
    wait for gCLK_HPER*2;
    -- Expected output after 1 positive edge clocks should be...
    --    s_oQ should be 0x3
    --    s_oC should be 0x0

    -- Test Case 6: 
    -- sw $1, 0($26) = addi $26, $26, 0
    s_sRS <= "11010"; --Add the value in register $26 to the immediate
    s_sRT <= "00001"; -- Stores the register $1 into memory
    s_iControl <= "11110000"; 
    s_imm <= "0000000000000000";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to write the value to memory
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x3
    --    s_oC should be 0x0

    -- Test Case 7: 
    -- lw $2, 8($25) = addi $2, $25, 8/4=2
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000010";
    s_sRD <= "00010";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x3
    --    s_oC should be 0x0

    -- Test Case 8: 
    -- add $1, $1, $2
    s_sRS <= "00001"; --Add the value in register $1 to the other reg
    s_sRT <= "00010";
    s_iControl <= "00100010"; 
    s_sRD <= "00001";
    wait for gCLK_HPER*2;
    -- Expected output after 1 positive edge clocks should be...
    --    s_oQ should be 0x6
    --    s_oC should be 0x0

    -- Test Case 9: 
    -- sw $1, 4($26) = addi $26, $26, 4/4=1
    s_sRS <= "11010"; --Add the value in register $26 to the immediate
    s_sRT <= "00001"; -- Stores Register $1 into memory
    s_iControl <= "11110000"; 
    s_imm <= "0000000000000001";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x6
    --    s_oC should be 0x0

    -- Test Case 10: 
    -- lw $2, 12($25) = addi $2, $25, 12/4=3
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000011";
    s_sRD <= "00010";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x4
    --    s_oC should be 0x0

    -- Test Case 11: 
    -- add $1, $1, $2
    s_sRS <= "00001"; --Add the value $1
    s_sRT <= "00010"; --Value to be added
    s_iControl <= "00100010";
    s_sRD <= "00001";
    wait for gCLK_HPER*2;
    -- Expected output after 1 positive edge clocks should be...
    --    s_oQ should be 0xA
    --    s_oC should be 0x0

    -- Test Case 12: 
    -- sw $1, 8($26) = addi $26, $26, 8/4=2
    s_sRS <= "11010"; --Add the value in register $26 to the immediate
    s_sRT <= "00001"; -- Stores Register $1 into memory
    s_iControl <= "11110000"; 
    s_imm <= "0000000000000010";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0xA
    --    s_oC should be 0x0

    -- Test Case 13: 
    -- lw $2, 16($25) = addi $2, $25, 16/4=4
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000100";
    s_sRD <= "00010";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x5
    --    s_oC should be 0x0

    -- Test Case 14: 
    -- add $1, $1, $2
    s_sRS <= "00001"; --Add value $1
    s_sRT <= "00010"; --To value $2
    s_iControl <= "00100010"; 
    s_sRD <= "00001";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0xF
    --    s_oC should be 0x0

    -- Test Case 15: 
    -- sw $1, 12($26) = addi $26, $26, 12/4=3
    s_sRS <= "11010"; --Add the value in register $26 to the immediate
    s_sRT <= "00001"; -- Stores Register $1 into memory
    s_iControl <= "11110000"; 
    s_imm <= "0000000000000011";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0xF
    --    s_oC should be 0x0

    -- Test Case 16: 
    -- lw $2, 20($25) = addi $2, $25, 20/4=5
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000101";
    s_sRD <= "00010";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x6
    --    s_oC should be 0x0

    -- Test Case 18: 
    -- add $1, $1, $2
    s_sRS <= "00001"; --Add value $1
    s_sRT <= "00010"; --To value $2
    s_iControl <= "00100010"; 
    s_sRD <= "00001";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x15
    --    s_oC should be 0x0

    -- Test Case 19: 
    -- sw $1, 16($26) = addi $26, $26, 16/4=4
    s_sRS <= "11010"; --Add the value in register $26 to the immediate
    s_sRT <= "00001"; -- Stores Register $1 into memory
    s_iControl <= "11110000"; 
    s_imm <= "0000000000000100";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x15
    --    s_oC should be 0x0

    -- Test Case 20: 
    -- lw $2, 24($25) = addi $2, $25, 24/4=6
    s_sRS <= "11001"; --Add the value in register $25 to the immediate
    s_iControl <= "10110000"; 
    s_imm <= "0000000000000110";
    s_sRD <= "00010";
    wait for gCLK_HPER*2; --One positive edge to read the value from the register
    wait for gCLK_HPER*2; --One positive edge to read the value from memory
    s_iControl <= "10110010";
    wait for gCLK_HPER*2; --One positive edge to set the value from memory to the register
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x7
    --    s_oC should be 0x0

    -- Test Case 21: 
    -- add $1, $1, $2
    s_sRS <= "00001"; --Add value $1
    s_sRT <= "00010"; --To value $2
    s_iControl <= "00100010"; 
    s_sRD <= "00001";
    wait for gCLK_HPER*2;
    -- Expected output after 3 positive edge clocks should be...
    --    s_oQ should be 0x1C
    --    s_oC should be 0x0
    
    -- Test Case 22: 
    -- addi $27, $0, 512
    s_sRS <= "00001"; --Add value $1
    s_iControl <= "00110010"; 
    s_imm <= "0000001000000000";
    s_sRD <= "11011";
    wait for gCLK_HPER*2;
    -- Expected output after 1 positive edge clocks should be...
    --    s_oQ should be 0x200 
    --    s_oC should be 0x0

    -- Test Case 22: 
    -- sw $1, -4($27) = subi $27, $27, 4/4=1
    s_sRS <= "11011"; --Add the value in register $26 to the immediate
    s_sRT <= "00001"; -- Stores Register $1 into memory
    s_iControl <= "11111000"; 
    s_imm <= "0000000000000001";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expected output after 2 positive edge clocks should be...
    --    s_oQ should be 0x
    --    s_oC should be 0x0

    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;