library ieee;
use ieee.std_logic_1164.all;

entity main is
	port (
			start				  :  in std_logic; -- Circuito só inicia os calculos com start='1'
			clk   			  :  in std_logic;
			sw					  :  in std_logic_vector(7 downto 0); -- Chaves para percorrer a matriz
			done  			  : out std_logic; -- done='1' acabou os calculos;
			an0fpga			  : out std_logic; -- an ligado ativa o display - K14
			an1fpga			  : out std_logic; -- M13
			an2fpga			  : out std_logic; -- J12
			an3fpga			  : out std_logic; -- F12
			seg				  : out std_logic_vector(6 downto 0);
			led_fpga			  : out std_logic_vector(7 downto 0)); -- Bits de cada display que sao convertidos pelo conversor nibble-bcd
end main;

architecture Behavioral of main is

component registrador4
	port(
		clkReg4   :  in std_logic;
		rstReg4   :  in std_logic;          
		saidaReg4 : out std_logic_vector(3 downto 0)
		);
	end component;

component registrador2
	port(
		incRegSel :  in std_logic;
		clkReg2   :  in std_logic;
		rstReg2   :  in std_logic;          
		saidaReg2 : out std_logic_vector(1 downto 0)
		);
	end component;

component mux4p1
	port(
		seletor   	 :  in std_logic_vector(1 downto 0);
		e0seletor  	 :  in std_logic_vector(3 downto 0);
		e1seletor 	 :  in std_logic_vector(3 downto 0);
		e2seletor 	 :  in std_logic_vector(3 downto 0);
		e3seletor 	 :  in std_logic_vector(3 downto 0);          
		saidaSeletor : out std_logic_vector(3 downto 0)
		);
	end component;

component registrador8
	port(
		clkReg8   :  in std_logic;
		rstReg8   :  in std_logic;          
		saidaReg8 : out std_logic_vector(7 downto 0)
		);
	end component;

component registradorAcc
	port(
		ac 			:  in std_logic;
		dadoRegAcc	:  in std_logic_vector(7 downto 0);
		clkRegAcc   :  in std_logic;
		rstRegAcc   :  in std_logic;          
		saidaRegAcc : out std_logic_vector(7 downto 0)
		);
	end component;
	
component memoriaImput1
  port (
    clka  :  in std_logic;
    wea   :  in std_logic_vector(0 downto 0);
    addra :  in std_logic_vector(2 downto 0);
    dina  :  in std_logic_vector(15 downto 0);
    douta : out std_logic_vector(15 downto 0)
  );
end component;

component memINput2
  port (
    clka  : in std_logic;
    wea   : in std_logic_vector(0 downto 0);
    addra : in std_logic_vector(2 downto 0);
    dina  : in std_logic_vector(15 downto 0);
    douta : out std_logic_vector(15 downto 0)
  );
end component;

component memoriaOut
  port (
    clka  :  in std_logic;
    wea   :  in std_logic_vector(0 downto 0);
    addra :  in std_logic_vector(3 downto 0);
    dina  :  in std_logic_vector(7 downto 0);
    douta : out std_logic_vector(7 downto 0)
  );
end component;

component somador
  port (
    a :  in std_logic_vector(7 downto 0);
    b :  in std_logic_vector(7 downto 0);
    s : out std_logic_vector(7 downto 0)
  );
end component;

component multiplicador5estagios -- Quando criamos, estavamos usando pipeline, mas agora e' um multiplicador normal
	port (
    a :  in std_logic_vector(3 downto 0);
    b :  in std_logic_vector(3 downto 0);
    p : out std_logic_vector(7 downto 0)
  );
end component;               

component registradorInc
	port(
		inc 			: in std_logic;
		clkRegInc 	: in std_logic;
		rstRegInc 	: in std_logic;          
		saidaRegInc : out std_logic_vector(2 downto 0)
		);
end component; 

component registradorInc4
	port(
		inc4 		 :  in std_logic;
		clkReg4   :  in std_logic;
		rstReg4   :  in std_logic;          
		saidaReg4 : out std_logic_vector(3 downto 0)
		);
end component; 

component registradorSaida
	port(
		ld_out        :  in std_logic;
		dado_entrada  :  in std_logic_vector(7 downto 0);
		clkRegSaida   :  in std_logic;
		rstRegSaida   :  in std_logic;          
		saidaRegSaida : out std_logic_vector(7 downto 0)
		);
