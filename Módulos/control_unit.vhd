library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity control_unit is
    Port ( alu_result : in STD_LOGIC_VECTOR (31 downto 0); --Entrada resultado alu
           data_from_memory : in STD_LOGIC_VECTOR (31 downto 0); --Entrada de datos de memoria
           clk : in STD_LOGIC; --Entrada cloak
           program_memory : in STD_LOGIC; --Entrada flag escritura de memoria
           instruction : in STD_LOGIC_VECTOR(31 downto 0);
           registerN1: out STD_LOGIC_VECTOR(3 downto 0); --Salida selección registro 1
           registerN2: out STD_LOGIC_VECTOR(3 downto 0); --Salida selección registro 2
           cs_register1 : out STD_LOGIC; --Salida cs para registro 1
           cs_register2 : out STD_LOGIC; --Salida cs para registro 2
           cspc: out STD_LOGIC; --Salida cs para pc
           cs_mem: out STD_LOGIC; --Salida cs para memoria datos
           reset_register : out STD_LOGIC := '0'; --Salida reset register (no se usa)
           read_write_regs : out STD_LOGIC; --Salida de flag read 0 write 1 de los registros
           read_write_mem : out STD_LOGIC; --Salida de flag read 0 write 1 de la memoria
           read_write_pc : out STD_LOGIC; --Salida de flag read 0 write 1 de la pc (no voy a añadir salida de addr a pc, si read -> addr a memoria, else pc, lo mismo con data_from_memory)
           data_for_register : out STD_LOGIC_VECTOR (31 downto 0); --Salida de datos a registros
           addr_out : out STD_LOGIC_VECTOR (7 downto 0); --Salida de selección de dirección en memoria
           instruction_out : out STD_LOGIC_VECTOR(31 downto 0)); --Salida de instrucción para la ALU, se puede sacar únicamente funct3 y funct7 a parte
end control_unit;

architecture Behavioral of control_unit is

signal instruction_reg : std_logic_vector(31 downto 0) := (others => '0');
signal reg1_output : std_logic_vector (3 downto 0);
signal inm_j : std_logic_vector (19 downto 0);
signal inm_s : std_logic_vector (11 downto 0);
signal counter : std_logic_vector (2 downto 0) := "111";
signal result : std_logic_vector (31 downto 0) := (others => '0');

begin
instruction_reg <= instruction when counter(2) = '1' and program_memory = '0' else instruction_reg;

instruction_out <= instruction_reg;
result <= alu_result when instruction_reg(6 downto 0) = "0110011" and counter(0) = '1' and counter(1) = '0' else result;


addr_out <= instruction_reg(27 downto 20) when instruction_reg(6 downto 0) = "0000011" else
            inm_s(7 downto 0) when instruction_reg(6 downto 0) = "0100011" else
            inm_j(7 downto 0) when instruction_reg(6 downto 0) = "1101111" else x"00";

cspc<= counter(2) or program_memory;
cs_mem <= '1' when counter(1) = '1' and counter(2) = '0' and (instruction_reg(6 downto 0) = "0000011" or instruction_reg(6 downto 0) = "0100011") else '0';


read_write_pc <= '1' when instruction_reg(6 downto 0) = "1101111" else '0';            
read_write_mem <= '1' when program_memory = '1' or instruction_reg(6 downto 0) = "0100011" else '0';
read_write_regs <= '1' when counter(0) = '0' and counter(1) = '1' and (instruction_reg(6 downto 0) = "0110011" or instruction_reg(6 downto 0) = "0000011") else '0';

registerN1 <= instruction_reg(10 downto 7) when counter(1) = '1' and counter(0) = '0' else instruction_reg(18 downto 15) when counter(1) = '0' else "0000";
cs_register1 <= '1' when instruction_reg(6 downto 0) = "0110011" or instruction_reg(6 downto 0) = "0000011" else '0';

registerN2 <= instruction_reg(23 downto 20) when instruction_reg(6 downto 0) = "0110011" or instruction_reg(6 downto 0) = "0100011" else "0000";
cs_register2 <= '1' when (counter(1) = '0' and counter(2) = '0') or instruction_reg(6 downto 0) = "0100011"  else '0';

data_for_register <= result when instruction_reg(6 downto 0) = "0110011" else 
                     data_from_memory when instruction_reg(6 downto 0) = "0000011" or instruction_reg(6 downto 0) = "1101111" else
                     (others=> '0');
                     
counter <= "111" when rising_edge(counter(2)) or 
           not ((instruction_reg(6 downto 0) = "0110011") or (instruction_reg(6 downto 0) = "0000011") or (instruction_reg(6 downto 0) = "0100011")) else
           counter + 1 when rising_edge(clk);

inm_j<= (19 => instruction_reg(31), 
         18 => instruction_reg(19),
         17 => instruction_reg(18),
         16 => instruction_reg(17),
         15 => instruction_reg(16),
         14 => instruction_reg(15),
         13 => instruction_reg(14),
         12 => instruction_reg(13),
         11 => instruction_reg(12),
         10 => instruction_reg(20),
         9 => instruction_reg(30),
         8 => instruction_reg(29),
         7 => instruction_reg(28),
         6 => instruction_reg(27),
         5 => instruction_reg(26),
         4 => instruction_reg(25),
         3 => instruction_reg(24),
         2 => instruction_reg(23),
         1 => instruction_reg(22),
         0 => instruction_reg(21));

inm_s <= (11 => instruction_reg(31),
          10 => instruction_reg(30),
          9 => instruction_reg(29),
          8 => instruction_reg(28),
          7 => instruction_reg(27),
          6 => instruction_reg(26),
          5 => instruction_reg(25),
          4 => instruction_reg(11),
          3 => instruction_reg(10),
          2 => instruction_reg(9),
          1 => instruction_reg(8),
          0 => instruction_reg(7));

end Behavioral;
