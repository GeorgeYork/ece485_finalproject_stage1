
entity reg_file is
    Port (
        clk     : in  STD_LOGIC;
        rs1     : in  STD_LOGIC_VECTOR(4 downto 0);
        rs2     : in  STD_LOGIC_VECTOR(4 downto 0);
        rd      : in  STD_LOGIC_VECTOR(4 downto 0);
        wd      : in  STD_LOGIC_VECTOR(31 downto 0);
        reg_write : in  STD_LOGIC;
        rd1     : out STD_LOGIC_VECTOR(31 downto 0);
        rd2     : out STD_LOGIC_VECTOR(31 downto 0)
    );
end reg_file;

architecture Behavioral of reg_file is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reg_write = '1' then
                regs(to_integer(unsigned(rd))) <= wd;
            end if;
        end if;
    end process;

    rd1 <= regs(to_integer(unsigned(rs1)));
    rd2 <= regs(to_integer(unsigned(rs2)));
end Behavioral;
