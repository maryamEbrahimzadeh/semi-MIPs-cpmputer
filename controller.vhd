LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY controller IS PORT(
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
end controller;


architecture description of controller is

type state is (reset,fetch1,fetch2,fetch3,decode0,decode,exec1,exec2,exec3);
signal peresents,nexts: state;

CONSTANT aaddbc : std_logic_vector(3 DOWNTO 0) := 
	"0000";
CONSTANT asubbc : std_logic_vector(3 DOWNTO 0) := 
	"0001";
CONSTANT aorbc : std_logic_vector(3 DOWNTO 0) := 
	"0010";
CONSTANT axorbc : std_logic_vector(3 DOWNTO 0) := 
	"0011";
CONSTANT notbc : std_logic_vector(3 DOWNTO 0) := 
	"0100";
CONSTANT amulbc : std_logic_vector(3 DOWNTO 0) := 
	"0101";
CONSTANT aandbc : std_logic_vector(3 DOWNTO 0) := 
	"0110";
CONSTANT addic : std_logic_vector(3 DOWNTO 0) := 
	"0111";
CONSTANT andic : std_logic_vector(3 DOWNTO 0) := 
	"1000";
CONSTANT oric : std_logic_vector(3 DOWNTO 0) := 
	"1001";
CONSTANT loadc : std_logic_vector(3 DOWNTO 0) := 
	"1010";
CONSTANT storec : std_logic_vector(3 DOWNTO 0) := 
	"1011";
CONSTANT shrc : std_logic_vector(3 DOWNTO 0) := 
	"1100";
CONSTANT shlc : std_logic_vector(3 DOWNTO 0) := 
	"1101";
CONSTANT jumpc : std_logic_vector(3 DOWNTO 0) := 
	"1110";
CONSTANT brzc : std_logic_vector(3 DOWNTO 0) := 
	"1111";
	 
begin
  PROCESS (irout,peresents, externalreset)
    begin
      databusoutalu<='0';
      loadsaddrar<='0';
       AandB<='0';
       AorB<='0';
       shlB<='0';
       shrB<='0';
       notb<='0';
       AaddB<='0';
       AsubB<='0';
       AmulB<='0';
       AxorB<='0';
       writereg<='0';
       writedestreg<='0';
       outwite<='0';
       imediate<='0';
       clearIR<='0';
       loadIR<='0';
       clearAR<='0';
       loadAR<='0';
       clearPC<='0';
       INCPC<='0';
       loadPC<='0';
       cset<='0';
       creset<='0';
       srload<='0';
       readmem<='0';
       writemem<='0';
       s0<='1';
       s1<='1';
       s2<='1';
 
    IF externalreset = '1' THEN
					nexts <= reset;
		ELSE
			CASE peresents IS
				 
				WHEN reset => 
				  -- reset pc
					clearpc <= '1';
					creset <= '1';
					nexts <= fetch1;
					------------------------------------ 
				WHEN fetch1 => 
				  -- pc is on bus
					s2<='0';s1<='1';s0<='0';
					loadar <='1';
					nexts <= fetch2;
					------------------------------------ 
				WHEN fetch2 =>
				  --now pc is on ar we cn read and put on bus
				  readmem <= '1';
				  nexts <= fetch3;
				-----------------------------------------
				WHEN fetch3 =>
				  s2<='0';s1<='0';s0<='0';
				  loadir <= '1';
				  nexts <= decode0;
				  -------------------------------------
				WHEN decode0 =>
				  if(irout(15 downto 12)=aaddbc or irout(15 downto 12)=asubbc or irout(15 downto 12)=aorbc 
				   or irout(15 downto 12)=axorbc or irout(15 downto 12)=notbc or irout(15 downto 12)=amulbc 
				   or irout(15 downto 12)=aandbc ) then
				       imediate <= '0';
				   else 
				     --even for jump 
				        imediate <= '1';
				   end if;
				   if irout(15 downto 12)=loadc then
				     loadsaddrar<='1';
				     nexts<=decode;
				   elsif irout(15 downto 12)=storec then
				      loadsaddrar<='1';
				      writedestreg<='1';
				      nexts<=decode;
				   elsif irout(15 downto 12)=jumpc then
				      s2<='1';s1<='0';s0<='0';
				      loadpc<='1';
				      nexts<=fetch1; 
				    elsif (irout(15 downto 12)=brzc ) then
				      if zero='1' then 
				      s2<='1';s1<='0';s0<='0';
				      loadpc<='1';
				      nexts<=fetch1; 
				      else
				        incpc<='1';
				        nexts<=fetch1;
				        end if;
				   else 
				     nexts<=decode;     
				   end if;
				   
				   
				    ------------------------------
			
				WHEN decode =>
				  --now instruction is on irout
				  --r-type
				  --i type
				  if(irout(15 downto 12)=aaddbc or irout(15 downto 12)=addic) then
				     aaddb <='1';
				  elsif (irout(15 downto 12)=asubbc) then
				    asubb <='1';
				  elsif (irout(15 downto 12)=aorbc or irout(15 downto 12)=oric) then
				    aorb <='1';
				  elsif (irout(15 downto 12)=axorbc) then
				    axorb <='1';
				  elsif (irout(15 downto 12)=notbc) then
				    notb <='1';
				  elsif (irout(15 downto 12)=amulbc) then
				    amulb <='1';
				  elsif (irout(15 downto 12)=aandbc or irout(15 downto 12)=andic) then
				    aandb <='1';
				  elsif (irout(15 downto 12)=shrc) then
				    shrb <= '1';
				  elsif (irout(15 downto 12)=shlc) then
				    shlb <= '1';
				  elsif irout(15 downto 12)=loadc then
				     readmem <= '1';
				  elsif irout(15 downto 12)=storec then
				    s2<='0';s1<='1';s0<='1';
				  end if;
				  
				  nexts <= exec1;
				  ------------------------------------
				 WHEN exec1 =>
				   if(irout(15 downto 12)=aaddbc or irout(15 downto 12)=asubbc or irout(15 downto 12)=aorbc 
				   or irout(15 downto 12)=axorbc or irout(15 downto 12)=notbc or irout(15 downto 12)=amulbc
				   or irout(15 downto 12)=aandbc
				   or irout(15 downto 12)=oric or   irout(15 downto 12)=andic  or irout(15 downto 12)=addic
				   or irout(15 downto 12)=shrc or irout(15 downto 12)=shlc) then
				     srload <='1';
				     writereg<='1';
				     INCPC<='1';
				     nexts<=fetch1;
				   elsif irout(15 downto 12)=loadc then
				      s2<='0';s1<='0';s0<='0';
				      databusoutalu<='1';
				      nexts <= exec2;
				   elsif irout(15 downto 12)=storec then
				      s2<='0';s1<='1';s0<='1';
				      writemem<='1';
				      INCPC<='1';
				      nexts <= fetch1;
				   
				   end if;
				 ----------------------------------------
				 WHEN exec2 =>
				   if irout(15 downto 12)=loadc then
				     s2<='0';s1<='0';s0<='0';
				     databusoutalu<='1';
				     writereg<='1';
				     INCPC<='1';
				     nexts <= fetch1;
				   end if;		
				 ------------------------------------------		   
				  
				WHEN others =>
 
			END CASE;
		END IF;
	END PROCESS;
 
 
 
 
 
 
 	PROCESS (clk, externalreset)
		BEGIN
			IF clk'EVENT AND clk = '1' THEN
				peresents <= nexts;
			END IF;
	END PROCESS;
   
end description;



