library ieee;
use ieee.std_logic_1164.all;

entity registradorSaida is
    port ( ld_out        :  in std_logic;
			  dado_entrada  :  in std_logic_vector(7 downto 0); -- Recebe soma do acumulador
			  clkRegSaida   :  in std_logic;
           rstRegSaida   :  in std_logic;
           saidaRegSaida : out std_logic_vector(7 downto 0)); 
end registradorSaida;

architecture hardwareRSaida of registradorSaida is
	signal SregSaida	: std_logic_vector(7 downto 0);             
begin
	process (clkRegSaida, rstRegSaida)                            
	begin
			if (rstRegSaida = '1') then                        
						SregSaida <= (others=>'0');                      
			elsif (rstRegSaida = '0' and clkRegSaida'event and clkRegSaida='1') then        
						if (ld_out = '1') then
							SregSaida <= dado_entrada;
						else
							SregSaida <= SregSaida;
						end if;
			end if;
	end process;
	saidaRegSaida <= SregSaida;                                     
end hardwareRSaida;