
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;


entity glitch_filter_array is
    Generic ( 
        PORT_WIDTH : INTEGER range 1 to (INTEGER'high) := 2;
        OUT_ON_RESET : STD_LOGIC := '0'
    );
    Port ( 
        clk       : in STD_LOGIC;
        nreset    : in STD_LOGIC;   -- asynchronous reset
        sync_rst  : in STD_LOGIC;   -- synchronous reset
        signal_i  : in STD_LOGIC_VECTOR( PORT_WIDTH - 1  downto 0 );
        signal_o  : out STD_LOGIC_VECTOR( PORT_WIDTH - 1  downto 0 )
    );
end glitch_filter_array;


architecture Behavioral of glitch_filter_array is

    constant CNTR_WIDTH : INTEGER := 3;
    type VECTOR_ARRAY_TYPE is array (INTEGER range <>) of STD_LOGIC_VECTOR((CNTR_WIDTH - 1) downto 0);

    signal sig_filter_ary : VECTOR_ARRAY_TYPE( ( PORT_WIDTH - 1 ) downto 0 ) := ( others=>( others=>OUT_ON_RESET ) );
    signal sig_gen : STD_LOGIC_VECTOR( (PORT_WIDTH - 1 ) downto 0 );

begin

    signal_filter: process( clk, nreset )
    begin
        if ( nreset = '0' ) then
        
            sig_filter_ary <= ( others=>( others=>OUT_ON_RESET ) );
        
        elsif ( rising_edge( clk ) ) then
        
            if ( sync_rst = '1' ) then
                sig_filter_ary <= ( others=>( others=>OUT_ON_RESET ) );
            else             
                for index in (PORT_WIDTH - 1) downto 0 loop
                    sig_filter_ary(index) <= ( sig_filter_ary(index)(( CNTR_WIDTH - 2) downto 0) &  signal_i(index) );
                end loop;
           end if;
            
        end if;
    end process signal_filter;   
        

    signal_out_gen: process( clk, nreset )
    begin
        if ( nreset = '0' ) then
        
            sig_gen <= ( others=>OUT_ON_RESET );
            
        elsif ( rising_edge( clk ) ) then
        
            if ( sync_rst = '1' ) then
                sig_gen <= ( others=>OUT_ON_RESET );
            else
                for index in (PORT_WIDTH - 1) downto 0 loop
                    sig_gen(index) <= ( sig_filter_ary(index)(CNTR_WIDTH - 1) and sig_filter_ary(index)(CNTR_WIDTH - 2) ) or
                                      ( sig_filter_ary(index)(CNTR_WIDTH - 1) and sig_filter_ary(index)(CNTR_WIDTH - 3) ) or
                                      ( sig_filter_ary(index)(CNTR_WIDTH - 2) and sig_filter_ary(index)(CNTR_WIDTH - 3) );
                end loop;  
            end if;
        
        end if;
    end process signal_out_gen;
    
        
    signal_o <= sig_gen;

end Behavioral;
