library verilog;
use verilog.vl_types.all;
entity chooseHEXs is
    port(
        in0             : in     vl_logic_vector(7 downto 0);
        in1             : in     vl_logic_vector(7 downto 0);
        in2             : in     vl_logic_vector(7 downto 0);
        in3             : in     vl_logic_vector(7 downto 0);
        \select\        : in     vl_logic_vector(1 downto 0);
        out1            : out    vl_logic_vector(6 downto 0);
        out0            : out    vl_logic_vector(6 downto 0)
    );
end chooseHEXs;
