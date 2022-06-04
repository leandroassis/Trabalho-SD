----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/15/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Somador em cascata de 8 bits usando somadores completos

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_8bits is
port(
	A, B 		: in STD_LOGIC_VECTOR (0 to 7);			
	C_IN		: in STD_LOGIC;
	S_LSB 			: out STD_LOGIC_VECTOR (0 to 3);
	S_MSB 			: out STD_LOGIC_VECTOR (0 to 3));
end full_adder_8bits;

architecture Behavioral of full_adder_8bits is

	signal aux_carry : STD_LOGIC_VECTOR (0 to 7);		-- array de carrys para auxiliar
	
	component FULL_ADDER											-- chamada do componente full_adder declarado anteriormente
	port(
		A_bit, B_bit, CARRY_IN : in STD_LOGIC;
		S_bit, CARRY_OUT 	: out STD_LOGIC);
	end component;
	
	begin
		-- Arranjo em cascata dos somadores completos, utilizando como valores para operação, os valores dos vetores A e B de entrada
		FA0: FULL_ADDER port map(A(7), B(7), C_IN, S_LSB(3), aux_carry(7));
		FA1: FULL_ADDER port map(A(6), B(6), aux_carry(7), S_LSB(2), aux_carry(6));
		FA2: FULL_ADDER port map(A(5), B(5), aux_carry(6), S_LSB(1), aux_carry(5));
		FA3: FULL_ADDER port map(A(4), B(4), aux_carry(5), S_LSB(0), aux_carry(4));
		FA4: FULL_ADDER port map(A(3), B(3), aux_carry(4), S_MSB(3), aux_carry(3));
		FA5: FULL_ADDER port map(A(2), B(2), aux_carry(3), S_MSB(2), aux_carry(2));
		FA6: FULL_ADDER port map(A(1), B(1), aux_carry(2), S_MSB(1), aux_carry(1));
		FA7: FULL_ADDER port map(A(0), B(0), aux_carry(1), S_MSB(0), aux_carry(0));
end Behavioral;

