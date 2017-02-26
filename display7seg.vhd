library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display is
	port( input : in std_logic_vector(15 downto 0);
			clk : in std_logic;
         rst : in std_logic;
         an0 : out std_logic;
         an1 : out std_logic;
         an2 : out std_logic;
         an3 : out std_logic;
         led_d : out std_logic_vector(7 downto 0));
end Display;

architecture Behavioral of Display is

	signal cont : unsigned(15 downto 0);
	signal cont2 : unsigned(1 downto 0);
	signal div_clk : std_logic;
	signal conversor_bit0 : std_logic_vector(7 downto 0);
	signal conversor_bit1 : std_logic_vector(7 downto 0);
	signal conversor_bit2 : std_logic_vector(7 downto 0);
	signal conversor_bit3 : std_logic_vector(7 downto 0);

begin

	process(rst, clk)
	begin
		if(rst = '1') then
			cont <= (others => '0');
		elsif(clk'EVENT and clk = '1') then
			cont <= cont + 1;
		end if;
	end process; 

	div_clk <= cont(15);

	process(div_clk, cont2, rst)
	begin
		if(rst = '1') then 
			cont2 <= "00";
		elsif(div_clk'EVENT and div_clk = '1') then
			cont2 <= cont2 + 1;
		end if;
	end process;

	process(cont2, conversor_bit0, conversor_bit1, conversor_bit2, conversor_bit3)
	begin
		case cont2 is
			when "00" => 	an0 <='0';
								an1 <='1';
								an2 <='1';
								an3 <='1';
								led_d <= conversor_bit0;
			when "01" => 	an0 <='1';
								an1 <='0';
								an2 <='1';
								an3 <='1';
								led_d <= conversor_bit1;	
			when "10" => 	an0 <='1';
								an1 <='1';
								an2 <='0';
								an3 <='1';
								led_d <= conversor_bit2;
			when others => an0 <='1';
								an1 <='1';
								an2 <='1';
								an3 <='0';
								led_d <= conversor_bit3;
		end case; 
	end process;	

	process (input(15 downto 12), conversor_bit0)
	begin
		case input(15 downto 12) IS
			when "0000" => conversor_bit0 <= "00000011"; -- digito 0
			when "0001" => conversor_bit0 <= "10011111"; -- digito 1
			when "0010" => conversor_bit0 <= "00100101"; -- digito 2
			when "0011" => conversor_bit0 <= "00001101";
			when "0100" => conversor_bit0 <= "10011001";
			when "0101" => conversor_bit0 <= "01001001";
			when "0110" => conversor_bit0 <= "01000001";
			when "0111" => conversor_bit0 <= "00011111";
			when "1000" => conversor_bit0 <= "00000001";
			when "1001" => conversor_bit0 <= "00001001";
			when "1010" => conversor_bit0 <= "00010001"; -- digito A
			when "1011" => conversor_bit0 <= "11000001"; -- digito B
			when "1100" => conversor_bit0 <= "01100011"; -- digito C
			when "1101" => conversor_bit0 <= "10000101"; -- digito D
			when "1110" => conversor_bit0 <= "01100001"; -- digito E
			when others => conversor_bit0 <= "01110001"; -- digito F
		end case;
	end process;
	
	process (input(11 downto 8), conversor_bit1)
	begin
		case input(11 downto 8) is
			when "0000" => conversor_bit1 <= "00000011"; -- digito 0
			when "0001" => conversor_bit1 <= "10011111"; -- digito 1
			when "0010" => conversor_bit1 <= "00100101"; -- digito 2
			when "0011" => conversor_bit1 <= "00001101";
			when "0100" => conversor_bit1 <= "10011001";
			when "0101" => conversor_bit1 <= "01001001";
			when "0110" => conversor_bit1 <= "01000001";
			when "0111" => conversor_bit1 <= "00011111";
			when "1000" => conversor_bit1 <= "00000001";
			when "1001" => conversor_bit1 <= "00001001";
			when "1010" => conversor_bit1 <= "00010001"; -- digito A
			when "1011" => conversor_bit1 <= "11000001"; -- digito B
			when "1100" => conversor_bit1 <= "01100011"; -- digito C
			when "1101" => conversor_bit1 <= "10000101"; -- digito D
			when "1110" => conversor_bit1 <= "01100001"; -- digito E
			when others => conversor_bit1 <= "01110001"; -- digito F
		end case;
	end process;
	
	process (input(7 downto 4), conversor_bit2)
	begin
		case input(7 downto 4) is
			when "0000" => conversor_bit2 <= "00000011"; -- digito 0
			when "0001" => conversor_bit2 <= "10011111"; -- digito 1
			when "0010" => conversor_bit2 <= "00100101"; -- digito 2
			when "0011" => conversor_bit2 <= "00001101";
			when "0100" => conversor_bit2 <= "10011001";
			when "0101" => conversor_bit2 <= "01001001";
			when "0110" => conversor_bit2 <= "01000001";
			when "0111" => conversor_bit2 <= "00011111";
			when "1000" => conversor_bit2 <= "00000001";
			when "1001" => conversor_bit2 <= "00001001";
			when "1010" => conversor_bit2 <= "00010001"; -- digito A
			when "1011" => conversor_bit2 <= "11000001"; -- digito B
			when "1100" => conversor_bit2 <= "01100011"; -- digito C
			when "1101" => conversor_bit2 <= "10000101"; -- digito D
			when "1110" => conversor_bit2 <= "01100001"; -- digito E
			when others => conversor_bit2 <= "01110001"; -- digito F
		end case;
	end process;

	process (input(3 downto 0), conversor_bit3)
	begin
		case input(3 downto 0) is
			when "0000" => conversor_bit3 <= "00000011"; -- digito 0
			when "0001" => conversor_bit3 <= "10011111"; -- digito 1
			when "0010" => conversor_bit3 <= "00100101"; -- digito 2
			when "0011" => conversor_bit3 <= "00001101";
			when "0100" => conversor_bit3 <= "10011001";
			when "0101" => conversor_bit3 <= "01001001";
			when "0110" => conversor_bit3 <= "01000001";
			when "0111" => conversor_bit3 <= "00011111";
			when "1000" => conversor_bit3 <= "00000001";
			when "1001" => conversor_bit3 <= "00001001";
			when "1010" => conversor_bit3 <= "00010001"; -- digito A
			when "1011" => conversor_bit3 <= "11000001"; -- digito B
			when "1100" => conversor_bit3 <= "01100011"; -- digito C
			when "1101" => conversor_bit3 <= "10000101"; -- digito D
			when "1110" => conversor_bit3 <= "01100001"; -- digito E
			when others => conversor_bit3 <= "01110001"; -- digito F
		end case;
	end process;
	
end Behavioral;