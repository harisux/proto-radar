----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2017 11:03:46 AM
-- Design Name: 
-- Module Name: barker13_pulsado - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity barker13_pulsado is    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (24 downto 0));
end barker13_pulsado;

architecture Behavioral of barker13_pulsado is
    constant width_cont : integer := 10;
    constant num_sxs : integer := 2;
    constant num_soff : integer := 234;
    
    type state_type is (idle, state1, state2, state3, state4, state5, 
    state6, state7, state8, state9, state10, state11, state12, state13, stateoff);
    signal state_reg, state_next: state_type; 
    signal cont_reg, cont_next, contoff_reg, contoff_next: unsigned(width_cont-1 downto 0);
    signal flag, en, flagoff, enoff: std_logic;
    signal flag_del: std_logic;    
begin
    process(clk,rst)
    begin
        if (rst = '1') then 
            cont_reg <= (others=>'0');
            contoff_reg <= (others=>'0');
            state_reg <= idle;
            
            flag_del <= '0';
        elsif (rising_edge(clk)) then 
            cont_reg <= cont_next;
            contoff_reg <= contoff_next;
            state_reg <= state_next;
            
            flag_del <= flag;
        end if;
    end process;
    
    --Contador de samples de simbolo    
    cont_next <= (others=>'0') when (cont_reg = num_sxs-1) else
                  cont_reg + 1 when (en = '1') else
                  cont_reg;
                  
    --Contador de samples off
    contoff_next <= (others=>'0') when (contoff_reg = num_soff-1) else
                     contoff_reg + 1 when (enoff = '1') else
                     contoff_reg;  
    
    flag <= '1' when (cont_reg = num_sxs-1) else 
            '0';
            
    flagoff <= '1' when (contoff_reg = num_soff-1) else
               '0';   
      
    --FSM secuencia Barker 13
    process(flag_del, flagoff, state_reg)    
    begin
    en <= '0';
    enoff <= '0';     
       case state_reg is
            when idle =>                
                en <= '1'; 
                data_out <= (0=>'0', others=>'0');
                state_next <= state1;
            when state1 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state2;
                end if;
            when state2 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state3;
                end if;
            when state3 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state4;
                end if;
            when state4 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state5;
                end if;
            when state5 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state6;
                end if; 
            when state6 =>
                en <= '1';
                data_out <= (0=>'0', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state7;
                end if;
            when state7 =>
                en <= '1';
                data_out <= (0=>'0', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state8;
                end if;
            when state8 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state9;
                end if;
            when state9 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state10;
                end if;
            when state10 =>
                en <= '1';
                data_out <= (0=>'0', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state11;
                end if; 
            when state11 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state12;
                end if;
            when state12 =>
                en <= '1';
                data_out <= (0=>'0', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= state13;
                end if;
            when state13 =>
                en <= '1';
                data_out <= (0=>'1', others=>'0'); 
                if (flag_del = '1') then
                    state_next <= stateoff;
                end if; 
            when stateoff =>
                enoff <= '1';
                data_out <= (0=>'0', others=>'0'); 
                if (flagoff = '1') then
                    state_next <= state1;
                end if; 
            when others =>                
                state_next <= idle;
        end case; 
    end process; 
end Behavioral;

