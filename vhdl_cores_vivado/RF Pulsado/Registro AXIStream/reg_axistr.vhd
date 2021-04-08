library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity reg_axistr is    
    Port ( clk, rst: in STD_LOGIC;          
	   m_valid : out STD_LOGIC;
	   m_ready : in STD_LOGIC;
           s_valid : in STD_LOGIC;
	   s_ready : out STD_LOGIC;
           data_in: in STD_LOGIC_VECTOR (31 downto 0);	        
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end reg_axistr;

architecture Behavioral of reg_axistr is 
signal data_out_reg, data_out_next : STD_LOGIC_VECTOR (31 downto 0);
begin

    process(clk,rst)
    begin
        if (rst = '0') then 
            data_out_reg <= (others=>'0');           
        elsif (rising_edge(clk)) then 
            data_out_reg <= data_out_next;
        end if;
    end process; 

data_out_next <= data_in when (s_valid = '1') else
		 data_out_reg;
  
data_out <= data_out_reg;
s_ready <= '1';
m_valid <= '1'; 

end Behavioral;

