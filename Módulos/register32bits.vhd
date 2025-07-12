library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register32bits is
    Port ( dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           reset : in STD_LOGIC;
           read_write : in STD_LOGIC;
           clk : in STD_LOGIC;
           cs: in STD_LOGIC;
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end register32bits;

architecture Behavioral of register32bits is

signal data : std_logic_vector(31 downto 0) := (others => '0');

begin

data <= (others => '0') when reset = '1' else datain when rising_edge(clk) and read_write = '1' and cs = '1';
dataOut <= data when cs = '1' else (others => '0');

end Behavioral;
