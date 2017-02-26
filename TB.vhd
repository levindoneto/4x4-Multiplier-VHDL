--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:44:49 07/04/2016
-- Design Name:   
-- Module Name:   C:/Users/lgtneto/Desktop/sd/trabalho3/TBnovoteste.vhd
-- Project Name:  trabalho3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TBnovoteste IS
END TBnovoteste;
 
ARCHITECTURE behavior OF TBnovoteste IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         start : IN  std_logic;
         clk : IN  std_logic;
         an0fpga : OUT  std_logic;
         an1fpga : OUT  std_logic;
         an2fpga : OUT  std_logic;
         an3fpga : OUT  std_logic;
         done : OUT  std_logic;
         led_fpga : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal an0fpga : std_logic;
   signal an1fpga : std_logic;
   signal an2fpga : std_logic;
   signal an3fpga : std_logic;
   signal done : std_logic;
   signal led_fpga : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          start => start,
          clk => clk,
          an0fpga => an0fpga,
          an1fpga => an1fpga,
          an2fpga => an2fpga,
          an3fpga => an3fpga,
          done => done,
          led_fpga => led_fpga
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      start <= '1';
		wait for 10 ns;

      wait;
   end process;

END;
