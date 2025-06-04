
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_mem is
    Port (
        addr : in  STD_LOGIC_VECTOR(31 downto 0);
        data : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instr_mem;

architecture Behavioral of instr_mem is
    type mem_type is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : mem_type := (
        0 => x"00000093", -- addi x5, x0, 9
        1 => x"10000093", -- load_addr x6, array (custom instruction)
        2 => x"00003083", -- lw x7, 0(x6)
        3 => x"00403093", -- addi x6, x6, 4
        4 => x"00003103", -- lw x10, 0(x6)
        5 => x"00a03033", -- add x7, x10, x7
        6 => x"00100093", -- subi x5, x5, 1
        7 => x"00000063", -- bne x5, x0, loop
        8 => x"0000006f", -- j done
        others => (others => '0')
    );
begin
    data <= mem(to_integer(unsigned(addr(9 downto 2))));
end Behavioral;
