library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.all;
use work.ALU;

entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is

    signal r0,r1 : std_logic_vector(31 downto 0) := (others => '1');
    signal output : std_logic_vector(31 downto 0);
    signal op : std_logic_vector (31 downto 0) := (others => '1');
    signal ow, zero : std_logic;
    
begin

alu1 : entity ALU port map(r0=>r0,r1=>r1,instruction=>op,output=>output,ow=>ow,zero=>zero);

stimulus_generation: process
begin
    
    op <= x"00007033"; -- AND
    r0 <= x"FFFFFFFF";
    r1 <= x"AAAAAAAA";
    wait for 5 ns;
    
    r0 <= x"00000000";
    wait for 5 ns;
    
    op <= x"00004033"; -- XOR
    r0 <= x"FFFFFFFF";
    r1 <= x"AAAAAAAA";
    wait for 5 ns;
    
    r0 <= x"00000000";
    wait for 5 ns;
    
    op <= x"00005033"; -- SRL
    r0 <= x"FFFFFFFF";
    r1 <= x"00000003";
    wait for 5 ns;
    
    r1 <= x"00000001";
    wait for 5 ns;
    
    op <= x"00001033"; -- SLL
    r0 <= x"FFFFFFFF";
    r1 <= x"00000003";
    wait for 5 ns;
    
    r1 <= x"00000001";
    wait for 5 ns;
    
    op <= x"00002033"; -- SLT
    r0 <= x"00000001";
    r1 <= x"00000002";
    wait for 5 ns;
    
    r1 <= x"00000001";
    wait for 5 ns;
    
    r1 <= x"00000000";
    wait for 5 ns;
    
    op <= x"00000033"; -- ADD
    r0 <= x"01234567";
    r1 <= x"00000009";
    wait for 5 ns;
    
    r0 <= x"7FFFFFFF";
    r1 <= x"00000001";
    wait for 5 ns;
    
    r0 <= x"80000000";
    r1 <= x"FFFFFFFF";
    wait for 5 ns;
    
    op <= x"40000033"; -- SUB
    r0 <= x"01234567";
    r1 <= x"00000008";
    wait for 5 ns;
    
    r0 <= x"00000008";
    r1 <= x"00000008";
    wait for 5 ns;
    
    r0 <= x"7FFFFFFF";
    r1 <= x"FFFFFFFF";
    wait for 5 ns;
    
    r0 <= x"80000000";
    r1 <= x"00000001";
    wait for 5 ns;
    
    wait;
    
end process;

end Behavioral;
