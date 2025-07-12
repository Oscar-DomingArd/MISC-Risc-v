library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_bit_decoder is
    Port ( cs : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (15 downto 0));
end four_bit_decoder;

architecture decoder of four_bit_decoder is

begin

output(0) <= cs and not input(0) and not input(1) and not input(2) and not input(3);
output(1) <= cs and input(0) and not input(1) and not input(2) and not input(3);
output(2) <= cs and not input(0) and input(1) and not input(2) and not input(3);
output(3) <= cs and input(0) and input(1) and not input(2) and not input(3);
output(4) <= cs and not input(0) and not input(1) and input(2) and not input(3);
output(5) <= cs and input(0) and not input(1) and input(2) and not input(3);
output(6) <= cs and not input(0) and input(1) and input(2) and not input(3);
output(7) <= cs and input(0) and input(1) and input(2) and not input(3);
output(8) <= cs and not input(0) and not input(1) and not input(2) and input(3);
output(9) <= cs and input(0) and not input(1) and not input(2) and input(3);
output(10) <= cs and not input(0) and input(1) and not input(2) and input(3);
output(11) <= cs and input(0) and input(1) and not input(2) and input(3);
output(12) <= cs and not input(0) and not input(1) and input(2) and input(3);
output(13) <= cs and input(0) and not input(1) and input(2) and input(3);
output(14) <= cs and not input(0) and input(1) and input(2) and input(3);
output(15) <= cs and input(0) and input(1) and input(2) and input(3);

end decoder;
