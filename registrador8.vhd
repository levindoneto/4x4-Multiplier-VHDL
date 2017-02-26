library ieee;
use ieee.std_logic_1164.all;

entity registrador8 is
    port ( clkReg8   :  in  std_logic;
           rstReg8   :  in  std_logic;
           saidaReg8 : out  std_logic_vector(7 downto 0)); 
end registrador8;

architecture hardwareR8 of registrador8 is
	signal Sreg	: std_logic_vector(7 downto 0);             
begin
	process (clkReg8, rstReg8)                            
	begin
			   if (rstReg8 = '1') then                        
						Sreg <=  (others=>'0');                      
			elsif (rstReg8 = '0' and clkReg8'event and clkReg8='1') then        
						Sreg <= Sreg;  -- FIZ SÓ PASSANDO O SINAL PORQUE NAO TEM DADO DE ENTRADA NESSES DE ENDEREÇO, CONFERIR
			end if;
	end process;
	saidaReg8 <= Sreg;                                     
end hardwareR8;