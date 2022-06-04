----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/15/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Multiplicador utilizando um full adder e um AND

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity modulo_multiplicador is
	port(
		A, B, S_IN, C_IN : in STD_LOGIC;
		C_OUT, S_OUT : out STD_LOGIC);
end modulo_multiplicador;

architecture Behavioral of modulo_multiplicador is

	signal temp : STD_LOGIC;	-- Variavel auxiliar
	
	component FULL_ADDER			-- Chamada do componente full adder declarado previamente
		port(
			A_bit, B_bit, CARRY_IN : in STD_LOGIC;
			S_bit, CARRY_OUT 	: out STD_LOGIC);
	end component;
	
begin
	temp <= A AND B;
	FA01: FULL_ADDER port map(S_IN, temp, C_IN, S_OUT, C_OUT); -- S_OUT = S_IN + A & B + C_IN
end Behavioral;

