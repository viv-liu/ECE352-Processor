library verilog;
use verilog.vl_types.all;
entity mux2to1_2bit is
    port(
        data0x          : in     vl_logic_vector(1 downto 0);
        data1x          : in     vl_logic_vector(1 downto 0);
        sel             : in     vl_logic;
        result          : out    vl_logic_vector(1 downto 0)
    );
end mux2to1_2bit;
