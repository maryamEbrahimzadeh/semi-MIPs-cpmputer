Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ArithmeticUnit is
    Port (
	      databus :in std_logic_VECTOR(7 DOWNTO 0);
	      a :in std_logic_VECTOR(7 DOWNTO 0);
        b :in std_logic_VECTOR(7 DOWNTO 0);
        cin,borrowin,zeroin,parityin :in std_logic;
        databusoutalu,
        AandB, AorB, shlB, shrB,notb,
        AaddB, AsubB, AmulB ,AxorB : in  STD_LOGIC;
        res : inout  STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";
        cout,borrowout,zeroout,parityout : out  STD_LOGIC:='0'
			  );
 END entity;


architecture Behavioral of ArithmeticUnit is
  
  component adder is 
        Port ( a : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           b : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           cin : in  STD_LOGIC;
           res : out  STD_LOGIC_VECTOR(7 DOWNTO 0);
           cout : out  STD_LOGIC);
  end component;

signal bnot,sub,subres,sumres:STD_LOGIC_VECTOR(7 DOWNTO 0);
signal multires:STD_LOGIC_VECTOR(15 DOWNTO 0);
signal co1,co2,cnot,c:STD_LOGIC:='Z';
signal x,y  :std_logic_vector(7 downto 0);
signal i : integer;
begin
  
  i <= to_integer(unsigned(b));
  x <= a ;
  y <= b ;
  cnot<= not(cin);
  bnot<= not(b); 
  sum : adder port map(a,b,cin,sumres,co1);
  sub1: adder port map(a,bnot,cnot,sub,c);
  sub2: adder port map("00000001",sub,c,subres,co2);
 
  
process(AandB, AorB, shlB, shrB,notb,
        AaddB, AsubB, AmulB ,AxorB ,databusoutalu )
   variable mulres0,mulres1,mulres2,mulres3,mulres4,mulres5,mulres6,mulres7  :integer:=0;
   begin
    
    parityout <= ((res(0) xor res(1)) xor (res(2) xor res(3)))  xor ((res(4) xor res(5)) xor (res(6) xor res(7)) );
    if AandB ='1' then--A and B
      res <= a and b;
    elsif databusoutalu='1' then
      res <= databus;
    elsif  AorB ='1' then --A or B
      res <= a or b;
    elsif AaddB ='1' then -- A+B
      res<=sumres;
      cout<=co1;
    elsif AsubB ='1' then -- A-B
      res<=subres;
      borrowout<=co2;
      if subres="00000000" then
        zeroout<='1';
      end if;
    elsif notb ='1' then --not b
      res <= bnot;
    elsif shrB='1' then--right -> logic shift
      --check imedate
      if b="00000000" then--0
        res <=  a(7 downto 0);
      elsif b="00000001" then--1
        res <= '0' & a(7 downto 1);
      elsif b="00000010" then--2
        res <= "00" & a(7 downto 2);
      elsif b="00000011" then--3
        res <= "000" & a(7 downto 3);
      elsif b="00000100" then--4
        res <= "0000" & a(7 downto 4);
      elsif b="00000101" then--5
        res <= "00000" & a(7 downto 5);
      elsif b="00000110" then--6
        res <= "000000" & a(7 downto 6);
      elsif b="00000111" then--7
        res <= "0000000" & a(7 downto 7);
      else
        res <= "00000000" ;
    end if;
      
    elsif shlB='1' then-- <-
       --check imedate
      if b="00000000" then--0
        res <=  a(7 downto 0);
      elsif b="00000001" then--1
        res <=  a(7 downto 1) & '0';
      elsif b="00000010" then--2
        res <=  a(7 downto 2) & "00" ;
      elsif b="00000011" then--3
        res <=  a(7 downto 3) & "000";
      elsif b="00000100" then--4
        res <=  a(7 downto 4) & "0000";
      elsif b="00000101" then--5
        res <=  a(7 downto 5) & "00000" ;
      elsif b="00000110" then--6
        res <=  a(7 downto 6) & "000000";
      elsif b="00000111" then--7
        res <=  a(7 downto 7) & "0000000";

      else
        res <= "00000000" ;
    end if;
    
    elsif  AxorB ='1' then --A xor B
      res(7 downto 0) <= a xor b;
    elsif AmulB ='1' then --A * B
      --mul
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
     res <=  std_logic_vector(to_unsigned(mulres0+mulres1+mulres2+mulres3+mulres4+mulres5+mulres6+mulres7,res'length));
     --end mul
    end if;
  end process;
end Behavioral;

