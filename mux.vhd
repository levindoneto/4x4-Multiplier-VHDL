-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mux4p1 is
    Port ( 
			  seletor      : in  std_logic_vector(1 downto 0);
			  e0seletor    : in  std_logic_vector(3 downto 0); -- A0, B0
			  e1seletor    : in  std_logic_vector(3 downto 0); -- A1, B1   
			  e2seletor    : in  std_logic_vector(3 downto 0); -- A2, B2   
			  e3seletor    : in  std_logic_vector(3 downto 0); -- A3, B3 
           saidaSeletor : out std_logic_vector(3 downto 0));
end mux4p1;

-- Arquitetura do seletor de  8 bits
architecture hardwareSel8 of mux4p1 is
begin
	saidaSeletor       	<=  e0seletor when seletor="00" else
									 e1seletor when seletor="01" else
									 e2seletor when seletor="10" else
									 e3seletor;           
end hardwareSel8;