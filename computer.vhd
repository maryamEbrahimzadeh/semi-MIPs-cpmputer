library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity computer is 
port( clk,externalreset : in std_logic);
end entity;
  
  architecture rtl of computer is
  component  datapath is
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
  end component;
  
  --controller
   component  controller IS
	PORT(
    clk,externalreset,zero : in STD_LOGIC;
	  IRout: in STD_LOGIC_VECTOR(15 DOWNTO 0):="ZZZZZZZZZZZZZZZZ";
		databusoutalu,AandB, AorB, shlB, shrB,notb,AaddB, AsubB, AmulB ,AxorB 
   ,writereg,outwite,writedestreg,
   imediate,
   clearIR,loadIR
   ,clearAR,loadAR,loadsaddrar,
   clearPC,INCPC,loadPC
   ,cset,creset,srload,
   readmem, writemem
   ,s0,s1,s2:  out std_logic);
	end component;
	
	
	
	--signals
    signal 
		databusoutalu,AandB, AorB, shlB, shrB,notb,AaddB, AsubB, AmulB ,AxorB 
   ,writereg,outwite,zero,writedest,
   imediate, 
   clearIR,loadIR
   ,clearAR,loadAR,loadsaddrar,
   clearPC,INCPC,loadPC
   ,cset,creset,srload,
   readmem, writemem
   ,s0,s1,s2 : std_logic;
   
   signal irout : std_logic_vector(15 downto 0);
  
  begin
     controllermodule : controller port map( 
    clk,externalreset,zero,
	  IRout,
		databusoutalu,AandB, AorB, shlB, shrB,notb,AaddB, AsubB, AmulB ,AxorB 
   ,writereg,outwite,writedest,
   imediate,
   clearIR,loadIR
   ,clearAR,loadAR,loadsaddrar,
   clearPC,INCPC,loadPC
   ,cset,creset,
   srload,
   readmem, writemem
   ,s0,s1,s2);
                                      
      
     datapathmodule : datapath port map (
      clk,
   databusoutalu, AandB, AorB, shlB, shrB,notb,AaddB, AsubB, AmulB ,AxorB 
   ,writereg,outwite,writedest,
   imediate,
   clearIR,loadIR
   ,clearAR,loadAR,loadsaddrar,
   clearPC,INCPC,loadPC
   ,cset,creset,srload,
   readmem, writemem
   ,s0,s1,s2,
   irout,zero);                                          

end ;



