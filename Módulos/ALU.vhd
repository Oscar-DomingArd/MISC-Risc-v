library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.all;

entity ALU is
    Port ( r0 : in STD_LOGIC_VECTOR (31 downto 0);
           r1 : in STD_LOGIC_VECTOR (31 downto 0);
           instruction : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           ow : out std_logic;
           zero: out std_logic);
end ALU;

architecture Behavioral of ALU is

signal result : std_logic_vector (31 downto 0);
signal funct3 : std_logic_vector(2 downto 0);

begin

funct3 <= instruction(14 downto 12) or "000";

--  SLT, SUB, AND, XOR, ADD, SLR, SLL
result <=   (r0 and r1) when funct3 = "111" else --AND
            (r0 xor r1) when funct3 = "100" else --XOR
            std_logic_vector(shift_right(unsigned(r0), to_integer(unsigned(r1(4 downto 0))))) when funct3 = "101" else -- SRL
            std_logic_vector(shift_left(unsigned(r0), to_integer(unsigned(r1(4 downto 0))))) when funct3 = "001" else -- SLL
            (r0 + r1) when ((funct3 = "000") and (instruction(30) = '0')) else --ADD
            (r0 - r1) when ((funct3 = "000") and (instruction(30) = '1')) else --SUB
            x"00000001" when funct3 = "010" and r0 < r1 else --SLT 1 output
            x"00000000" when funct3 = "010" and (r1 < r0 or r0 = r1); --SLT 0 output
            
output <= result;

zero <= '1' when result = x"00000000" else '0';

ow <=   '1' when r0(31) = '0' and r1(31) = '0' and result(31) = '1' and ((funct3 = "000") and (instruction(30) = '0')) else --(r0 + r1) = -
        '1' when r0(31) = '1' and r1(31) = '1' and result(31) = '0' and ((funct3 = "000") and (instruction(30) = '0')) else ---r0 + (-r1) = +
        '1' when r0(31) /= r1(31) and r1(31) = result(31) and ((funct3 = "000") and (instruction(30) = '1')) else '0'; --r0 - (-r1) = - || (-r0) - r1 = + 

end Behavioral;
