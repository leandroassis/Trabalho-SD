----------------------------------------------------------------------------------
-- Grupo: Leandro A., Davi A., Daniel V.
-- 
-- Create Date:    21:36:25 05/15/2022 
-- Module Name:    bloco_operacoes - Behavioral 
-- Project Name: Trabalho 01 - ALU

-- Description: 

-- Módulo responsável por realizar as operações lógico-aritméticas do circuito. Segue tabela de operações

-- | OPCODE | Operação |  Saída   |
-- |  0000  |   NOP	  | ZZZZZZZZ |
-- |  0001  |   ADD	  |  RA + RB |
-- |  0010  |   SUB	  |  RA - RB |
-- |  0011  |   MULT	  |  RA * RB |
-- |  0100  |   DIV	  |   RA/2   |
-- |  0101  |   AND	  |  RA & RB |
-- |  0110  |   OR	  |  RA | RB |
-- |  0111  |   NOT	  |    RA'   |
-- |  1000  |   XOR	  |  RA ^ RB |
-- |  XXXX  |   NOP	  | ZZZZZZZZ |

-- A saída das operações são divididas em 2 nibbles. Caso haja valor diferente de 0000 no nibble mais significativo, ITE vai para 1.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bloco_operacoes is
    Port ( 
			  RA, RB, OP_CODE 			: in  STD_LOGIC_VECTOR (0 to 3); 	-- Entradas de valor A, valor B, e código de operação.
           RESULT_LSB, RESULT_MSB 	: out STD_LOGIC_VECTOR (0 to 3);		-- Nibbles de saída menos e mais significativos, respectivamente.
			  ITE 							: out STD_LOGIC);							-- Saída de controle para apresentar nibble mais significativo.
end bloco_operacoes;

architecture Behavioral of bloco_operacoes is
	signal SUB_LSB, SUB_MSB, ADD_LSB, ADD_MSB, MULT_LSB, MULT_MSB : STD_LOGIC_VECTOR(0 to 3);	-- Definição de variáveis para armazenar os resultados das operações.
	signal A_sig, B_sig : STD_LOGIC_VECTOR(0 to 7);		-- Definição de variáveis para receber os valores de RA e RB.
	
	component full_adder_8bits							-- Inicio da "chamada" do componente full_adder_8bits
		port(
			A, B 	: in STD_LOGIC_VECTOR (0 to 7);
			C_IN	: in STD_LOGIC;
			S_LSB : out STD_LOGIC_VECTOR (0 to 3);
			S_MSB : out STD_LOGIC_VECTOR (0 to 3));
	end component; 										-- Fim da "chamada" do full_adder_8bits
	
	component multiplicador_4bits						-- Inicio da "chamada" do multiplicador de 4 bits
		port(
			A, B : in STD_LOGIC_VECTOR(0 to 3);
			M_LSB, M_MSB : out STD_LOGIC_VECTOR(0 to 3));
	end component;											-- Fim da chamada do multiplicador de 4 bits
	
begin
	A_sig <= "0000"&RA;			-- A_sig recebe o valor de RA concatenado à direita com "0000", afim de se adequar ao tamanho reconhecido pelo full_adder_8bits
	B_sig <= "0000"&RB;			-- B_sig recebe o valor de RB concatenado à direita com "0000", afim de se adequar ao tamanho reconhecido pelo full_adder_8bits

	F8b01: full_adder_8bits port map(A_sig, B_sig, '0', ADD_LSB, ADD_MSB);		-- Cria um full_adder_8bits que armazena nos nibbles LSB e MSB o valor A_sig + B_sig + 0 (carry_in)
	F8b02: full_adder_8bits port map(A_sig, NOT B_sig, '1', SUB_LSB, SUB_MSB); -- Cria um full_adder_8bits que armazena nos nibbles LSB e MSB o valor A_sig - B_sig (em complemento de 2)
	
	M8b01: multiplicador_4bits port map(RA, RB, MULT_LSB, MULT_MSB);		-- Cria um multiplicador de 4 bits que armazena nos nibbles LSB e MSB o valor de RA * RB.
	
	process(OP_CODE, RA, RB, ADD_LSB, ADD_MSB, SUB_LSB, SUB_MSB, MULT_LSB, MULT_MSB)	-- Inicia um processo que é função das variaveis OP_CODE, RA, RB, ADD_LSB, ADD_MSB, SUB_LSB, SUB_MSB, MULT_LSB, MULT_MSB
	begin
		case OP_CODE is
		
			-- Operações Aritméticas
			when "0001" =>																			-- Adição
				RESULT_LSB <= std_logic_vector(ADD_LSB);
				RESULT_MSB <= std_logic_vector(ADD_MSB);
				
				if ADD_LSB(0) = '1' then			-- Caso o bit mais significativo do nibble LSB seja 1 (seria overflow pois são computados em C2), significa que o resultado tem na vdd 8 bits e é necessário ler o MSB.
					ITE <= '1';
				else 
					ITE <= '0';
				end if;
			when "0010" =>																			-- Subtração
				RESULT_LSB <= std_logic_vector(SUB_LSB);
				RESULT_MSB <= std_logic_vector(SUB_MSB);
				
				if SUB_LSB(0) = '1' then			-- Caso o bit mais significativo do nibble LSB seja 1, faz-se a apresentação em 8 bits (usando o MSB) e, para isso, adapta os 4 bits MSB como bits de sinal, e os 4 bits LSB como magnetude em C2
					RESULT_LSB(0) <= '1';
					RESULT_MSB <= "1111";
					ITE <= '1';
				else
					ITE <= '0';
				end if;
			when "0011" =>																			-- Multiplicação
				if MULT_MSB /= "0000" then			-- Caso o nibble MSB seja diferente de 0000, é necessário mostrar os 2 nibbles
					ITE <= '1';
				else 
					ITE <= '0';
				end if;
				RESULT_LSB <= std_logic_vector(MULT_LSB);
				RESULT_MSB <= std_logic_vector(MULT_MSB);
			when "0100" => 									 									-- A dividido por 2
				for it in 3 downto 0 loop
					if it = 0 then						-- Shifta RA para a direita uma vez
						RESULT_LSB(it) <= '0';
					else
						RESULT_LSB(it) <= RA(it-1);
					end if;
				end loop;
				RESULT_MSB <= "0000";
				ITE <= '0';
			-- Fim das Operações Aritméticas
			
			-- Operações Lógicas 
			when "0101" =>																			-- A and B
				RESULT_LSB <= RA AND RB;	
				RESULT_MSB <= "0000";
				ITE <= '0';
			when "0110" => 		 																-- A OR B
				RESULT_LSB <= RA OR RB;
				RESULT_MSB <= "0000";
				ITE <= '0';
			when "0111" =>																			-- NOT A
				RESULT_LSB <= NOT RA;
				RESULT_MSB <= "0000";
				ITE <= '0';
			when "1000" =>																			-- A XOR B
				RESULT_LSB <= RA XOR RB;
				RESULT_MSB <= "0000";
				ITE <= '0';
			when others =>																			-- Operação inválida ou nenhuma operação, saida em alta impedância
				RESULT_LSB <= "0000";
				RESULT_MSB <= "0000";
				ITE <= '0';
			-- Fim das Operações Lógicas
		end case;
	end process;
end Behavioral;

