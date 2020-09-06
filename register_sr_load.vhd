
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;

entity register_sr_load is
    Generic ( 
        DATA_WIDTH  : INTEGER range 1 to (INTEGER'high) := 8
    );
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;    -- sync reset
        set             : in  STD_LOGIC;
        load            : in  STD_LOGIC;       
        def_set_value   : in  STD_LOGIC_VECTOR( (DATA_WIDTH - 1) downto 0 );
        D               : in  STD_LOGIC_VECTOR( (DATA_WIDTH - 1) downto 0 );
        Q               : out STD_LOGIC_VECTOR( (DATA_WIDTH - 1) downto 0 )
     );
end register_sr_load;


architecture Behavioral of register_sr_load is
    signal output  : STD_LOGIC_VECTOR( (DATA_WIDTH - 1) downto 0 );
begin
    
    store: process( clk )
    begin
        if ( rising_edge( clk ) ) then
        
            if ( reset = '1' ) then
                output <= (others=>'0');
             elsif ( set = '1' ) then
                output <= def_set_value;
             elsif ( load = '1' ) then
                output <= D;
             end if; 
        
        end if;
    end process store;
    
    Q <= output;

end Behavioral;
