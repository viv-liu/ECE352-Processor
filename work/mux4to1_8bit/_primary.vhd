library verilog;
use verilog.vl_types.all;
entity mux4to1_8bit is
    port(
        data0x          : in     vl_logic_vector(7 downto 0);
        data1x          : in     vl_logic_vector(7 downto 0);
        data2x          : in     vl_logic_vector(7 downto 0);
        data3x          : in     vl_logic_vector(7 downto 0);
        sel             : in     vl_logic_vector(1 downto 0);
        result          : out    vl_logic_vector(7 downto 0)
    );
end mux4to1_8bit;
