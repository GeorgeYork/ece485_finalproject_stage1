
entity data_mem is
    Port (
        clk     : in  STD_LOGIC;
        addr    : in  STD_LOGIC_VECTOR(31 downto 0);
        wd      : in  STD_LOGIC_VECTOR(31 downto 0);
        mem_read  : in  STD_LOGIC;
        mem_write : in  STD_LOGIC;
        rd      : out STD_LOGIC_VECTOR(31 downto 0)
    );
end data_mem;

architecture Behavioral of data_mem is
    type mem_type is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : mem_type := (
        0 => x"00000005", -- 0x5
        1 => x"00000004", -- 0x4
        2 => x"00000010", -- 0x10
        3 => x"00000003", -- 0x3
        4 => x"00000012", -- 0x12
        5 => x"00000001", -- 0x1
        6 => x"00000007", -- 0x7
        7 => x"00000004", -- 0x4
        8 => x"00000008", -- 0x8
        9 => x"00000002", -- 0x2
        others => (others => '0')
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                mem(to_integer(unsigned(addr(9 downto 2)) - 64)) <= wd;
            end if;
        end if;
    end process;

    rd <= mem(to_integer(unsigned(addr(9 downto 2)) - 64)) when mem_read = '1' else (others => '0');
end Behavioral;
