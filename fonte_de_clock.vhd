----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/20/2022 
-- Module Name:    fonte_de_clock - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Divisor do clock interno do FPGA de 50 MHz para 0.5 MHz
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fonte_de_clock is
	port(
		CLOCK_IN	: in STD_LOGIC;	-- Pino entrada de clock
		RESET		: in STD_LOGIC;	-- Pino de entrada do sinal de RESET
		ENABLE		: in STD_LOGIC; -- Pino de entrada do sinal de ENABLE
		CLOCK_OUT : out STD_LOGIC 	 -- Pino de saída do clock dividido
	);
end fonte_de_clock;

architecture Behavioral of fonte_de_clock is
	
	signal aux : std_logic := '0';	-- Variável para guardar o valor de saida
	signal contador : integer range 0 to 49999999 := 0; -- Variável para contabilizar os ciclos de clock do clock de entrada
	
begin
	
	process(CLOCK_IN, RESET)
	begin
		if RESET = '1' then	-- Caso o RESET seja apertado, o contador é resetado (afim de evitar falta de sincronismo na apresentação)
			aux <= '0';
			contador <= 0;
		elsif rising_edge(CLOCK_IN) AND ENABLE = '1' then -- Toda vez que o clock de entrada estiver na borda de subida
			if contador = 49999999 then	-- Compara se o contador chegou ao 50.000.000º ciclo de clock
				contador <= 0;		-- Se sim reinicia a contagem
				aux <= not aux;	-- E inverte o valor da saída de clock
			else 
				contador <= contador + 1;	-- Se não, apenas incrementa o contador
			end if;
		end if;
		CLOCK_OUT <= aux; 	-- Coloca o valor da variável na saída de clock
	end process;
end Behavioral;

