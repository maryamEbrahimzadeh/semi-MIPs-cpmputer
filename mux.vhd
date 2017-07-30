
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX is
    Port ( I0 : in  STD_LOGIC;
           I1 : in  STD_LOGIC;
           I2 : in  STD_LOGIC;
           I3 : in  STD_LOGIC;
           I4 : in  STD_LOGIC;
           S0 : in  STD_LOGIC;
           S1 : in  STD_LOGIC;
           S2 : in  STD_LOGIC;
           O : out  STD_LOGIC);
end MUX;

architecture Behavioral of MUX is
  

begin
  process (s0,s1,s2)
    begin
  if ( S0='0' and  S1='0' and  S2='0') then
    o<=i0;
  elsif ( S0='1' and S1='0' and S2='0') then 
    o<=i1;
  elsif ( S0='0' and S1='1' and  S2='0') then 
    o<=i2;
  elsif (S0='1' and S1='1' and S2='0') then 
    o<=i3;
  elsif (S0='0' and  S1='0' and  S2='1') then 
    o<=i4;
  else
    o <='Z';
  end if;
end process;
    
	
	
end Behavioral;


