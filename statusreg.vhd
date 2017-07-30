library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity statusreg is
  port(
    clk,cset,creset,srload,cout,borrowout,zeroout,parityout: in std_logic;
    cin,borrowin,zeroin,parityin : out std_logic:='0');
  end;
  architecture arc of statusreg is 
  begin
  process(clk,cset,creset,srload,cout)
    begin
      if clk'event and clk = '0' and cset ='1' then
        cin <= '1';
    end if;
     if  clk'event and clk = '0' and creset ='1' then
        cin <= '0';
    end if;
     if  clk'event and clk = '0' and srload ='1' then
      cin<= cout;
      borrowin<=borrowout;
      zeroin<=zeroout;
      parityin<=parityout;
    end if;
  end process;
end;
