library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	generic (blocksize : integer := 16);

	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (3 downto 0);
		databus : in std_logic_vector (15 downto 0);
		memout : out std_logic_vector (15 downto 0)
		);
end entity memory;

architecture behavioral of memory is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
begin

	process (clk)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	  begin
		if init = true then
			-- some initiation 
			buffermem(0) := "0000000000001000";
			buffermem(2) := "0000000011111111";
			init := false;
		end if;

		--memout <= (others => 'Z');

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then -- Readiing :)
				if ad >= blocksize then
					memout <= (others => 'Z');
				else
					memout <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				if ad < blocksize then
					buffermem(ad) := databus;
				end if;

			end if;
		end if;
	end process;
end architecture behavioral;