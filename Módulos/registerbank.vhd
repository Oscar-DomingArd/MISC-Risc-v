library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.register32bits;
use work.four_bit_decoder;

entity registerbank is
    Port ( registerN : in STD_LOGIC_VECTOR (3 downto 0);
           registerN2 : in STD_LOGIC_VECTOR (3 downto 0);
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           reset : in STD_LOGIC;
           read_write: in STD_LOGIC;
           cs: in STD_LOGIC;
           cs2 : in STD_LOGIC;
           clk : in STD_LOGIC;
           initial : in STD_LOGIC;
           r1_out : out STD_LOGIC_VECTOR (31 downto 0);
           r2_out : out STD_LOGIC_VECTOR (31 downto 0));
end registerbank;

architecture registerBank of registerbank is

    type registers_output_t is array (0 to 15) of std_logic_vector (31 downto 0);
    signal decoded_cs,decoded_cs2,cs_together,initial_vector : std_logic_vector (15 downto 0);
    signal registers_output: registers_output_t;


begin

decoder: entity four_bit_decoder port map(cs => cs, input => registerN, output => decoded_cs);
decoder2: entity four_bit_decoder port map(cs => cs2, input => registerN2, output => decoded_cs2);

initial_vector <= (others => '1') when initial = '1' else (others => '0');
cs_together <= decoded_cs or decoded_cs2 or initial_vector;

register0 : entity register32bits port map(
            dataIn => x"00000000",
            reset => reset,
            read_write => read_write,
            cs => cs_together(0),
            clk => clk,
            dataOut => registers_output(0));
            
register1 : entity register32bits port map(
            dataIn => data_in,
            reset => reset,
            read_write => read_write,
            cs => cs_together(1),
            clk => clk,
            dataOut => registers_output(1));
            
register2 : entity register32bits port map(
            dataIn => data_in,
            reset => reset,
            read_write => read_write,
            cs => cs_together(2),
            clk => clk,
            dataOut => registers_output(2));

register3 : entity register32bits port map(
            dataIn => data_in,
            reset => reset,
            read_write => read_write,
            cs => cs_together(3),
            clk => clk,
            dataOut => registers_output(3));
                        
bank: 
    for i in 4 to 15 generate
        registers32bits : entity register32bits port map(
            --dataIn => data_in,
            dataIn => std_logic_vector(to_unsigned(i, 32)),
            reset => reset,
            read_write => read_write,
            cs => cs_together(i),
            clk => clk,
            dataOut => registers_output(i));
    end generate;

r1_out <= registers_output(to_integer(unsigned(registerN)));
r2_out <= registers_output(to_integer(unsigned(registerN2)));

end registerBank;
