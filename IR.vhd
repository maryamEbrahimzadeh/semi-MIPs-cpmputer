LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
entity IR IS
 port (
 clk: in STD_LOGIC;
 clear :in STD_LOGIC;
 load :in STD_LOGIC; 
 input: IN std_logic_vector (15 DOWNTO 0);
 output1: OUT std_logic_vector (15 DOWNTO 0):="0000000000000000"
 );
 end IR;
 
 architecture dataflow of IR is
 begin
 PROCESS (clk) begin
 if(clear='1') then 
     output1<="0000000000000000";
 elsIF (rising_edge(clk)) THEN
    if(load='1') then
         output1 <= input;
 end IF;
  end if;
 end PROCESS;
 END dataflow;