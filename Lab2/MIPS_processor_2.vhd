-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_processor_2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered MIPS register
-- file
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_processor_2 is
  
  port(i_CLK        : in  std_logic;                        -- Clock input
       i_Control    : in  std_logic_vector(7 downto 0);     -- Control input 0 RST, i_WE 1, 2 i_C, 3 Add_Sub, 4 ALUSrc, 5 i_Signed, 6 Mem Write/Read, 7 MemToReg
       i_sRD        : in  std_logic_vector(4 downto 0);     -- Write slect bits
       i_sRS        : in  std_logic_vector(4 downto 0);     -- Select bits for source register
       i_sRT        : in  std_logic_vector(4 downto 0);     -- Select bits for target register
       imm          : in  std_logic_vector(15 downto 0);    -- Immdeiate data entry
       o_Q          : out std_logic_vector(31 downto 0);    -- Output from target register
       o_C          : out std_logic);                       -- Carry Output (Overflow)

end MIPS_processor_2;

architecture mixed of MIPS_processor_2 is
   ---------------------------------------------------
   -- Step 1 initialize all the components to be used
   ---------------------------------------------------

   component reg_file is
     port(i_CLK        : in  std_logic;                        -- Clock input
          i_RST        : in  std_logic;                        -- Reset input
          i_WE         : in  std_logic;                        -- Write enabled input
          i_WS         : in  std_logic_vector(4 downto 0);     -- Write select input
          i_sRS        : in  std_logic_vector(4 downto 0);     -- Select bits for source register
          i_sRT        : in  std_logic_vector(4 downto 0);     -- Select bits for target register
          i_wD         : in  std_logic_vector(31 downto 0);    -- Data value input
          o_RT         : out std_logic_vector(31 downto 0);    -- Output from target register
          o_RS         : out std_logic_vector(31 downto 0));   -- Output from source register
   end component;

   component add_sub_N is
      port(i_C         :  in std_logic;
           i_nAdd_Sub  :  in std_logic;
           i_A         :  in std_logic_vector(31 downto 0);
           i_B         :  in std_logic_vector(31 downto 0);
           o_S         : out std_logic_vector(31 downto 0);
           o_C         : out std_logic);

   end component;

   component mux2t1_N is
     port(i_S          : in std_logic;
          i_D0         : in std_logic_vector(31 downto 0);
          i_D1         : in std_logic_vector(31 downto 0);
          o_OA         : out std_logic_vector(31 downto 0));
   end component;

   component sign_extender is 
     port(i_Signed   :  in  std_logic;
          i_Data     :  in  std_logic_vector(15 downto 0);
          o_Data     :  out std_logic_vector(31 downto 0));
   end component;

   component mem is
     port(clk		: in std_logic;
	  addr	        : in std_logic_vector(9 downto 0);
	  data	        : in std_logic_vector(31 downto 0);
	  we		: in std_logic := '1';
	  q		: out std_logic_vector(31 downto 0));
   end component;

   --------------------------------------------------------
   -- Step 2: Declare all the signals that will be needed
   --------------------------------------------------------

   signal s_oQ   :  std_logic_vector(31 downto 0);
   signal s_oRT  :  std_logic_vector(31 downto 0);
   signal s_oRS  :  std_logic_vector(31 downto 0);
   signal s_oMUX :  std_logic_vector(31 downto 0);
   signal s_imm32 : std_logic_vector(31 downto 0);
   signal s_oALU :  std_logic_vector(31 downto 0);
   signal s_oMem :  std_logic_vector(31 downto 0);
   
begin
   --------------------------------------------------------
   -- Step 3: Map all the inner componets and ports together
   --------------------------------------------------------
   
   o_Q  <=  s_oQ;
   
   g_Reg_File: reg_file
    port map(i_CLK  =>   i_CLK,
             i_RST  =>   i_Control(0), --i_Control(0) = RST
             i_WE   =>   i_Control(1), --i_Control(1) = WE
             i_WS   =>   i_sRD,
             i_sRS  =>   i_sRS,
             i_sRT  =>   i_sRT,
             i_wD   =>   s_oQ,
             o_RT   =>   s_oRT,
             o_RS   =>   s_oRS);

   g_Sign_Extend: sign_extender
     port map(i_Signed  =>  i_Control(5), --i_Control(5) = i_Signed
              i_Data    =>  imm,
              o_Data    =>  s_imm32);

   g_Mux_ALU: mux2t1_N
    port map(i_S   =>   i_Control(4), --i_Control(4) = i_ASUSrc
             i_D0  =>   s_oRT,
             i_D1  =>   s_imm32,
             o_OA  =>   s_oMUX);

   g_Add_Sub_ALU: add_sub_N
    port map(i_C         =>   i_Control(2), --i_Control(2) = i_C
             i_nAdd_Sub  =>   i_Control(3), --i_Control(3) = i_Add_Sub
             i_A         =>   s_oRS,
             i_B         =>   s_oMUX,
             o_S         =>   s_oALU,
             o_C         =>   o_C);

   g_Mem: mem
     port map(clk   =>  i_CLK,
              addr  =>  s_oALU(9 downto 0),
              data  =>  s_oRT,
              we    =>  i_Control(6), --i_Control(6) = Mem Write/Read
              q     =>  s_oMem);
 
   g_Mux_MEM: mux2t1_N
     port map(i_S   =>   i_Control(7), --i_Control(7) = MemToReg
              i_D0  =>   s_oALU,
              i_D1  =>   s_oMem,
              o_OA  =>   s_oQ);
end mixed;