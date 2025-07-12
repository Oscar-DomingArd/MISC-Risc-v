library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.misc_riscv;

entity tb_misc_riscv2 is
end tb_misc_riscv2;

architecture Behavioral of tb_misc_riscv2 is

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
    program_data <= x"0084F1B3"; --AND r9,r8,r3 
    wait for 20ns;
    program_data <= x"00B44133"; --XOR r8,r11,r2 
    wait for 20ns;
    program_data <= x"0021D133"; --SRL r3,r2,r2
    wait for 20ns;
    program_data <= x"402000B3"; --SUB r0,r2,r1
    wait for 20ns;
    program_data <= x"0020D0B3"; --SRL r1,r2,r1
    wait for 20ns;
    program_data <= x"002081B3"; --ADD r1,r2,r3
    wait for 20ns;
    program_data <= x"0021A1B3"; --SLT r2,r3,r3
    wait for 20 ns;
    program_data <= x"00300023"; --SW r3, 00
    wait for 30ns;
    
    reset_pc <= '1';
    execute_write <= '0';
    wait for 5 ns;
    reset_pc <= '0';
    wait;
end process;


end Behavioral;
