library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity uart_tx is
    Port ( 
            data : in STD_LOGIC_VECTOR (7 downto 0);
            ready : in STD_LOGIC;
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            tx: out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
    type states is (idle, start, send, stop);
    signal actual_state, next_state : states;
    signal timmer : integer range 0 to 5208;
	 signal prescaler : integer range 0 to 5208;
    signal bit_number : integer range 0 to 7;
    signal tx_machine : std_logic;
begin

	--Baudrate prescaler seleccion
	--	1 / baudrate -> 1 / 9600 = 5208
	prescaler <= 5208;

    process(clk, reset)
    begin
        if reset = '1' then
            next_state <= idle;
            timmer <= 0;
            bit_number <= 0;
        elsif clk'event and clk = '1' then
            case actual_state is
					--Wait until data are ready
                when idle =>
                    tx_machine <= '1';
                    if ready = '1' then
                        next_state <= start;
                    else
                        next_state <= actual_state;
                    end if;
				   --Send start bit
                when start =>                    
                    tx_machine <= '0';                                        
                    if timmer = prescaler then
                        next_state <= send;
                        timmer <= 0;
                    else
                        next_state <= actual_state;
                        timmer <= timmer + 1;
                    end if;
					--Send 8 bits
                when send =>							
                     tx_machine <= data(bit_number);
							if timmer = prescaler then
							  if bit_number = 7 then
									 next_state <= stop;
									 bit_number <= 0;
								else
									 next_state <= actual_state;
									 bit_number <= bit_number + 1;
								end if;
								
								timmer <= 0;
                    else
                       next_state <= actual_state;
                       timmer <= timmer + 1 ;
                    end if;
					--Send stop bit
                when stop =>
                    tx_machine <= '1';
                    if timmer = prescaler then
                        next_state <= idle;
                        timmer <= 0;
                    else
                        next_state <= actual_state;
                        timmer <= timmer +1;
                    end if;      
            end case;
        end if;
    end process;
    
    actual_state <= next_state;
    tx <= tx_machine;

end Behavioral;
