library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.memory;
use work.registerbank;
use work.control_unit;
use work.pc;
use work.ALU;

entity misc_riscv is
  Port ( clk: in STD_LOGIC;
         reset : in STD_LOGIC;
         reset_pc : in STD_LOGIC;
         execute_write : in STD_LOGIC;
         program_data : in STD_LOGIC_VECTOR(31 downto 0));
end misc_riscv;

architecture riscv of misc_riscv is

signal instruction : std_logic_vector(31 downto 0) := (others => '0');
signal instruction_wait : std_logic_vector(31 downto 0) := (others => '0');
signal instruction_out : std_logic_vector(31 downto 0) := (others => '0');
signal reset_reg : std_logic;
signal reset_regN : std_logic;
signal cspc : std_logic;
signal cs_r1 : std_logic;
signal cs_r2 : std_logic;
signal cs_mem : std_logic;
signal rN1 : std_logic_vector(3 downto 0);
signal rN2 : std_logic_vector(3 downto 0);
signal data_r1 : std_logic_vector(31 downto 0);
signal data_r2 : std_logic_vector(31 downto 0);
signal data_mem : std_logic_vector(31 downto 0);
signal alu_result : std_logic_vector(31 downto 0);
signal data_in_regs : std_logic_vector(31 downto 0);
signal addr_pc : std_logic_vector(7 downto 0);
signal read_write_regs : std_logic;
signal read_write_mem : std_logic;
signal read_write_pc : std_logic;
signal addr: std_logic_vector(7 downto 0);
signal ow : std_logic;
signal zero : std_logic;
signal read_write_mem_prog : std_logic;
signal read_write_regs_prog : std_logic;
signal general_or_pc_reset : std_logic;

begin

reset_regN <= reset or reset_reg;

read_write_mem_prog <= read_write_mem or execute_write;

read_write_regs_prog <= read_write_regs or execute_write;

general_or_pc_reset <= reset or reset_pc;

instruction_wait <= instruction when execute_write = '0' else x"00000000";

control_unit_chip : entity control_unit port map(alu_result=>alu_result,
                                                 data_from_memory=>data_mem,
                                                 clk=>clk,
                                                 instruction=>instruction_wait,
                                                 program_memory=>execute_write,
                                                 registerN1=>rN1,
                                                 registerN2=>rN2,
                                                 cs_register1=>cs_r1,
                                                 cs_register2=>cs_r2,
                                                 cspc=>cspc,
                                                 cs_mem => cs_mem,
                                                 reset_register=>reset_reg,
                                                 read_write_regs=>read_write_regs,
                                                 read_write_mem=>read_write_mem,
                                                 read_write_pc=>read_write_pc,
                                                 data_for_register=>data_in_regs,
                                                 addr_out=>addr,
                                                 instruction_out=>instruction_out);

instruction_bank : entity memory port map(addr=>addr_pc(7 downto 0),
                                          data_in=>program_data,
                                          read_write=>read_write_mem_prog,
                                          reset=>reset,
                                          clk=>clk,
                                          initial=>'0',
                                          cs=>cspc,
                                          output=>instruction);
                                     
data_bank : entity memory port map(addr=>addr,
                                   data_in=>data_r2,
                                   read_write=>read_write_mem_prog,
                                   reset=>reset,
                                   clk=>clk,
                                   initial=>execute_write,
                                   cs=>cs_mem,
                                   output=>data_mem);

register_bank : entity registerbank port map(registerN=>rN1,
                                             registerN2=>rN2,
                                             data_in=>data_in_regs,
                                             reset=>reset_regN,
                                             read_write=>read_write_regs_prog,
                                             cs=>cs_r1,
                                             cs2=>cs_r2,
                                             clk=>clk,
                                             initial=>execute_write,
                                             r1_out=>data_r1,
                                             r2_out=>data_r2);

pc_register : entity pc port map(addr=>addr,
                                 reset=>general_or_pc_reset,
                                 read_write=>read_write_pc,
                                 clk=>clk,
                                 cs=>cspc,
                                 addr_out=>addr_pc);


alu_chip : entity ALU port map(r0=>data_r1,
                               r1=>data_r2,
                               instruction=>instruction_out,
                               output=>alu_result,
                               ow=>ow,
                               zero=>zero);

end riscv;
