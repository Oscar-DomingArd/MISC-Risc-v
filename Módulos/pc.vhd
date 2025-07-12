library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.register32bits;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity pc is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           reset : in STD_LOGIC := '0';
           read_write : in STD_LOGIC;
           clk : in STD_LOGIC;
           cs : in STD_LOGIC;
           addr_out : out STD_LOGIC_VECTOR (7 downto 0));
end pc;

architecture register_pc of pc is

signal new_addr : std_logic_vector(7 downto 0) := (others => '0');

begin

new_addr <= "00000000" when reset = '1' else
            addr when cs = '1' and read_write = '1' else
            new_addr + 4 when rising_edge(clk) and cs = '1' and read_write = '0';

addr_out <= new_addr;

end register_pc;
