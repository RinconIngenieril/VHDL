--Prescaler
--Enrique Gómez

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
	port(clk_in : in std_logic;
			clk_out : out std_logic);
end prescaler;

architecture a of prescaler is

	signal counter : unsigned (25 downto 0) := (others=>'0');
	signal clk_local : std_logic := '0';
	
begin

	process(clk_in)
	begin
		if clk_in'event and clk_in = '1' then
			if to_integer(counter) < 50000000 then
				counter <= counter + 1;
			else
				clk_local <= not clk_local;
				counter <= (others=>'0');
			end if;
		end if;
	end process;
	
	clk_out <= clk_local;


end a;