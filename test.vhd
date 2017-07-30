library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ALU is
  port(
    A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    cin : in std_logic;
    zin : in std_logic;
    b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb : in std_logic;
    cout : out std_logic;
    zout :  out std_logic;
    aluout : out std_logic_vector(15 downto 0)
  );
end entity ;
architecture aluarc of ALU is
  --adder component
  component sixteen_bit_adder is
	port (
	  a, b : in std_logic_vector(15 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		sum : out std_logic_vector(15 downto 0)
		);
end component;
--comparetor component
component cmp16 is
  port (  
	  A,B   : in std_logic_vector(15 downto 0);
	  aeqb, altb, agtb  : out std_logic
   );
end component;

signal add,subsig1,subsig2,nb,ncinvec,twicecompbsig :std_logic_vector(15 downto 0);
signal eqsig,lsig,gsig,ncin,ctemp: std_logic;
signal coutsig,zoutsig : std_logic:='0';
signal x,y  :std_logic_vector(7 downto 0);

begin
  
 aluout<="ZZZZZZZZZZZZZZZZ";
  x <= a (7 downto 0);
  y <= b (7 downto 0);
  
  ncin <= cin xor '1';
  ncinvec <= "111111111111111" & ncin;
  nb <= b xor "1111111111111111";
  twicecompbmodule : sixteen_bit_adder port map(nb,"0000000000000000",'1',ctemp,twicecompbsig);
  adder : sixteen_bit_adder port map (a,b,cin,coutsig,add);
  subtractor : sixteen_bit_adder port map (a,nb,'1',ctemp,subsig1);
  subtractor2 : sixteen_bit_adder port map (subsig1,ncinvec,'1',ctemp,subsig2);
  comparator : cmp16 port map (a,b,eqsig,lsig,gsig);

  process(b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb )
   variable mulres0,mulres1,mulres2,mulres3,mulres4,mulres5,mulres6,mulres7  :integer:=0;
   begin
    if b15to0='1' then 
      aluout <=  b ;
      cout<=cin; zout<=zin;
      
    elsif  amulb ='1' then
      
    if y(0) = '1' then
       mulres0 := to_integer(unsigned("00000000" & x));
     end if;
    if y(1) = '1' then
       mulres1 := to_integer(unsigned("0000000" & x & "0"));
     end if; 
    if y(2) = '1' then
       mulres2 := to_integer(unsigned("000000" & x & "00"));
     end if;  
    if y(3) = '1' then
       mulres3 := to_integer(unsigned("00000" & x & "000"));
     end if; 
    if y(4) = '1' then
       mulres4 := to_integer(unsigned("0000" & x & "0000"));
     end if; 
    if y(5) = '1' then
       mulres5 := to_integer(unsigned("000" & x & "00000"));
     end if; 
    if y(6) = '1' then
       mulres6 :=to_integer(unsigned("00" & x & "000000"));
     end if; 
    if y(7) = '1' then
       mulres7 :=to_integer(unsigned( "0" & x & "0000000"));
     end if; 
     aluout <=  std_logic_vector(to_unsigned(mulres0+mulres1+mulres2+mulres3+mulres4+mulres5+mulres6+mulres7,aluout'length));
         
         
    elsif   aandb ='1' then
      aluout <= a and b;
      cout<=cin; zout<=zin;
    elsif   aorb ='1' then
      aluout <= a or b;
      cout<=cin; zout<=zin;
    elsif   notb ='1' then
      aluout <= b xor "1111111111111111";
      cout<=cin; zout<=zin;
    elsif   aaddb ='1' then
      aluout <= add;
      cout <= coutsig;
      zout <= zin;
    elsif   asubb ='1' then
      aluout <= subsig2;
      cout<=cin; zout<=zin;
      cout<=cin; zout<=zin;
    elsif   axorb ='1' then
      aluout <= a xor b;
      cout<=cin; zout<=zin;
    elsif   acompb ='1' then
      if eqsig ='1' then 
        zout <='1';
     elsif gsig ='1' then
        cout <= '1';
      end if;
    elsif shrB='1' then
      aluout <= '0' & b(15 downto 1);
      cout<=cin; zout<=zin;
    elsif shlB='1' then
      aluout <=  b(14 downto 0) & '0';
      cout<=cin; zout<=zin;
    elsif twicecompb='1' then
      aluout <=  twicecompbsig;
    
    end if;
  end process;
      
    
    
    
end;


library IEEE;
use IEEE.std_logic_1164.all;

entity six_bit_adder is
	port (
	 a, b : in std_logic_vector(5 downto 0);
		c_in : in std_logic;
		sum : out std_logic_vector(5 downto 0)
		);
end entity;

architecture arch_six_bit_adder of six_bit_adder is
	component fulladdr is
		port (a, b, c_in : in std_logic;
			sum, c_out : out std_logic);
	end component fulladdr;
	
	signal c : std_logic_vector(6 downto 0);
	--for all:fulladdr use entity work.fulladdr(arch_fulladdr);
begin
	c(0) <= c_in;
	fa0 : fulladdr port map (a(0), b(0), c(0), sum(0), c(1));
	fa1 : fulladdr port map (a(1), b(1), c(1), sum(1), c(2));
	fa2 : fulladdr port map (a(2), b(2), c(2), sum(2), c(3));
	fa3 : fulladdr port map (a(3), b(3), c(3), sum(3), c(4));
	fa4 : fulladdr port map (a(4), b(4), c(4), sum(4), c(5));
	fa5 : fulladdr port map (a(5), b(5), c(5), sum(5), c(6));
end architecture arch_six_bit_adder;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity cmp16 is
  port (  
	  A,B   : in std_logic_vector(15 downto 0);
	  aeqb, altb, agtb  : out std_logic
   );
end cmp16;

architecture a of cmp16 is
        
begin

  aeqb <= '1' when (a = b) else '0';
  altb <= '1' when (a < b) else '0';
  agtb <= '1' when (a > b) else '0';

end;

--The operators =, /=, <=, <, >, >= are defined in the std_logic_arith package which is part of the IEEE library.


