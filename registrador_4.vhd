library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity registradorInc4 is
    port ( inc4       :  in  std_logic; -- Ativa o incremento
			  clkReg4   :  in  std_logic;
           rstReg4   :  in  std_logic;
           saidaReg4 : out  std_logic_vector(3 downto 0)); 
end registradorInc4;

architecture hardwareR4 of registradorInc4 is
	signal sigInc4  : std_logic_vector(3 downto 0);
begin
	process (clkReg4, rstReg4)                            
	begin
			   if (rstReg4 = '1') then                        
						sigInc4 <= (others=>'0');
				elsif (rstReg4 = '0' and clkReg4'event and clkReg4='1') then        
						if (inc4='1') then 
							sigInc4 <= sigInc4 + 1;
						else
							sigInc4 <= sigInc4;
						end if;
				end if;
	end process;
	saidaReg4 <=  sigInc4;                                   
end hardwareR4;