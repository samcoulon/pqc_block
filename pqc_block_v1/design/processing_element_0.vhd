--------------------------------------------------------------------------------------------------------------------------
--  Project : pqc_block
--  File    : processing_element_0.vhd
--  Author  : Sam Coulon
--  Purpose : The purpose of this file is to...
--            1) Accept a_vector and B value
--            2) Multiply a_vector(0..ROWS-1) and B value to produce C value
--            3) Register C_out
--            4) Perform signed shift to find next a_vector using a_sel as index to invert
--            5) Register a_sel_out and A_out (new a_vector)
--------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.globals_pkg.all;

entity processing_element_0 is
    port (
        clk         : in    std_logic;
        rst         : in    std_logic;
        ena         : in    std_logic;

        a_sel_in    : in    std_logic_vector(COUNTER_SIZE_A_SEL-1 downto 0);
        A_in        : in    a_vector;
        B_in        : in    std_logic_vector(7 downto 0);

        a_sel_out   : out   std_logic_vector(COUNTER_SIZE_A_SEL-1 downto 0);
        A_out       : out   a_vector;
        C_out       : out   c_section
    );
end entity;

architecture rtl of processing_element_0 is

    signal a_nxt    : a_vector;
    signal a_col    : a_section;
    signal c_mult   : c_section;

begin

    -- Select top ROWS number elements for MULT
    A_COL_GEN : for i in 0 to ROWS-1 generate
        a_col(i) <= A_in(i);
    end generate A_COL_GEN;

    -- With A(n), determine A(n+1) -> a_nxt
    SHIFT_A :   entity work.signed_shift_dynamic(rtl)
        port map(
            a_sel_in,
            A_in,

            a_nxt
        );

    -- Multiply AxB -> c_mult
    MULT :      entity work.multiplier(rtl)
        port map(
            a_col,
            B_in,

            c_mult
        );

    -- Register A output -> A_nxt
    REG_A_OUT :   entity work.reg_a_vec(rtl)
        port map(
            clk,
            rst,
            ena,

            a_nxt,

            A_out
        );

    -- Pass a_sel to next PE
    REG_A_SEL :   entity work.reg_a_sel(rtl)
        port map(
            clk,
            rst,
            ena,
            
            a_sel_in,

            a_sel_out
        );

    -- Register C output -> c_out
    REG_C_OUT :   entity work.reg_c_sec(rtl)
        port map(
            clk,
            rst,
            ena,

            c_mult,

            C_out
        );

end rtl;