--Shift
--Simple 8 bits SIPO shift register
--Enrique Gómez

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registro is 
	port(led0, led1, led2, led3, led4, led5, led6, led7 : out std_logic;
			clk, s : in std_logic);
end registro;

architecture a of registro is

	component prescaler
		port(clk_in : in std_logic;
				clk_out : out std_logic);

	end component;

	signal reg : std_logic_vector (7 downto 0) := (others=>'0');
	signal clk_1 : std_logic;
	
begin

	pre : prescaler port map(clk, clk_1);

	
	process(clk_1)
	begin
		if clk_1'event and clk_1 = '1' then
			reg <= s & reg(7 downto 1);
		end if;
	end process;
	
	led0 <= reg(0);
	led1 <= reg(1);
	led2 <= reg(2);
	led3 <= reg(3);
	led4 <= reg(4);
	led5 <= reg(5);
	led6 <= reg(6);
	led7 <= reg(7);

end a;