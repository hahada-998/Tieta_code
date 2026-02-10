-- Created by IP Generator (Version 2024.2-SP1.2 build 187561)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT pll_i25M_o50M_o25M
  PORT (
    clkout0 : OUT STD_LOGIC;  -- 50.00000000MHz
    clkout1 : OUT STD_LOGIC;  -- 25.00000000MHz
    lock : OUT STD_LOGIC;
    clkin1 : IN STD_LOGIC;  -- 25.0000MHz
    rst : IN STD_LOGIC
  );
END COMPONENT;


the_instance_name : pll_i25M_o50M_o25M
  PORT MAP (
    clkout0 => clkout0,
    clkout1 => clkout1,
    lock => lock,
    clkin1 => clkin1,
    rst => rst
  );
