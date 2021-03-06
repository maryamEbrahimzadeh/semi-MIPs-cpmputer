library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder is
    Port ( a : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           b : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           cin : in  STD_LOGIC;
           res : out  STD_LOGIC_VECTOR(7 DOWNTO 0);
           cout : out  STD_LOGIC);
end adder;

architecture Behavioral of adder is

component fullAdder  is port
   ( A : in STD_LOGIC;
 B : in STD_LOGIC;
 Cin : in STD_LOGIC;
 S : out STD_LOGIC;
 Cout : out STD_LOGIC);
end component;

signal s:STD_LOGIC_VECTOR(7 DOWNTO 0);
begin
  
x1:fullAdder port map(a(0),b(0),cin,res(0),s(0));
x2:fullAdder port map(a(1),b(1),s(0),res(1),s(1));
x3:fullAdder port map(a(2),b(2),s(1),res(2),s(2));
x4:fullAdder port map(a(3),b(3),s(2),res(3),s(3));
x5:fullAdder port map(a(4),b(4),s(3),res(4),s(4));
x6:fullAdder port map(a(5),b(5),s(4),res(5),s(5));
x7:fullAdder port map(a(6),b(6),s(5),res(6),s(6));
x8:fullAdder port map(a(7),b(7),s(6),res(7),cout);

end Behavioral;
