library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity registradorInc is
    port ( inc         :  in  std_logic; -- Ativa o incremento
			  clkRegInc   :  in  std_logic;
           rstRegInc   :  in  std_logic;
           saidaRegInc : out  std_logic_vector(2 downto 0)); 
end registradorInc;

architecture hardwareRInc of registradorInc is
	signal sigInc  : std_logic_vector(2 downto 0);
begin
	process (clkRegInc, rstRegInc)                            
	begin
			   if (rstRegInc = '1') then                        
						sigInc <= "001";
				elsif (rstRegInc = '0' and clkRegInc'event and clkRegInc='1') then        
						if (inc='1') then sigInc <= sigInc + 1;
						end if;
				end if;
	end process;
	saidaRegInc <=  sigInc;                                   
end hardwareRInc;