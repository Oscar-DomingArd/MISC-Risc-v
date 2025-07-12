library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.memory;
entity tb_memory is
end tb_memory;

architecture Behavioral of tb_memory is

signal addr : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
signal data_in : STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');
signal read_write : STD_LOGIC:='0';
signal reset : STD_LOGIC:='0';
signal clk : STD_LOGIC:= '0';
signal cs : STD_LOGIC:='0';
signal initial : STD_LOGIC:='0';
signal output : STD_LOGIC_VECTOR (31 downto 0);

begin


memory_chip : entity memory port map(addr=>addr,
           data_in=>data_in,
           read_write=>read_write,
           reset=>reset,
           clk=>clk,
           cs=>cs,
           initial=>initial,
           output=>output);
           
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
    
    read_write <= '1';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    data_in <= x"AAAAAAAA";
    wait for 20 ns;
    
    addr <= x"04";
    read_write <= '0';
    data_in <= x"FFFFFFFF";
    wait for 20 ns;
    
    read_write <= '1';
    data_in <= x"11111111";
    wait for 20 ns;
    
    addr <= x"01";
    read_write <= '0';
    wait for 20ns;
    
    wait;
end process;

end Behavioral;
