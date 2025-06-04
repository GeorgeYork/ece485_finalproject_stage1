
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_control_unit is
    Port (
        funct3 : in  STD_LOGIC_VECTOR(2 downto 0);
        funct7 : in  STD_LOGIC_VECTOR(6 downto 0);
        alu_op : out STD_LOGIC_VECTOR(3 downto 0)
    );
end alu_control_unit;

architecture Behavioral of alu_control_unit is
begin
    process(funct3, funct7)
    begin
        case funct3 is
            when "000" =>  -- ADD and SUB
                if funct7 = "0000000" then
                    alu_op <= "0000";  -- ADD
                elsif funct7 = "0100000" then
                    alu_op <= "0001";  -- SUB
                else
                    alu_op <= "1111";  -- Undefined
                end if;
            when "001" =>  -- SUBI
                alu_op <= "0001";  -- SUB
            when others =>
                alu_op <= "1111";  -- Undefined
        end case;
    end process;
end Behavioral;
