
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor_fsm is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        instr     : in  STD_LOGIC_VECTOR(31 downto 0);
        reg_data1 : in  STD_LOGIC_VECTOR(31 downto 0);
        reg_data2 : in  STD_LOGIC_VECTOR(31 downto 0);
        mem_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        alu_result: in  STD_LOGIC_VECTOR(31 downto 0);
        reg_write : out STD_LOGIC;
        mem_read  : out STD_LOGIC;
        mem_write : out STD_LOGIC;
        alu_src   : out STD_LOGIC;
        mem_to_reg: out STD_LOGIC;
        branch    : out STD_LOGIC;
        jump      : out STD_LOGIC;
        alu_op    : out STD_LOGIC_VECTOR(3 downto 0);
        pc        : out STD_LOGIC_VECTOR(31 downto 0);
        write_data: out STD_LOGIC_VECTOR(31 downto 0);
        load_addr : out STD_LOGIC  -- Custom signal for load_addr instruction
    );
end processor_fsm;

architecture Behavioral of processor_fsm is
    type state_type is (FETCH, DECODE, EXECUTE, MEMORY, WRITEBACK);
    signal state : state_type := FETCH;
    signal next_pc : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal branch_offset : STD_LOGIC_VECTOR(31 downto 0);
    signal jump_offset : STD_LOGIC_VECTOR(31 downto 0);
    signal imm : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= FETCH;
            pc <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when FETCH =>
                    state <= DECODE;
                when DECODE =>
                    -- Decode immediate values and offsets
                    imm <= std_logic_vector(signed(instr(31 downto 20)));
                    branch_offset <= std_logic_vector(signed(instr(31 downto 25) & instr(11 downto 7)));
                    jump_offset <= std_logic_vector(signed(instr(31 downto 12) & instr(11 downto 0)));
                    state <= EXECUTE;
                when EXECUTE =>
                    if load_addr = '1' then
                        write_data <= x"10000000";  -- Load base address of data memory
                    else
                        -- Normal ALU operations
                        write_data <= alu_result;
                    end if;
                    state <= MEMORY;
                when MEMORY =>
                    if mem_read = '1' then
                        write_data <= mem_data;
                    end if;
                    state <= WRITEBACK;
                when WRITEBACK =>
                    if reg_write = '1' then
                        -- Write data to register file
                    end if;
                    if branch = '1' and reg_data1 /= reg_data2 then
                        next_pc <= std_logic_vector(signed(pc) + signed(branch_offset));
                    elsif jump = '1' then
                        next_pc <= std_logic_vector(signed(pc) + signed(jump_offset));
                    else
                        next_pc <= std_logic_vector(unsigned(pc) + 4);
                    end if;
                    pc <= next_pc;
                    state <= FETCH;
            end case;
        end if;
    end process;
end Behavioral;
