----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/15/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Circuito sequencial que gerencia a inser��o de dados e a chamada do circuito de apresenta��o do resultado


-- Significado dos estados

-- | Q1 | Q0 |   Opera��o   |
-- | 0  | 0  |   Salva RA   |
-- | 0  | 1  |   Salva RB   |
-- | 1  | 0  |Salva OP_CODE |
-- | 1  | 1  |   Apresenta  |

-- Tabela do circuito sequencial

-- | Q1 | Q0 | Q1f | Q0f |
-- | 0  | 0  | 0   | 1   |
-- | 0  | 1  | 1   | 0   |
-- | 1  | 0  | 1   | 1   |
-- | 1  | 1  | 1   | 0   | -> Volta para escolher nova opera��o

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bloco_sequencial_1 is
	port(
		SW : in STD_LOGIC_VECTOR(0 to 3);  -- Entrada de vetor de 4 bits
		ENTER, RESET : in STD_LOGIC;		  -- Bot�es para prosseguir um estado (CLOCK) e resetar o circuito, respectivamente	
		SHOW	: out STD_LOGIC;				  -- Sa�da que habilita o circuito de apresenta��o
		RegA, RegB, RegOP : out STD_LOGIC_VECTOR(0 to 3) -- Sa�da dos valores RA, RB e ROP inseridos
	);
end bloco_sequencial_1;

architecture Behavioral of bloco_sequencial_1 is

	signal estado : STD_LOGIC_VECTOR(0 to 1) := "00"; -- Vari�vel para guardar o estado atual da m�quina de estado
	
begin
	process(SW, ENTER, RESET, estado)
	begin
		if RESET = '1' then estado <= "00";		-- Se, e somente se, pressionar o bot�o de RESET a m�quina volta para o estado inicial
		elsif ENTER'event AND ENTER = '1' then	-- Caso o bot�o de enter seja apertado
			case estado is
				when "00" =>	-- Se estiver no estado 00, salva o valor de SW na saida RegA, n�o habilita a apresenta��o e vai para o proximo estado(quando ENTER for apertado dnv)
					RegA <= SW;
					SHOW <= '0';
					estado <= "01";
				when "01" =>	-- Se estiver no estado 01, salva o valor de SW na saida RegB, n�o habilita a apresenta��o e vai para o proximo estado (quando ENTER for apertado dnv)
					RegB <= SW;
					SHOW <= '0';
					estado <= "10";
				when "10" =>	-- Se estiver no estado 10, salva o valor de SW na saida RegOP, n�o habilita a apresenta��o e vai para o proximo estado(quando ENTER for apertado dnv)
					RegOP <= SW;
					SHOW <= '0';
					estado <= "11";
				when "11" =>	-- Se estiver no estado 11, habilita a apresenta��o e volta para o estado 10 (quando ENTER for apertado dnv)
					SHOW <= '1';
					estado <= "10";
				when others =>
					estado <= "00";
			end case;	
		end if;
	end process;
end Behavioral;

