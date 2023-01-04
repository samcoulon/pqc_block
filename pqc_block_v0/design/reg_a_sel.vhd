--------------------------------------------------------------------------------------------------------------------------
--  Project : pqc_block
--  File    : reg_a_sel.vhd
--  Author  : Sam Coulon
--  Purpose : The purpose of this file is to...
--            1) Accept and register a_sel values (log2(N_SIZE)-bit values)
--------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.globals_pkg.all;

entity reg_a_sel is
    port (
        clk   : in    std_logic;
        rst   : in    std_logic;  
        ena   : in    std_logic;

        d     : in    std_logic_vector(COUNTER_SIZE_A_SEL-1 downto 0);

        q     : out   std_logic_vector(COUNTER_SIZE_A_SEL-1 downto 0)
    );
end entity;

architecture rtl of reg_a_sel is 
begin
    process(clk)
	begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                q <= (others => '0');    
            else
                if (ena = '1') then
                    q <= d;		 
                end if; 
            end if;
	  	end if;
	end process;
end rtl;

