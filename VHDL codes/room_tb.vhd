library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Room_tb is
end Room_tb;

architecture behavior of Room_tb is

    component Room
        port(
            clk             : in std_logic;
            reset           : in std_logic;
            photo_in        : in std_logic;
            photo_out       : in std_logic;
            max_occupancy   : in unsigned(7 downto 0);
            occupancy       : out std_logic_vector(7 downto 0); -- Added
            max_capacity    : out std_logic
        );
    end component;

    -- Signals
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal photo_in      : std_logic := '0';
    signal photo_out     : std_logic := '0';
    signal max_occupancy : unsigned(7 downto 0) := to_unsigned(5, 8);  -- Max 5 people
    signal occupancy     : std_logic_vector(7 downto 0); -- Added
    signal max_capacity  : std_logic;

    constant clk_period  : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Room port map (
        clk             => clk,
        reset           => reset,
        photo_in        => photo_in,
        photo_out       => photo_out,
        max_occupancy   => max_occupancy,
        occupancy       => occupancy,       -- Mapped
        max_capacity    => max_capacity
    );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial reset
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
        wait for clk_period * 2;

        -- Simulate 5 entries (fill the room)
        for i in 1 to 5 loop
            photo_in <= '1';
            wait for clk_period;
            photo_in <= '0';
            wait for clk_period * 2;
        end loop;

        -- Try one more entry (should not increment due to max capacity)
        photo_in <= '1';
        wait for clk_period;
        photo_in <= '0';
        wait for clk_period * 2;

        -- Simulate 2 exits
        for i in 1 to 2 loop
            photo_out <= '1';
            wait for clk_period;
            photo_out <= '0';
            wait for clk_period * 2;
        end loop;

        -- Add 1 person again (should succeed now)
        photo_in <= '1';
        wait for clk_period;
        photo_in <= '0';
        wait for clk_period * 2;

        -- Reset the system
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';

        -- Exit 1 person
        photo_out <= '1';
        wait for clk_period;
        photo_out <= '0';
        wait for clk_period * 2;

        wait;
    end process;

end behavior;