end component;

component Display
	port(
		input :  in std_logic_vector(15 downto 0); -- Entra um dado de "00000000"&8 bits que vai pra saida do circuito
		clk 	:  in std_logic;
		rst 	:  in std_logic;          
		an0 	:  out std_logic;
		an1 	:  out std_logic;
		an2 	:  out std_logic;
		an3 	:  out std_logic;
		led_d : out std_logic_vector(7 downto 0) -- Sai numeros nos displays de 7 segmentos (8 bits do led_d sao convertidos no conversor)
		);
	END COMPONENT;

signal sigSaida_mux1 			: std_logic_vector(3 downto 0); -- 4 pra 1 com 2 bits de selecao
signal sigSaida_mux2 			: std_logic_vector(3 downto 0);
signal sigSeletor1				: std_logic_vector(1 downto 0);
signal sigSeletor2				: std_logic_vector(1 downto 0);
signal sigSaida_acc     		: std_logic_vector(7 downto 0);
signal sigSaida_Reg8A  		   : std_logic_vector(7 downto 0);
signal sigSaida_Reg8B   		: std_logic_vector(7 downto 0);
signal sigSaida_Somador 		: std_logic_vector(7 downto 0);
signal sigSaida_Multiplicador : std_logic_vector(7 downto 0);
signal sigSaida_reg_sel		   : std_logic_vector(1 downto 0);
signal rstSaida               : std_logic;
signal rstIncGeral				: std_logic;
signal rstRegSel					: std_logic;
signal rst_acc                : std_logic;
signal rstRegIncEndA				: std_logic;
signal rstRegIncEndB				: std_logic;
signal rst_display   			: std_logic;
signal sig_ld_out             : std_logic;
signal sigAc						: std_logic;
signal sigSaida_IncLinha		: std_logic_vector(2 downto 0); -- Endereco para a memoria A
signal sigSaida_IncColuna		: std_logic_vector(2 downto 0); -- Endereco para a memoria B
signal sigSaida_IncGeral		: std_logic_vector(3 downto 0); -- Para a memoria de resultado (C)
signal sigIncLinha            : std_logic;   -- inc_a
signal sigIncColuna           : std_logic;   -- inc_b
signal sigIncGeral            : std_logic;   -- inc_c
signal we                     : std_logic_vector(0 downto 0);
signal saidaParaMemResultado  : std_logic_vector(7 downto 0);
signal mem_inA						: std_logic_vector(15 downto 0);
signal mem_inB						: std_logic_vector(15 downto 0);
signal mem_inResultado			: std_logic_vector(7 downto 0);
signal mem_outA					: std_logic_vector(15 downto 0);
signal mem_outB					: std_logic_vector(15 downto 0);
signal mem_outResultado			: std_logic_vector(7 downto 0);
signal SweaA                  : std_logic_vector(0 downto 0); 
signal SweaB                  : std_logic_vector(0 downto 0);
signal t1,t2,t3,t4				: std_logic;
signal inc_sel						: std_logic;
signal SigDisplay					: std_logic_vector(15 downto 0);

type   T_STATE is (s0,s1,s2,s3,s4,s5,s6,s7); 
signal estado, prox_estado : T_STATE;

---------
begin --|
---------

-- Testes
t1 <= '1' when sigSaida_reg_sel   = "11"   else '0';
t2 <= '1' when sigSaida_IncLinha  = "100"  else '0'; -- Aumentou depth das memorias de entrada
t3 <= '1' when sigSaida_IncColuna = "100"  else '0';
t4 <= '1' when sigSaida_IncGeral  = "1111" else '0';


memA : memoriaImput1
  PORT MAP (
    clka => clk,
    wea => SweaA,
    addra => sigSaida_IncLinha,
    dina => mem_inA,
    douta => mem_outA    -- Seletor do lado esquerdo
  );
  
memB : memINput2
  PORT MAP (
    clka => clk,
    wea => SweaB,
    addra => sigSaida_IncColuna,
    dina => mem_inB, 	 -- Nao usa
    douta => mem_outB    -- Seletor do lado direito
  );

memoriaResultado : memoriaOut
  port map (
    clka  => clk,
    wea   => we,                 -- Ativa escrita dos dados em s4
    addra => sigSaida_IncGeral,   -- Para leitura
    dina  => saidaParaMemResultado,
    douta => mem_outResultado);
	 

