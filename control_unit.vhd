
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    Port (
        opcode     : in  STD_LOGIC_VECTOR(6 downto 0);
        funct3     : in  STD_LOGIC_VECTOR(2 downto 0);
        funct7     : in  STD_LOGIC_VECTOR(6 downto 0);
        reg_write  : out STD_LOGIC;
        mem_read   : out STD_LOGIC;
        mem_write  : out STD_LOGIC;
        alu_src    : out STD_LOGIC;
        mem_to_reg : out STD_LOGIC;
        branch     : out STD_LOGIC;
        jump       : out STD_LOGIC;
        alu_op     : out STD_LOGIC_VECTOR(3 downto 0);
        load_addr  : out STD_LOGIC  -- Custom signal for load_addr instruction
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode, funct3, funct7)
    begin
        case opcode is
            when "0010011" =>  -- I-type (addi, subi)
                reg_write <= '1';
                mem_read <= '0';
                mem_write <= '0';
                alu_src <= '1';
                mem_to_reg <= '0';
                branch <= '0';
                jump <= '0';
                load_addr <= '0';
                case funct3 is
                    when "000" => alu_op <= "0000";  -- addi
                    when "001" => alu_op <= "0001";  -- subi
                    when others => alu_op <= "0000";
                end case;
            when "0110011" =>  -- R-type (add)
                reg_write <= '1';
                mem_read <= '0';
                mem_write <= '0';
                alu_src <= '0';
                mem_to_reg <= '0';
                branch <= '0';
                jump <= '0';
                load_addr <= '0';
                case funct3 is
                    when "000" =>
                        case funct7 is
                            when "0000000" => alu_op <= "0000";  -- add
                            when others => alu_op <= "0000";
                        end case;
                    when others => alu_op <= "0000";
                end case;
            when "0000011" =>  -- I-type (lw)
                reg_write <= '1';
                mem_read <= '1';
                mem_write <= '0';
                alu_src <= '1';
                mem_to_reg <= '1';
                branch <= '0';
                jump <= '0';
                load_addr <= '0';
                alu_op <= "0000";  -- add for address calculation
            when "0100011" =>  -- S-type (sw)
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '1';
                alu_src <= '1';
                mem_to_reg <= '0';
                branch <= '0';
                jump <= '0';
                load_addr <= '0';
                alu_op <= "0000";  -- add for address calculation
            when "1100011" =>  -- B-type (bne)
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '0';
                alu_src <= '0';
                mem_to_reg <= '0';
                branch <= '1';
                jump <= '0';
                load_addr <= '0';
                case funct3 is
                    when "001" => alu_op <= "0001";  -- bne
                    when others => alu_op <= "0000";
                end case;
            when "1101111" =>  -- J-type (j)
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '0';
                alu_src <= '0';
                mem_to_reg <= '0';
                branch <= '0';
                jump <= '1';
                load_addr <= '0';
                alu_op <= "0000";
            when "1111111" =>  -- Custom (load_addr)
                reg_write <= '1';
                mem_read <= '0';
                mem_write <= '0';
                alu_src <= '0';
                mem_to_reg <= '0';
                branch <= '0';
                jump <= '0';
                load_addr <= '1';  -- Activate load_addr signal
                alu_op <= "0000";
            when others =>
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '0';
                alu_src <= '0';
                mem_to_reg <= '0';
                branch <= '0';
                jump <= '0';
                load_addr <= '0';
                alu_op <= "0000";
        end case;
    end process;
end Behavioral;
