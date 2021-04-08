library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity barker13_pulsado_axistr is    
    Port ( clk : in STD_LOGIC;
	       valid : out STD_LOGIC;
	       ready : in STD_LOGIC;           
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end barker13_pulsado_axistr;

architecture Behavioral of barker13_pulsado_axistr is      
    type state_type is (state1, state2, state3, state4, state5, 
    state6, state7, state8, state9, state10, state11, state12, state13, stateoff1,
    stateoff2, stateoff3, stateoff4, stateoff5, stateoff6, stateoff7, stateoff8, 
    stateoff9, stateoff10, stateoff11, stateoff12, stateoff13);
    signal state_reg, state_next: state_type;
    
begin
    process(clk)
    begin        
        if (rising_edge(clk)) then           
            state_reg <= state_next; 
        end if;
    end process;      
      
    --FSM secuencia Barker 13
    process(ready, state_reg)    
    begin    
       case state_reg is            
            when state1 =>               
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state2;
                end if;
            when state2 =>                
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state3;
                end if;
            when state3 =>                
                data_out <= (0=>'1', others=>'0');
		        valid <= '1'; 
                if (ready = '1') then
                    state_next <= state4;
                end if;
            when state4 =>                
                data_out <= (0=>'1', others=>'0');
		        valid <= '1'; 
                if (ready = '1') then
                    state_next <= state5;
                end if;
            when state5 =>                
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state6;
                end if; 
            when state6 =>                
                data_out <= (0=>'0', others=>'0');
		        valid <= '1'; 
                if (ready = '1') then
                    state_next <= state7;
                end if;
            when state7 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state8;
                end if;
            when state8 =>                
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state9;
                end if;
            when state9 =>                
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state10;
                end if;
            when state10 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state11;
                end if; 
            when state11 =>                
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state12;
                end if;
            when state12 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state13;
                end if;
            when state13 =>                
                data_out <= (0=>'1', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff1;
                end if; 
            when stateoff1 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff2;
                end if; 
	        when stateoff2 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff3;
                end if;
            when stateoff3 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff4;
                end if; 
	        when stateoff4 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff5;
                end if;
            when stateoff5 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff6;
                end if; 
	        when stateoff6 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff7;
                end if;
            when stateoff7 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff8;
                end if; 
	        when stateoff8 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff9;
                end if;
            when stateoff9 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff10;
                end if;
            when stateoff10 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff11;
                end if; 
	        when stateoff11 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff12;
                end if;
            when stateoff12 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= stateoff13;
                end if; 
	        when stateoff13 =>                
                data_out <= (0=>'0', others=>'0'); 
		        valid <= '1';
                if (ready = '1') then
                    state_next <= state1;
                end if;
            when others => 
		        data_out <= (0=>'0', others=>'0'); 
		        valid <= '0';               
                state_next <= state1;
        end case; 
    end process; 
end Behavioral;

