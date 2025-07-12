library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decoder is
end tb_decoder;

architecture Behavioral of tb_decoder is

signal input : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
signal output : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal cs: STD_LOGIC := '0';

begin

register_bank : entity work.four_bit_decoder(decoder) port map(
    cs => cs,
    input => input,
    output => output);
    
stimulus_generation: process
begin
    
    input <= x"0";
    wait for 50 ns;
    input <= x"1";
    wait for 50 ns;
    input <= x"2";
    wait for 50 ns;
    input <= x"3";
    wait for 50 ns;
    
    cs <= '1';
    
    input <= x"0";
    wait for 50 ns;
    input <= x"1";
    wait for 50 ns;
    input <= x"2";
    wait for 50 ns;
    input <= x"3";
    wait for 50 ns;
    input <= x"4";
    wait for 50 ns;
    input <= x"5";
    wait for 50 ns;
    input <= x"6";
    wait for 50 ns;
    input <= x"7";
    wait for 50 ns;
    input <= x"8";
    wait for 50 ns;
    input <= x"9";
    wait for 50 ns;
    input <= x"A";
    wait for 50 ns;
    input <= x"B";
    wait for 50 ns;
    input <= x"C";
    wait for 50 ns;
    input <= x"D";
    wait for 50 ns;
    input <= x"E";
    wait for 50 ns;
    input <= x"F";
    wait for 50 ns;
    
    wait;
end process;

end Behavioral;
