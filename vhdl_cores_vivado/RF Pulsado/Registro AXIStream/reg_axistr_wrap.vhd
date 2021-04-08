
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity reg_axistr_wrap is    
    Port (          clk, rst      : in std_logic;		   
                 -- axi4 stream slave (data input)
		    s_axis_tdata  : in  std_logic_vector(31 downto 0);
		    s_axis_tvalid : in  std_logic;
		    s_axis_tready : out std_logic;
		    -- axi4 stream master (data output)
		    m_axis_tdata  : out std_logic_vector(31 downto 0);
		    m_axis_tvalid : out std_logic;
		    m_axis_tready : in  std_logic
          );
end reg_axistr_wrap;

architecture Behavioral of reg_axistr_wrap is     
        
begin
    reg_axistr_i : entity work.reg_axistr   
    port map (
      clk         => clk,
      rst         => rst,     
      m_valid     => m_axis_tvalid, 
      m_ready     => m_axis_tready,
      s_valid     => s_axis_tvalid,
      s_ready     => s_axis_tready,
      data_in     => s_axis_tdata,
      data_out    => m_axis_tdata);   
end Behavioral;
