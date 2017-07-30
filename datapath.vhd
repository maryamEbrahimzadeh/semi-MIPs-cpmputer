LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY datapath IS
 PORT (
   clk,
   databusoutalu, AandB, AorB, shlB, shrB,notb,AaddB, AsubB, AmulB ,AxorB 
   ,writereg,outwite,writedest,
   imediate,
   clearIR,loadIR
   ,clearAR,loadAR,loadsaddrar,
   clearPC,INCPC,loadPC
   ,cset,creset,srload,
   readmem, writemem
   ,s0,s1,s2:  in std_logic;
   
   instruction : out std_logic_vector(15 downto 0);
    zero : out std_logic

 );
 END datapath;

 ARCHITECTURE dataflow OF datapath IS
   
 component memory is
	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (3 downto 0);
		databus : in std_logic_vector (15 downto 0);
		memout : out std_logic_vector (15 downto 0)
		);
end component;

COMPONENT AR IS 
  port (
 clk: in STD_LOGIC;
 clear :in STD_LOGIC;
 load,loadsaddr :in STD_LOGIC; 
 input,saddr: IN std_logic_vector (3 DOWNTO 0);
 output: OUT std_logic_vector (3 DOWNTO 0):="0000"
 );
 END COMPONENT;
 
COMPONENT PC IS PORT(
   clk: in STD_LOGIC;
 clear :in STD_LOGIC;
 INC :in STD_LOGIC;
 load :in STD_LOGIC; 
 input: IN std_logic_vector (3 DOWNTO 0);
 output: OUT std_logic_vector (3 DOWNTO 0):="0000"
);
 END COMPONENT;
 
 COMPONENT  IR IS
  port (
 clk: in STD_LOGIC;
 clear :in STD_LOGIC;
 load :in STD_LOGIC; 
 input: IN std_logic_vector (15 DOWNTO 0);
 output1: OUT std_logic_vector (15 DOWNTO 0):="0000000000000000"
 );
 end COMPONENT;
  

 COMPONENT  ArithmeticUnit is
          Port (
	      databus :in std_logic_VECTOR(7 DOWNTO 0);
	      a :in std_logic_VECTOR(7 DOWNTO 0);
        b :in std_logic_VECTOR(7 DOWNTO 0);
        cin,borrowin,zeroin,parityin :in std_logic;
        databusoutalu,
        AandB, AorB, shlB, shrB,notb,
        AaddB, AsubB, AmulB ,AxorB : in  STD_LOGIC;
        res : inout  STD_LOGIC_VECTOR(7 DOWNTO 0):="ZZZZZZZZ";
        cout,borrowout,zeroout,parityout : out  STD_LOGIC:='0'
			  );
 END COMPONENT;
 
component  registerfile is
  generic (blocksize : integer := 16);
  port(
    clk : IN STD_LOGIC; -- clock.
    idata : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- input
    write,writedest : IN STD_LOGIC; -- write enable
    imediate : IN STD_LOGIC; 
    addresss1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addresss2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addressd : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Rs1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    Rs2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    outwrite : in std_logic;
    zero : out std_logic
     
  );
end component;

component MUX16 is
    Port ( I0 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I1 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I2 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I3 : in  STD_LOGIC_vector (15 DOWNTO 0);
           I4 : in  STD_LOGIC_vector (15 DOWNTO 0);
           S0 : in  STD_LOGIC;
           S1 : in  STD_LOGIC;
           S2 : in  STD_LOGIC;
           O : out  STD_LOGIC_vector (15 DOWNTO 0));
end component;

 component  statusreg is
  port(
    clk,cset,creset,srload,cout,borrowout,zeroout,parityout: in std_logic;
    cin,borrowin,zeroin,parityin : out std_logic);
  end component ;

 
signal Databus ,o: std_logic_vector (15 DOWNTO 0):="ZZZZZZZZZZZZZZZZ";
signal sregout,IRout,sARout,sPCout,memout:std_logic_vector (15 DOWNTO 0);
signal PCout:std_logic_vector (3 DOWNTO 0);
signal ARout:std_logic_vector (3 DOWNTO 0):="0000";
signal regs1,regs2:std_logic_vector (7 DOWNTO 0);
signal regout:std_logic_vector (7 DOWNTO 0):="00000000";
signal ALUout:std_logic_vector (7 DOWNTO 0);
signal SRCin,srborrowin,srzeroin,srparityin,
  srcout,srborrowout,srzeroout,srparityout:std_logic;
 BEGIN
 aluout<= (others=>'Z');
 databus<= (others=>'Z');
 sARout<="000000000000"&ARout;
 sPCout<="000000000000"&PCout;
 sregout <= "00000000"&regout;
 
  alu1:ArithmeticUnit port map(databus(7 downto 0),regs1,regs2,srcout,srborrowout,srzeroout,srparityout,databusoutalu, AandB, AorB, shlB, shrB,notb,
        AaddB, AsubB, AmulB ,AxorB,ALUout,SRCin,srborrowin,srzeroin,srparityin);
        
  reg : registerfile port map(clk,aluout,writereg,writedest,imediate,irout(11 downto 8),
  irout(7 downto 4),irout(3 downto 0),regs1,regs2,regout,outwite,zero);
  
  
  ir1:IR port map(clk,clearIR,loadIR,Databus,IRout);
    
  
  ar1:AR port map(clk,clearAR,loadAR,loadsaddrar,Databus(3 downto 0),irout(11 downto 8), ARout);
    
  pc1:PC port map(clk,clearPC,INCPC,loadPC,Databus(3 downto 0), PCout);
    
  e1:statusreg port map(clk,cset,creset,srload,srcin,srborrowin,srzeroin,srparityin,
  srcout,srborrowout,srzeroout,srparityout);
    
  mem:memory port map (clk, readmem, writemem,ARout,Databus,memout);
    
  m1:MUX16 port map(memout,"ZZZZZZZZZZZZZZZZ", sPCout,sregout,irout,s0,s1,s2,Databus);
  
  instruction<=IRout;

 END dataflow;
