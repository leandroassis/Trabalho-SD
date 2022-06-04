----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/15/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Módulo somador completo

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FULL_ADDER is
port(
		A_bit, B_bit, CARRY_IN : in STD_LOGIC; -- A_i, B_i, Carry in
		S_bit, CARRY_OUT	: out STD_LOGIC);    -- S_i, carry out
end FULL_ADDER;

architecture FA_Behavior of FULL_ADDER is
begin
	S_bit <= (A_bit XOR B_bit) XOR CARRY_IN ;												-- Calcula a soma dos bits
	CARRY_OUT <= (A_bit AND B_bit) OR (CARRY_IN AND (A_bit XOR B_bit));			-- Calcula o carry gerado
end FA_Behavior;

