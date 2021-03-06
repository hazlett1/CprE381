-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_processor.vhd
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
use work.mypack.all;  --Include the inputArray array for 31-1 mux

entity MIPS_processor is
  
  port(i_CLK        : in  std_logic;                        -- Clock input
       i_RST        : in  std_logic;                        -- Reset input
       i_WE         : in  std_logic;                        -- Write enable input
       i_C          : in  std_logic;                        -- Carry input
       i_nAdd_Sub   : in  std_logic;                        -- Addition or subtraction bit
       i_ALUSrc     : in  std_logic;                        -- Register value or Immediate
       i_sRD        : in  std_logic_vector(4 downto 0);     -- Write select input
       i_sRS        : in  std_logic_vector(4 downto 0);     -- Select bits for source register
       i_sRT        : in  std_logic_vector(4 downto 0);     -- Select bits for target register
       imm          : in  std_logic_vector(31 downto 0);    -- Immdeiate data entry
       o_Q          : out std_logic_vector(31 downto 0);    -- Output from target register
       o_C          : out std_logic);                       -- Carry Output (Overflow)

end MIPS_processor;

architecture mixed of MIPS_processor is
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

   --------------------------------------------------------
   -- Step 2: Declare all the signals that will be needed
   --------------------------------------------------------

   signal s_oQ   :  std_logic_vector(31 downto 0);
   signal s_oRT  :  std_logic_vector(31 downto 0);
   signal s_oRS  :  std_logic_vector(31 downto 0);
   signal s_oMUX :  std_logic_vector(31 downto 0);
   
begin
   --------------------------------------------------------
   -- Step 3: Map all the inner componets and ports together
   --------------------------------------------------------
   
   o_Q  <=  s_oQ;
   
   g_Reg_File: reg_file
    port map(i_CLK  =>   i_CLK,
             i_RST  =>   i_RST,
             i_WE   =>   i_WE,
             i_WS   =>   i_sRD,
             i_sRS  =>   i_sRS,
             i_sRT  =>   i_sRT,
             i_wD   =>   s_oQ,
             o_RT   =>   s_oRT,
             o_RS   =>   s_oRS);

   g_Mux1: mux2t1_N
    port map(i_S   =>   i_ALUSrc,
             i_D0  =>   s_oRT,
             i_D1  =>   imm,
             o_OA  =>   s_oMUX);

   g_Add_Sub2: add_sub_N
    port map(i_C         =>   i_C,
             i_nAdd_Sub  =>   i_nAdd_Sub,
             i_A         =>   s_oRS,
             i_B         =>   s_oMUX,
             o_S         =>   s_oQ,
             o_C         =>   o_C);
 
end mixed;