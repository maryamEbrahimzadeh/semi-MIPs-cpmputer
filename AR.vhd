LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
entity AR IS
 port (
 clk: in STD_LOGIC;
 clear :in STD_LOGIC;
 load,loadsaddr :in STD_LOGIC; 
 input,saddr: IN std_logic_vector (3 DOWNTO 0);
 output: OUT std_logic_vector (3 DOWNTO 0):="0000"
 );
 end AR;
 
 architecture dataflow of AR is
 begin
 PROCESS (clk) begin
 if(clear='1') then 
     output<="0000";
 elsIF (rising_edge(clk)) THEN
    
      if(load='1') then
         output <= input;
      elsif loadsaddr ='1' then
        output <= saddr;
			end if;
 
  end if;
 end PROCESS;
 END dataflow;
