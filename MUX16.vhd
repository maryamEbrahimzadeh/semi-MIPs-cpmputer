
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX16 is
    Port ( I0 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I1 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I2 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I3 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I4 : in  STD_LOGIC_vector (15 DOWNTO 0);
           S0 : in  STD_LOGIC;
           S1 : in  STD_LOGIC;
           S2 : in  STD_LOGIC;
           O : out  STD_LOGIC_vector (15 DOWNTO 0));
end MUX16;

architecture Behavioral of MUX16 is
component MUX is
    Port ( I0 : in  STD_LOGIC;
           I1 : in  STD_LOGIC;
           I2 : in  STD_LOGIC;
           I3 : in  STD_LOGIC;
           I4 : in  STD_LOGIC;
           S0 : in  STD_LOGIC;
           S1 : in  STD_LOGIC;
           S2 : in  STD_LOGIC;
           O : out  STD_LOGIC);
end component;
begin
a1:MUX port map (I0(0),I1(0),I2(0),I3(0),I4(0),s0,s1,s2,O(0));
a2:MUX port map (I0(1),I1(1),I2(1),I3(1),I4(1),s0,s1,s2,O(1));
a3:MUX port map (I0(2),I1(2),I2(2),I3(2),I4(2),s0,s1,s2,O(2));
a4:MUX port map (I0(3),I1(3),I2(3),I3(3),I4(3),s0,s1,s2,O(3));
a5:MUX port map (I0(4),I1(4),I2(4),I3(4),I4(4),s0,s1,s2,O(4));
a6:MUX port map (I0(5),I1(5),I2(5),I3(5),I4(5),s0,s1,s2,O(5));
a7:MUX port map (I0(6),I1(6),I2(6),I3(6),I4(6),s0,s1,s2,O(6));
a8:MUX port map (I0(7),I1(7),I2(7),I3(7),I4(7),s0,s1,s2,O(7));
a9:MUX port map (I0(8),I1(8),I2(8),I3(8),I4(8),s0,s1,s2,O(8));
a10:MUX port map (I0(9),I1(9),I2(9),I3(9),I4(9),s0,s1,s2,O(9));
a11:MUX port map (I0(10),I1(10),I2(10),I3(10),I4(10),s0,s1,s2,O(10));
a12:MUX port map (I0(11),I1(11),I2(11),I3(11),I4(11),s0,s1,s2,O(11));
a13:MUX port map (I0(12),I1(12),I2(12),I3(12),I4(12),s0,s1,s2,O(12));
a14:MUX port map (I0(13),I1(13),I2(13),I3(13),I4(13),s0,s1,s2,O(13));
a15:MUX port map (I0(14),I1(14),I2(14),I3(14),I4(14),s0,s1,s2,O(14));
a16:MUX port map (I0(15),I1(15),I2(15),I3(15),I4(15),s0,s1,s2,O(15));
end Behavioral;

