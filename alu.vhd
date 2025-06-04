
entity alu is
    Port (
        a       : in  STD_LOGIC_VECTOR(31 downto 0);
        b       : in  STD_LOGIC_VECTOR(31 downto 0);
        op      : in  STD_LOGIC_VECTOR(3 downto 0);
        result  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end alu;

architecture Behavioral of alu is
begin
    process(a, b, op)
    begin
        case op is
            when "0000" => result <= std_logic_vector(signed(a) + signed(b)); -- ADD
            when others => result <= (others => '0');
        end case;
    end process;
end Behavioral;
