library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_registerbank is
end tb_registerbank;

architecture Behavioral of tb_registerbank is

signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal read_write : STD_LOGIC := '1'; --0: read, 1: wrtie (nombre con _, izquierda 0, derecha 1)
signal data_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
signal r1_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal r2_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal registern : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
signal registern2 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
signal cs: STD_LOGIC := '0';
signal cs2: STD_LOGIC := '0';
signal initial: STD_LOGIC := '0';

begin

register_bank : entity work.registerbank(registerBank) port map(
    registerN => registern,
    registerN2 => registern2,
    data_in => data_in,
    reset => reset,
    read_write => read_write,
    cs => cs,
    cs2 => cs2,
    initial => initial,
    clk => clk,
    r1_out => r1_out,
    r2_out => r2_out);

clk_generation: process
begin
    clk <= not clk after 10ns;
    wait for 10ns;
end process;

stimulus_generation: process
begin
    reset <= '1';
    data_in <= (others => '0');
    wait for 20 ns;
    reset <= '0';
    
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    cs <= '1';
    
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
    
    registern <= x"1";
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    read_write <= '1';
    data_in <= x"11111111";
    wait for 20 ns;
    
    registern <= x"0";
    read_write <= '0';
    wait for 20ns;
    
    cs2 <= '1';
    
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
    
    registern2 <= x"1";
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    read_write <= '1';
    data_in <= x"11111111";
    wait for 20 ns;
    
    registern2 <= x"0";
    read_write <= '0';
    wait for 20ns;
    
    cs <= '1';
    
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
    
    registern <= x"0";
    registern2 <= x"1";
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    read_write <= '1';
    data_in <= x"11111111";
    wait for 20 ns;
    
    registern <= x"1";
    registern2 <= x"0";
    read_write <= '0';
    wait for 20ns;
    
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
    
    registern <= x"0";
    registern2 <= x"0";
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    read_write <= '1';
    data_in <= x"11111111";
    registern <= x"1";
    wait for 20 ns;
    
    registern2 <= x"1";
    read_write <= '0';
    wait for 20ns;
    
    wait;
end process;

end Behavioral;
