LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
entity PC IS
 port (
 clk: in STD_LOGIC;
 clear :in STD_LOGIC;
 INC :in STD_LOGIC;
 load :in STD_LOGIC; 
 input: IN std_logic_vector (3 DOWNTO 0);
 output: OUT std_logic_vector (3 DOWNTO 0):="0000"
 );
 end PC;
 
 architecture dataflow of PC is
   signal wireout : std_logic_vector(3 downto 0);
 begin
   output <= wireout;
 PROCESS (clk) begin
 
 IF (rising_edge(clk)) THEN
   if(clear='1') then 
     wireout<="0000";
   elsIF (INC = '1') THEN
	        wireout<= wireout+"0001";
    elsif(load='1') then
         wireout <= wireout + input;
 end IF;
  end if;
 end PROCESS;
 END dataflow;
