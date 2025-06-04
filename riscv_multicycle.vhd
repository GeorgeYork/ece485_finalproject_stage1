
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity riscv_multicycle is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC
    );
end riscv_multicycle;

architecture Behavioral of riscv_multicycle is

    -- Define signals for PC, instruction, registers, etc.
    signal pc         : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instr      : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_data1  : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_data2  : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_result : STD_LOGIC_VECTOR(31 downto 0);
    signal mem_data   : STD_LOGIC_VECTOR(31 downto 0);
    signal write_data : STD_LOGIC_VECTOR(31 downto 0);
    signal opcode     : STD_LOGIC_VECTOR(6 downto 0);

    -- Control signals
    signal reg_write  : STD_LOGIC;
    signal mem_read   : STD_LOGIC;
    signal mem_write  : STD_LOGIC;
    signal alu_src    : STD_LOGIC;
    signal mem_to_reg : STD_LOGIC;
    signal branch     : STD_LOGIC;
    signal jump       : STD_LOGIC;

    component instr_mem
        Port (
            addr : in  STD_LOGIC_VECTOR(31 downto 0);
            data : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component reg_file
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
    end component;

    component alu
        Port (
            a       : in  STD_LOGIC_VECTOR(31 downto 0);
            b       : in  STD_LOGIC_VECTOR(31 downto 0);
            op      : in  STD_LOGIC_VECTOR(3 downto 0);
            result  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component data_mem
        Port (
            clk     : in  STD_LOGIC;
            addr    : in  STD_LOGIC_VECTOR(31 downto 0);
            wd      : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_read  : in  STD_LOGIC;
            mem_write : in  STD_LOGIC;
            rd      : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component processor_fsm
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            instr       : in  STD_LOGIC_VECTOR(31 downto 0);
            reg_data1   : in  STD_LOGIC_VECTOR(31 downto 0);
            reg_data2   : in  STD_LOGIC_VECTOR(31 downto 0);
            alu_result  : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_data    : in  STD_LOGIC_VECTOR(31 downto 0);
            pc          : out STD_LOGIC_VECTOR(31 downto 0);
            write_data  : out STD_LOGIC_VECTOR(31 downto 0);
            reg_write   : out STD_LOGIC;
            mem_read    : out STD_LOGIC;
            mem_write   : out STD_LOGIC;
            alu_src     : out STD_LOGIC;
            mem_to_reg  : out STD_LOGIC;
            branch      : out STD_LOGIC;
            jump        : out STD_LOGIC
        );
    end component;

begin

    -- Instantiate components here (Instruction Memory, Register File, ALU, etc.)
    instr_mem_inst: instr_mem
        port map (
            addr => pc,
            data => instr
        );

    reg_file_inst: reg_file
        port map (
            clk => clk,
            rs1 => instr(19 downto 15),
            rs2 => instr(24 downto 20),
            rd => instr(11 downto 7),
            wd => write_data,
            reg_write => reg_write,
            rd1 => reg_data1,
            rd2 => reg_data2
        );

    alu_inst: alu
        port map (
            a => reg_data1,
            b => (others => '0'), -- ALU input B will be selected by alu_src signal
            op => (others => '0'), -- ALU operation will be set by alu_control_unit
            result => alu_result
        );

    data_mem_inst: data_mem
        port map (
            clk => clk,
            addr => alu_result,
            wd => reg_data2,
            mem_read => mem_read,
            mem_write => mem_write,
            rd => mem_data
        );

    fsm_inst: processor_fsm
        port map (
            clk => clk,
            reset => reset,
            instr => instr,
            reg_data1 => reg_data1,
            reg_data2 => reg_data2,
            alu_result => alu_result,
            mem_data => mem_data,
            pc => pc,
            write_data => write_data,
            reg_write => reg_write,
            mem_read => mem_read,
            mem_write => mem_write,
            alu_src => alu_src,
            mem_to_reg => mem_to_reg,
            branch => branch,
            jump => jump
        );

end Behavioral;
