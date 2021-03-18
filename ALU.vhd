-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an Ones complementor 
-- that will negate each bit given in the single input.
--
--
-- NOTES:
-- 2/4/2020 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
  port(i_A     : in  std_logic_vector(31 downto 0);
       i_B     : in  std_logic_vector(31 downto 0);
       ALUop   : in  std_logic_vector(3 downto 0);
       o_Carry : out std_logic;
       o_Ovf   : out std_logic;
       o_Zero  : out std_logic;
       o_Q     : out std_logic_vector(31 downto 0));


end ALU;

architecture structural of ALU is

   ------------------------------------------
   -- Step 1: Instantiate all the components
   ------------------------------------------
   component add_sub_N
     port( i_C         :  in std_logic;
           i_nAdd_Sub  :  in std_logic;
           i_A         :  in std_logic_vector(31 downto 0);
           i_B         :  in std_logic_vector(31 downto 0);
           o_S         : out std_logic_vector(31 downto 0);
           o_C         : out std_logic);
   end component;

   component barrel_shift
     port(i_Data 	: in std_logic_vector(31 downto 0);
	  i_left 	: in std_logic;                     --1 for left and 0 for right 
	  i_logic	: in std_logic;                     --1 for logic (unsigned) and 0 for arithmetic (signed)
	  i_shift	: in std_logic_vector(4 downto 0);  --shift amount
	  o_Data	: out std_logic_vector(31 downto 0));
   end component;

   component c_gates_N
     port(i_A   : in  std_logic_vector(31 downto 0);
          i_B   : in  std_logic_vector(31 downto 0);
          i_Sel : in  std_logic_vector(1 downto 0);         --Chooses between and, or, xor, & nor
          o_Q   : out std_logic_vector(31 downto 0));
   end component;

--   component mux2t1_N
--     port(i_S          : in std_logic;
--          i_D0         : in std_logic_vector(31 downto 0);
--          i_D1         : in std_logic_vector(31 downto 0);
--          o_OA         : out std_logic_vector(31 downto 0));
--   end component;

   ---------------------------------------------------
   --Step 2: Create all the signals that we will need
   ---------------------------------------------------

   signal s_oAddSub   : std_logic_vector(31 downto 0);
   signal s_oBarrel   : std_logic_vector(31 downto 0);
   signal s_oCGates   : std_logic_vector(31 downto 0);
   signal s_iA_Barrel : std_logic_vector(31 downto 0);
   signal s_iShamnt   : std_logic_vector(4 downto 0);
   signal s_iAddSub   : std_logic;
   signal s_iLogic    : std_logic;

begin

  ---------------------------------------------
  --Step 3: Map all the inner componets to run
  ---------------------------------------------
  
  --Might need to extend ALUop one bit for unsigned values as well for addition and subtraction

  -- The Add Sub conponent 
  s_iAddSub <= (ALUop(3) AND ALUop(0));
  g_Add_Sub: add_sub_N
    port MAP( i_C => '0',
              i_nAdd_Sub => s_iAddSub,
              i_A => i_A,
              i_B => i_B,
              o_S => s_oAddSub,
              o_C => o_Carry);

  with ALUop select 
    s_iA_Barrel <= s_oAddSub when "1100",
                   i_A when others;

  with ALUop select 
    s_iShamnt <= "10000" when "1100", --Hard code to shift 16 when lui instruction
                 i_B(10 downto 6) when others;
 
  s_iLogic <= NOT (ALUop(1) AND ALUop(0));
  g_Barrel_Shifter: barrel_shift
    port MAP( i_Data  => s_iA_Barrel,
              i_Left  => (NOT ALUop(0)) OR (i_B(10) AND s_iLogic),
              i_logic => s_iLogic,
              i_shift => s_iShamnt,
              o_Data  => s_oBarrel);

  g_C_Gates: c_gates_N
    port MAP( i_A   => i_A,
              i_B   => i_B,
              i_Sel => ALUop(1 downto 0),
              o_Q   => s_oCGates);
              
  with ALUop select
    o_Q <= s_oBarrel when "0001", --sra
           s_oBarrel when "0010", --sll
           s_oBarrel when "0011", --sra
           s_oBarrel when "1100", --lui
           s_oCGates when "0100", --and
           s_oCGates when "0101", --or
           s_oCGates when "0110", --xor
           s_oCGates when "0111", --nor
           "0000000000000000000000000000000" & s_oAddSub(31) when "1011", --slt
           s_oAddSub when others; --add/sub & lw/sw & beq/bne

  --If o_Carry = 1 in subtraction it means same # - same #
  --BEQ zero needs to be 1 but if bne need inverse of o_Carry bit
  with ALUop select
     o_Zero <= NOT o_Carry when "1101",
               o_Carry when others;

  o_Ovf  <= '1' AND '0'; --Stil TBD

end structural;