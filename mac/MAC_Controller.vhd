--------------------------------------------------------------------------------
-- This code creates MAC controller that describe connections between modules.
-- Input 4 element connections multiplier and accumulate.
-- Also 3 input signals for controlling this module.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MAC_Controller is
    Port (
        clk         : in  STD_LOGIC; -- Clock 
        rst         : in  STD_LOGIC; -- Reset 
        start       : in  STD_LOGIC; -- Start 
        ready       : in  STD_LOGIC; -- Multiplication is done
        start_mpy   : out STD_LOGIC; -- Start multiplication
        write_acc   : out STD_LOGIC; -- Write accumulate result
        ready_mac   : out STD_LOGIC  -- MAC operation is done
    );
end MAC_Controller;


architecture Behavioral of MAC_Controller is
    type state_type is (IDLE, START_MULTIPLY, WAIT_MULTIPLY, ACCUMULATE, DONE);
    signal state, next_state : state_type;

    signal done_mpy_internal : STD_LOGIC := '0';  -- Control transitions
    signal start_pulse     : STD_LOGIC := '0';  -- Trigger multiplication only 1
begin
    process (clk, rst)
    begin
        if rst = '1' then
            state <= IDLE; 
        elsif rising_edge(clk) then
            state <= next_state;  
        end if;
    end process;

    process (state, start, ready)
    begin
        start_mpy <= '0';
        write_acc <= '0';
        ready_mac <= '0';
        done_mpy_internal <= '0';
        next_state <= state;

        case state is
            when IDLE =>
                if start = '1' then
                    start_mpy <= '1';  -- Start multiplication
                    next_state <= START_MULTIPLY;
                end if;

            when START_MULTIPLY =>
                start_mpy <= '0';  -- Deactivate the start signal 
                next_state <= WAIT_MULTIPLY;

            when WAIT_MULTIPLY =>
                if ready = '1' then
                    done_mpy_internal <= '1'; -- Capture `ready` from multiplier
                    next_state <= ACCUMULATE;
                else
                    next_state <= WAIT_MULTIPLY; -- Wait multiplication is done
                end if;

            when ACCUMULATE =>
                if done_mpy_internal = '1' then
                    write_acc <= '1';  -- Activate write signal
                    next_state <= DONE;
                end if;

            when DONE =>
                write_acc <= '0';  -- Deactivate write signal
                ready_mac <= '1';  -- Indicate MAC operation is done
                if start = '0' then
                    next_state <= IDLE;  
                else
                    next_state <= DONE;  
                end if;

            when others =>
                next_state <= IDLE;  
        end case;
    end process;
end Behavioral;
