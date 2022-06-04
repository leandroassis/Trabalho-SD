----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/15/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Módulo multiplicador de dois numeros de 4 bits

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplicador_4bits is
	port(
	A, B : in STD_LOGIC_VECTOR(0 to 3);
	M_LSB, M_MSB : out STD_LOGIC_VECTOR(0 to 3));
end multiplicador_4bits;

architecture Behavioral of multiplicador_4bits is

	signal carry : STD_LOGIC_VECTOR(0 to 10); -- carry(0, 1, 2, 3, ... , 10)
	signal soma_temp : STD_LOGIC_VECTOR(0 to 5);
	signal X : STD_LOGIC_VECTOR(0 to 2);

	component modulo_multiplicador
		port(
			A, B, S_IN, C_IN : in STD_LOGIC;
			S_OUT, C_OUT : out STD_LOGIC);
	end component;
begin

	X(0) <= A(2) AND B(3);
	X(1) <= A(1) AND B(3);
	X(2) <= A(0) AND B(3);
	
	-- Inicio do cálculo dos bits menos significativos da multiplicacao

	M_LSB(3) <= A(3) AND B(3); -- M(7)
	
	MULT1: modulo_multiplicador port map(A(3), B(2), X(0) , '0', M_LSB(2), carry(0)); -- M(6)
	
	MULT2: modulo_multiplicador port map(A(2), B(2), X(1), carry(0), soma_temp(0), carry(1));
	MULT3: modulo_multiplicador port map(A(3), B(1), soma_temp(0), '0', M_LSB(1), carry(2)); -- M(5)
	
	MULT4: modulo_multiplicador port map(A(1), B(2), X(2), carry(1), soma_temp(1), carry(3));
	MULT5: modulo_multiplicador port map(A(2), B(1), soma_temp(1), carry(2), soma_temp(2), carry(4));
	MULT6: modulo_multiplicador port map(A(3), B(0), soma_temp(2), '0', M_LSB(0), carry(5)); -- M(4)
	
	-- Bits menos significativos da multiplicação calculados.
	
	-- Inicio do cálculo dos bits mais significativos da multiplicação
	
	MULT7: modulo_multiplicador port map(A(0), B(2), '0', carry(3), soma_temp(3), carry(6));
	MULT8: modulo_multiplicador port map(A(1), B(1), soma_temp(3), carry(4), soma_temp(4), carry(7));
	MULT9: modulo_multiplicador port map(A(2), B(0), soma_temp(4), carry(5), M_MSB(3), carry(8)); -- M(3)

	MULT10: modulo_multiplicador port map(A(0), B(1), carry(6), carry(7), soma_temp(5), carry(9));
	MULT11: modulo_multiplicador port map(A(1), B(0), soma_temp(5), carry(8), M_MSB(2), carry(10)); -- M(2)
	
	MULT12: modulo_multiplicador port map(A(0), B(0), carry(9), carry(10), M_MSB(1), M_MSB(0)); -- M(1) e M(0)
	
	-- Bits mais significativos da multiplicação calculados
end Behavioral;

