
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity barker13_pulsado_axistr_wrap is    
    Port (       
             -- axi4 stream master (data output)
             aclk          : in std_logic;
   		     m_axis_tdata  : out std_logic_vector(31 downto 0);
    		 m_axis_tvalid : out std_logic;
   		     m_axis_tready : in  std_logic);
end barker13_pulsado_axistr_wrap;

architecture Behavioral of barker13_pulsado_axistr_wrap is     
        
begin
    barker13_pulsado_axistr_i : entity work.barker13_pulsado_axistr   
    port map (
      clk       => aclk,
      data_out  => m_axis_tdata, 
      valid     => m_axis_tvalid,
      ready     => m_axis_tready);   
end Behavioral;
