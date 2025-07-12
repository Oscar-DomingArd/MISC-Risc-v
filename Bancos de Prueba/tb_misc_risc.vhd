library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.misc_riscv;
entity tb_misc_risc is
end tb_misc_risc;

architecture Behavioral of tb_misc_risc is

signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal reset_pc : std_logic;
signal execute_write : std_logic;
signal program_data : std_logic_vector(31 downto 0);

begin

miscriscv : entity misc_riscv port map
(clk=>clk, reset=>reset, reset_pc=>reset_pc, execute_write=>execute_write, program_data=> program_data);
clk_generation: process
begin
    clk <= not clk after 10ns;
    wait for 10ns;
end process;
stimulus_generation: process
begin
    program_data <= x"00000000";
    reset <= '1';
    reset_pc <= '1';
    execute_write <= '1';
    wait for 10ns;
    
    reset <= '0';
    reset_pc <= '0';
    program_data <= x"0084F0B3"; --AND r9,r8,r1 
    wait for 20ns;
    program_data <= x"00A0C133"; --XOR r1,r10,r2
    wait for 20ns;
    program_data <= x"005110B3"; --SLL r2,r5,r1
    wait for 20ns;
    program_data <= x"0040D1B3"; --SRL r1,r4,r3
    wait for 20ns;
    program_data <= x"402180B3"; --SUB r2,r3,r1
    wait for 20ns;
    program_data <= x"003101B3"; --ADD r2,r3,r3
    wait for 20ns;
    program_data <= x"003120B3"; --SLT r2,r3,r1
    wait for 20 ns;
    program_data <= x"00300023"; --SW r3, 00
    wait for 20 ns;
    program_data <= x"00002103"; --LW r2, 00
    wait for 20 ns;
    program_data <= x"000000EF"; --JAL 00
    wait for 30ns;
    
    reset_pc <= '1';
    execute_write <= '0';
    wait for 5 ns;
    reset_pc <= '0';
    wait;
end process;


end Behavioral;
