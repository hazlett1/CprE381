-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- AddSub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

  entity FetchLogic is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(	i_PC : in std_logic_vector(N-1 downto 0);


		o_PCPlus   : out std_logic_vector(N-1 downto 0);
		o_Address  : out std_logic_vector(N-1 downto 0););
  end AddSub;


architecture structural of FetchLogic is


--reg
component reg_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.

  port(i_CLK        : in  std_logic;                        -- Clock input
       i_RST        : in  std_logic;                        -- Reset input
       i_WE         : in  std_logic;                        -- Write enable input
       i_D          : in  std_logic_vector(N-1 downto 0);   -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));
end component;


--mem
component mem is
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);
	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
  end component;

--adder
component full_adder is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(	i_vC         :  in std_logic;
        i_vA         :  in std_logic_vector(N-1 downto 0);
        i_vB         :  in std_logic_vector(N-1 downto 0);
        o_vS         : out std_logic_vector(N-1 downto 0);
        o_vC         : out std_logic);
end component;


--Reg_N signal
signal s_o_reg_N : std_logic_vector(N-1 downto 0);

--Temporarily Never Use signal
signal s_neverUse : std_logic_vector(N-1 downto 0);

--Temporarily Never Use signal
signal s_neverUseCarry : std_logic;



--Port Mapping:
begin




--LEVEL 1
 ---------------------------------------------------------------------------
--PC Register
 ---------------------------------------------------------------------------
  PC: reg_N
    port MAP(i_CLK		  => i_CLK,
	     i_RST                => i_RST,
             data                 => i_PC,
             i_WE                 => '1',
	     i_D                  => i_PC,
             o_Q                  => s_o_reg_N );

   -- NOTE: NOT SURE ABOUT DATA OR I_WE



--LEVEL 2
 ---------------------------------------------------------------------------
-- PC + 4 && PC -> Memory
 ---------------------------------------------------------------------------

 meme: mem
    port MAP(clk		=> i_CLK,
	     addr               => s_o_reg_N,
             data               => s_neverUse,
             we                 => '0',
             q                  => o_Address);





  Adder1: Adder
    port MAP(i_vC               => s_o_reg_N,
             i_vA               => 4,
             i_vB               => '0',   
	     o_vS      		=> o_PCPlus,
	     o_vC		=> s_neverUseCarry);


end component;




end structural;
