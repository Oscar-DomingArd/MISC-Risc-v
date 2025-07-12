library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_register32bits is
end tb_register32bits;

architecture Behavioral of tb_register32bits is

signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal read_write : STD_LOGIC := '0'; --0: read, 1: wrtie (nombre con _, izquierda 0, derecha 1)
signal data_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
signal data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal cs: STD_LOGIC := '0';

begin

register32bits : entity work.register32bits(Behavioral) port map(
    dataIn => data_in,
    reset => reset,
    read_write => read_write,
    cs => cs,
    clk => clk,
    dataOut => data_out);

clk_generation: process
begin
    clk <= not clk after 10ns;
    wait for 10ns;
end process;

stimulus_generation: process
begin
    read_write <= '0';
    reset <= '1';
    data_in <= (others => '0');
    wait for 20 ns;
    reset <= '0';
    
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    read_write <= '1';
    wait for 20 ns;
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    cs <= '1';
    read_write <= '0';
    reset <= '1';
    data_in <= (others => '0');
    wait for 20 ns;
    reset <= '0';
    
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    read_write <= '1';
    wait for 20 ns;
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    wait;
end process;

end Behavioral;
