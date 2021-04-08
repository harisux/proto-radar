library ieee;
use ieee.std_logic_1164.all;

entity tb_barker13_pulsado is
end tb_barker13_pulsado;

architecture tb of tb_barker13_pulsado is

    component barker13_pulsado       
        port (clk      : in std_logic;
              rst      : in std_logic;
              data_out : out std_logic_vector (24 downto 0));
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal data_out : std_logic_vector (24 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';    
    
begin

    dut : barker13_pulsado    
    port map (clk      => clk,
              rst      => rst,
              data_out => data_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 2000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_barker13_pulsado of tb_barker13_pulsado is
    for tb
    end for;
end cfg_tb_barker13_pulsado;
