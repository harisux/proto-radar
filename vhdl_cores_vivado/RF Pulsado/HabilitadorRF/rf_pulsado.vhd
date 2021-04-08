library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity rf_pulsado is    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           areset : out STD_LOGIC);
end rf_pulsado;

architecture Behavioral of rf_pulsado is
    constant width_cont : integer := 32;
    constant num_con : integer := 20000;
    constant num_coff : integer := 20000;
    
    type state_type is (idle, stateon, stateoff);
    signal state_reg, state_next: state_type; 
    signal conton_reg, conton_next, contoff_reg, contoff_next: unsigned(width_cont-1 downto 0);
    signal flagon, enon, flagoff, enoff: std_logic;
    --signal flag_del: std_logic;    
begin
    process(clk,rst)
    begin
        if (rst = '0') then 
            conton_reg <= (others=>'0');
            contoff_reg <= (others=>'0');
            state_reg <= idle;
            
            --flag_del <= '0';
        elsif (rising_edge(clk)) then 
            conton_reg <= conton_next;
            contoff_reg <= contoff_next;
            state_reg <= state_next;
            
            --flag_del <= flag;
        end if;
    end process;
    
    --Contador de clks on
    conton_next <= (others=>'0') when (conton_reg = num_con-1) else
                    conton_reg + 1 when (enon = '1') else
                    conton_reg;
                  
    --Contador de clks off
    contoff_next <= (others=>'0') when (contoff_reg = num_coff-1) else
                     contoff_reg + 1 when (enoff = '1') else
                     contoff_reg;  
    
    flagon <= '1' when (conton_reg = num_con-1) else 
              '0';
            
    flagoff <= '1' when (contoff_reg = num_coff-1) else
               '0';   
      
    --FSM on/off
    process(flagon, flagoff, state_reg)  --flag_del  
    begin
    enon <= '0';
    enoff <= '0'; 
    areset <= '1';          
       case state_reg is
            when idle =>                
                enon <= '1'; 
                state_next <= stateon;
            when stateon =>
                enon <= '1'; 	        	               
                if (flagon = '1') then
                    state_next <= stateoff;
                end if;            
            when stateoff =>
                enoff <= '1';
	        areset <= '0';      
                if (flagoff = '1') then
                    state_next <= stateon;
                end if; 
            when others =>      
                state_next <= idle;
        end case; 
    end process; 
end Behavioral;

