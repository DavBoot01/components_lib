library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;


entity clk_2N_divider is
    Port ( clk_in  : in  STD_LOGIC;
           clk_out : out STD_LOGIC;    -- clock with frequency = freq(clk_in) / ( 2 * n_scale ) 
           nreset  : in  STD_LOGIC;
           n_scale : in  STD_LOGIC_VECTOR (15 downto 0)
    );
end clk_2N_divider;


architecture Behavioral of clk_2N_divider is
    signal cnt     : STD_LOGIC_VECTOR (15 downto 0) := x"0001";
    signal cout    : STD_LOGIC := '0';
    signal put_on  : STD_LOGIC := '1';
begin
       
    process( nreset )
    begin
        put_on <= nreset;
    end process;   
       
    process( clk_in, nreset )
    begin
        if ( nreset = '0' ) then
            cnt <= x"0001";
         elsif ( rising_edge( clk_in ) ) then
				cnt <= cnt + 1;
            if ( (cnt XOR n_scale) = x"0000" ) then
                cnt <= x"0001";
                cout <= NOT cout;
            end if;
        end if;
    end process;

    clk_out <= cout and put_on;

end Behavioral;
