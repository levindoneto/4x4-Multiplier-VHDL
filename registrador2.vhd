library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity registrador2 is
    port ( incRegSel :  in std_logic;
			  clkReg2   :  in std_logic;
           rstReg2   :  in std_logic;
           saidaReg2 : out std_logic_vector(1 downto 0)); 
end registrador2;

architecture hardwareR2 of registrador2 is
	signal Sreg2	: std_logic_vector(1 downto 0);             
begin
	process (clkReg2, rstReg2)                            
	begin
			   if (rstReg2 = '1') then                        
						Sreg2 <= "00";                      
			elsif (rstReg2 = '0' and clkReg2'event and clkReg2='1') then        
						if (incRegSel = '1') then
							Sreg2 <= Sreg2 + 1;
						else
							Sreg2 <= Sreg2;
						end if;
			end if;
	end process;
	saidaReg2 <= Sreg2;                                     
end hardwareR2;