mux1: mux4p1 
	port map(
		seletor 	    => sigSaida_reg_sel,
		e0seletor	 => mem_outA(15 downto 12),
		e1seletor	 => mem_outA(11 downto 8),
		e2seletor 	 => mem_outA(7 downto 4),
		e3seletor	 => mem_outA(3 downto 0),
		saidaSeletor => sigSaida_mux1
	);

mux2: mux4p1 
	port map( 
		seletor 		 => sigSaida_reg_sel,               
		e0seletor 	 => mem_outB(15 downto 12),
		e1seletor 	 => mem_outB(11 downto 8),
		e2seletor 	 => mem_outB(7 downto 4),
		e3seletor 	 => mem_outB(3 downto 0),
		saidaSeletor => sigSaida_mux2
	);

endA: registradorInc
	port map(
		inc => sigIncLinha, --Apenas ativa o incremento que vai para a saida do registrador de inc
		clkRegInc   => clk,
		rstRegInc   => rstRegIncEndA,
		saidaRegInc => sigSaida_IncLinha
	);

endB: registradorInc
	port map(
		inc => sigIncColuna, --Apenas ativa o incremento que vai para a saida do registrador de inc
		clkRegInc   => clk,
		rstRegInc   => rstRegIncEndB,
		saidaRegInc => sigSaida_IncColuna
	);
	
acc: registradorAcc port map(
		ac          => sigAc,
		dadoRegAcc  => sigSaida_Somador,         
		clkRegAcc   => clk,
		rstRegAcc   => rst_acc,
		saidaRegAcc => sigSaida_acc
	);

adder : somador
  port map (
    a => sigSaida_acc,
    b => sigSaida_Multiplicador,
    s => sigSaida_Somador
  );
  
multiplier : multiplicador5estagios
  port map (
    a => sigSaida_mux1,
    b => sigSaida_mux2,
    p => sigSaida_Multiplicador  
  );

reg_sel: registrador2 
	port map(
		incRegSel => inc_sel,
		clkReg2   => clk,
		rstReg2   => rstRegSel,
		saidaReg2 => sigSaida_reg_sel
	);

inc_geral: registradorInc4
	port map(
		inc4      => sigIncGeral,
		clkReg4   => clk,
		rstReg4   => rstIncGeral,
		saidaReg4 => sigSaida_IncGeral
	);

saida: registradorSaida 
	port map(
		ld_out        => sig_ld_out,
		dado_entrada  => sigSaida_acc,
		clkRegSaida   => clk,
		rstRegSaida   => rstSaida,
		saidaRegSaida => saidaParaMemResultado
	);

SigDisplay <= "00000000"&saidaParaMemResultado;

display_fpga: Display PORT MAP(
		input => SigDisplay, -- Adaptação para utilizar o display
		clk => clk,
		rst => rst_display,
		an0 => an0fpga,
		an1 => an1fpga,
		an2 => an2fpga,
		an3 => an3fpga,
		led_d => led_fpga
	);
-- Com as sw acessa as posicoes de memoria

