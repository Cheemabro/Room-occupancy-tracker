library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Room is
    port(
        clk             : in std_logic;
        reset           : in std_logic;
        photo_in        : in std_logic; -- Entry sensor
        photo_out       : in std_logic; -- Exit sensor
        max_occupancy   : in unsigned(7 downto 0); 
        occupancy       : out std_logic_vector(7 downto 0); -- Output occupancy
        max_capacity    : out std_logic -- 1 when room is full
    );
end entity;

architecture Behavior of Room is
    signal count           : unsigned(7 downto 0) := (others => '0'); -- Occupancy counter
    signal photo_in_prev   : std_logic := '0';
    signal photo_out_prev  : std_logic := '0';
    signal photo_in_rise   : std_logic;
    signal photo_out_rise  : std_logic;
begin

    -- Edge detection process
    process(clk)
    begin
        if rising_edge(clk) then
            photo_in_rise  <= photo_in and not photo_in_prev;
            photo_out_rise <= photo_out and not photo_out_prev;

            photo_in_prev  <= photo_in;
            photo_out_prev <= photo_out;
        end if;
    end process;

    -- Main occupancy tracking
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= (others => '0'); -- Reset occupancy
            else
                -- Person enters
                if photo_in_rise = '1' and count < max_occupancy then
                    count <= count + 1;
                end if;

                -- Person exits
                if photo_out_rise = '1' and count > 0 then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    -- Max capacity indicator
    process(count, max_occupancy)
    begin
        if count >= max_occupancy then
            max_capacity <= '1';
        else
            max_capacity <= '0';
        end if;
    end process;

    -- Output current occupancy
    occupancy <= std_logic_vector(count);

end architecture;

