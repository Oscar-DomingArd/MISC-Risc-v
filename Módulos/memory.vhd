library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.register32bits;
use work.four_bit_decoder;

entity memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           read_write : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           cs : in STD_LOGIC;
           initial : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
end memory;

architecture memory of memory is

-- XLEN = 32 bits
-- ( 2^32 byte * 8 bits/byte ) / 32 bits/registro = 1073741824 registros
-- No voy a hacer una memoria tan grande, que podría simplemente cambiando
-- el número de generación, pero no es necesario para
-- comprobar el funcionamiento del procesador
    type registers_output_t is array (0 to 63) of std_logic_vector (31 downto 0);
    signal decoded_cs : std_logic_vector (63 downto 0);
    signal registers_output: registers_output_t;
    signal cs0 : std_logic;
    signal cs1 : std_logic;
    signal cs2 : std_logic;
    signal cs3 : std_logic;
    signal initial_data : std_logic_vector (31 downto 0);
    signal initial_write : std_logic;
    signal initial_cs : std_logic_vector (63 downto 0);
begin

cs0<=(not addr(7)) and (not addr(6)) and cs;
cs1<=(not addr(7)) and (addr(6)) and cs;
cs2<=(addr(7)) and (not addr(6)) and cs;
cs3<=(addr(7)) and (addr(6)) and cs;

initial_cs <= decoded_cs when initial = '0' else x"FFFFFFFFFFFFFFFF" when initial = '1';

initial_data <= data_in when initial = '0' else x"10101010" when initial = '1';
initial_write <= initial or read_write;

--Vamos a ignorrar los dos últimos bits de la dirección, porque siempre vamos a tratar words de 32 bits
decoder0 : entity four_bit_decoder port map(cs=>cs0,input=>addr(5 downto 2), output=>decoded_cs(15 downto 0));
decoder1 : entity four_bit_decoder port map(cs=>cs1,input=>addr(5 downto 2), output=>decoded_cs(31 downto 16));
decoder2 : entity four_bit_decoder port map(cs=>cs2,input=>addr(5 downto 2), output=>decoded_cs(47 downto 32));
decoder3 : entity four_bit_decoder port map(cs=>cs3,input=>addr(5 downto 2), output=>decoded_cs(63 downto 48));

--Sólo vamos a usar los últimos 5 bits dirección
memory: 
    for i in 0 to 63 generate
        registers32bits : entity register32bits port map(
            dataIn => initial_data,
            reset => reset,
            read_write => initial_write,
            cs => initial_cs(i),
            clk => clk,
            dataOut => registers_output(i));
    end generate;
    
output <= registers_output(to_integer(shift_right(unsigned(addr),2))) when cs = '1' else x"00000000";
end memory;
