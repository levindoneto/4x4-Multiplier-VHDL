library ieee;
use ieee.std_logic_1164.all;

entity registradorAcc is
    port ( ac			  :  in std_logic; -- Ativa a passagem do dado (saida do somador) pro acc
			  dadoRegAcc  :  in std_logic_vector(7 downto 0); -- Saida do multiplicador
			  clkRegAcc   :  in std_logic;
           rstRegAcc   :  in std_logic;
           saidaRegAcc : out std_logic_vector(7 downto 0)); 
end registradorAcc;

architecture hardwareAcc of registradorAcc is
	signal SregAcc	 : std_logic_vector(7 downto 0);             
begin
	process (clkRegAcc, rstRegAcc)                            
	begin
			if (rstRegAcc = '1') then                        
						SregAcc <= (others=>'0');                      
			elsif (rstRegAcc = '0' and clkRegAcc'event and clkRegAcc='1') then        
						if (ac = '1') then 
							SregAcc <= dadoRegAcc;
						else
							SregAcc <= SregAcc;
						end if;
			end if;
	end process;
	saidaRegAcc <= SregAcc;                                     
end hardwareAcc;