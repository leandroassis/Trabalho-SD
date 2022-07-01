----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/24/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Circuito sequencial que gerencia a apresentação dos dados armazenados nos leds


-- Significado dos estados

-- | Q1 | Q1 | Q0 |     Operação     |
-- | 0  | 0  | 0  |   Apresenta RA   |
-- | 0  | 0  | 1  |   Apresenta RB   |
-- | 0  | 1  | 0  | Apresent OP_CODE |
-- | 0  | 1  | 1  |   Apresenta nibble menos significativo da resposta  |
-- | 1  | 0  | 0  |   Apresenta nibble mais significativo da resposta  | -> Somente se necessario

-- OBS: Esse projeto apresenta os dados no formato little endian

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bloco_sequencial_2 is
	port(
		SW_placa : in STD_LOGIC_VECTOR(0 to 3);		-- Entrada conectada com as chaves da placa para entrada de valores
		ENTER_placa, RESET_placa, CLOCK_INT : in STD_LOGIC; -- Entradas conectadas aos botões usados para clock do circuito de interface, para resetar os circuitos e ao clock interno do FPGA
		LEDS_LSB	: out STD_LOGIC_VECTOR(0 to 3); -- Saídas conectadas aos LEDS da placa
		LEDS_MSB		: out STD_LOGIC_VECTOR(0 to 3)
	);
end bloco_sequencial_2;

architecture Behavioral of bloco_sequencial_2 is
	
	signal A, B, OP, ResultLSB, ResultMSB : STD_LOGIC_VECTOR(0 to 3) := "0000"; -- Variaveis que vão armazenar o valor de A, B e OP durante o circuito de interface, e ResultLSB/MSB durante o bloco de operação
	signal show_enable, iter, clock : STD_LOGIC; -- Variaveis que vão armazenar se a apresentação dos valores esta habilitada, se é necessário mostrar o nibble mais significativo, e o clock dividido
	signal estado : STD_LOGIC_VECTOR(0 to 2) := "000"; -- Variavel que armazena o estado atual dessa maquina de estado 

	component bloco_sequencial_1
		port(
			SW : in STD_LOGIC_VECTOR(0 to 3);
			ENTER, RESET : in STD_LOGIC;	
			SHOW	: out STD_LOGIC;
			RegA, RegB, RegOP : out STD_LOGIC_VECTOR(0 to 3)
		);	
	end component;
	
	component bloco_operacoes
		port(
			RA, RB, OP_CODE 			: in  STD_LOGIC_VECTOR (0 to 3); 
         RESULT_LSB, RESULT_MSB 	: out STD_LOGIC_VECTOR (0 to 3);	
			ITE 							: out STD_LOGIC
		);
	end component;
	
	component fonte_de_clock
		port(
			CLOCK_IN	: in STD_LOGIC;
			RESET		: in STD_LOGIC;
			ENABLE 	: in STD_LOGIC;
			CLOCK_OUT : out STD_LOGIC
		);
	end component;
	
begin

	INTERFACE : bloco_sequencial_1 port map(SW_placa, ENTER_placa, RESET_placa, show_enable, A, B, OP); -- União dos blocos de interface

	ULA	: bloco_operacoes port map(A, B, OP, ResultLSB, ResultMSB, iter); -- Com o bloco de operações lógico-aritméticas
	
	DIVISOR_DE_CLOCK : fonte_de_clock port map(CLOCK_INT, RESET_placa, show_enable, clock); -- E o divisor de clock
	
	process(RESET_placa, A, B, OP, ResultLSB, ResultMSB, iter, show_enable, estado, clock) -- Que vão conectados com o "bloco" gerado no interior desse processo
	begin
		if RESET_placa = '1' then
			estado <= "000";
			LEDS_MSB <= "0000";
			LEDS_LSB <= "0000";
		elsif show_enable = '1' then	-- Caso a apresentação seja habilitada pelo circuito INTEFACE
			if rising_edge(clock) then	-- E o clock do divisor esteja em borda de subida
				case estado is
					when "000" =>	-- Apresenta o valor de A e vai para a próximo estado (na proxima borda de subida)
						LEDS_MSB <= "0001";
						LEDS_LSB <= A;
						estado <= "001";
					when "001" =>	-- Apresenta o valor de B e vai para a próximo estado (na proxima borda de subida)
						LEDS_MSB <= "0010";
						LEDS_LSB <= B;
						estado <= "010";
					when "010" =>	-- Apresenta o valor de OPCODE e vai para a próximo estado (na proxima borda de subida)
						LEDS_MSB <= "0011";
						LEDS_LSB <= OP;
						estado <= "011";
					when "011" =>	-- Apresenta o valor do nibble menos significativo do resultado computado pela ULA e vai para a próximo estado (na proxima borda de subida)
						LEDS_MSB <= "0100";
						LEDS_LSB <= ResultLSB;
						if iter = '1' then
							estado <= "100";
						else estado <= "000";
						end if;
					when "100" =>	-- Apresenta o valor do nibble mais significativo do resultado computado pela ULA e vai para o estado inicial (na proxima borda de subida)
						LEDS_MSB <= "0101";
						LEDS_LSB <= ResultMSB;
						estado <= "000";
					when others =>	-- Caso esteja em um caso imprevisto, a saida fica em alta impedância e o estado em 000
						LEDS_MSB <= "ZZZZ";
						LEDS_LSB <= "ZZZZ";
						estado <= "000";
				end case;		
			end if;
		else
			LEDS_MSB <= "0000";
			LEDS_LSB <= "0000";
			estado <= "000";
		end if;
	end process;

end Behavioral;