-- Parte de controle
-- FSM com 1 process
process(clk)
begin
	if start='0' then
		estado<=s0;
	elsif (clk'event and clk='1') then
		case estado is
			when s0 => 
						  rstRegIncEndA <= '1';
						  rstRegIncEndB <= '1';
						  rst_acc 		 <= '1';
						  rstRegSel 	 <= '1';
						  rstIncGeral 	 <= '1';
						  rstSaida 		 <= '1';
						  rst_display   <= '1';
						  inc_sel 		 <= '0';
						  sigAc 			 <= '0';
						  sig_ld_out 	 <= '0';
						  we     		 <= "0";
						  sigIncLinha   <= '0';
						  sigIncColuna  <= '0';
						  sigIncGeral   <= '0';
						  done          <= '0';
						  sig_ld_out    <= '0';
						  sigIncGeral   <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  if    start='0' then estado<=s0;
						  elsif start='1' then estado<=s1; 
						  end if;
						  
			when s1 => 
						  sigAc 			 <= '1';
						  inc_sel 		 <= '0';
						  rstRegIncEndA <= '0';
						  rstRegIncEndB <= '0';
						  rst_acc 		 <= '0';
						  rstRegSel 	 <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  rst_display   <= '0';
						  sig_ld_out 	 <= '0';
						  we     		 <= "0";
						  sigIncGeral   <= '0';
						  sig_ld_out    <= '0';
						  done   		 <= '0';
						  sigIncLinha   <= '0';
						  sigIncColuna  <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  estado        <=  s2;
 
			when s2 => 
						  inc_sel 		 <= '1';
						  sigAc 			 <= '0';
						  rstRegIncEndA <= '0';
						  rstRegIncEndB <= '0';
						  rst_acc 		 <= '0';
						  rstRegSel 	 <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  rst_display   <= '0';
						  sig_ld_out 	 <= '0';
						  we 				 <= "0";
						  sigIncGeral   <= '0';
						  sigIncColuna  <= '0';
						  done   		 <= '0';
						  sig_ld_out    <= '0';
						  sigIncLinha   <= '0';
						  sigIncColuna  <= '0';
						  sigIncGeral   <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  if    t1='0' then estado<=s1;
						  elsif t1='1' then estado<=s3;
						  end if;
			
			when s3 => 
						  sig_ld_out    <= '1';
						  rstRegSel 	 <= '1';
						  rstRegIncEndA <= '0';
						  rstRegIncEndB <= '0';
						  rst_acc 		 <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  rst_display   <= '0';
						  inc_sel 		 <= '0';
						  sigAc 			 <= '0';
						  we     		 <= "0";
						  sigIncGeral   <= '0';
						  sigIncColuna  <= '0';
						  done   		 <= '0';
						  sigIncLinha   <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  estado  		 <=  s4;
			
			when s4 => 
						  rst_acc       <= '1';
						  we            <= "1";
						  rstRegSel 	 <= '0';
						  inc_sel 		 <= '0';
						  sigAc 			 <= '0';
						  rstRegIncEndA <= '0';
						  rstRegIncEndB <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  rst_display   <= '0';
						  sig_ld_out 	 <= '0';
						  sigIncGeral   <= '0';
						  sigIncColuna  <= '0';
						  done   		 <= '0';
						  sigIncLinha   <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  estado        <=  s5;
			
			when s5 => 
						  sigIncLinha   <= '1'; -- inc_a
						  sigIncGeral   <= '1'; -- inc_c
						  rst_acc       <= '0';
						  we            <= "0";
						  rstRegSel 	 <= '0';
						  inc_sel 		 <= '0';
						  sigAc 			 <= '0';
						  rstRegIncEndA <= '0';
						  rstRegIncEndB <= '0';
						  rst_acc 		 <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  rst_display   <= '0';
						  sig_ld_out 	 <= '0';
						  we     		 <= "0";
						  sigIncColuna  <= '0';
						  done   		 <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  if 	  t2='0' then estado<=s1;
						  elsif t2='1' then estado<=s6;
						  end if;
						  
			when s6 => 
						  sigIncColuna  <= '1'; -- inc_b
						  rstRegIncEndA <= '1'; -- rst_a
						  sigIncLinha   <= '0';
						  sigIncGeral   <= '0';
						  rst_acc       <= '0';
						  we            <= "0";
						  rstRegSel 	 <= '0';
						  rst_display   <= '0';
						  inc_sel 		 <= '0';
						  sigAc 			 <= '0';
						  rstRegIncEndB <= '0';
						  rst_acc 		 <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  sig_ld_out 	 <= '0';
						  we     		 <= "0";
						  done   		 <= '0';
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  if 	  t3='0' then estado<=s1;
						  elsif t3='1' then estado<=s7;
						  end if;
						  
			when s7 => 
						  done 			 <= '1';
						  sigIncColuna  <= '0';
						  sigIncLinha   <= '0';
						  sigIncGeral   <= '0';
						  rst_acc       <= '0';
						  we            <= "0";
						  rstRegSel 	 <= '0';
						  inc_sel 		 <= '0';
						  sigAc 			 <= '0';
						  rstRegIncEndA <= '0';
						  rstRegIncEndB <= '0';
						  rst_acc 		 <= '0';
						  rstIncGeral 	 <= '0';
						  rstSaida 		 <= '0';
						  rst_display   <= '0';
						  sig_ld_out 	 <= '0';
						  sigIncColuna  <= '0';	
						  SweaA 			 <= "0";
						  SweaB 			 <= "0";
						  estado 		 <=  s7;  
		end case;
	end if;
end process;

end Behavioral;