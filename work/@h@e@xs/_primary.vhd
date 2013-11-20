library verilog;
use verilog.vl_types.all;
entity HEXs is
    port(
        in0             : in     vl_logic_vector(7 downto 0);
        in1             : in     vl_logic_vector(7 downto 0);
        in2             : in     vl_logic_vector(7 downto 0);
        in3             : in     vl_logic_vector(7 downto 0);
        out0            : out    vl_logic_vector(6 downto 0);
        out1            : out    vl_logic_vector(6 downto 0);
        out2            : out    vl_logic_vector(6 downto 0);
        out3            : out    vl_logic_vector(6 downto 0);
        out4            : out    vl_logic_vector(6 downto 0);
        out5            : out    vl_logic_vector(6 downto 0);
        out6            : out    vl_logic_vector(6 downto 0);
        out7            : out    vl_logic_vector(6 downto 0)
    );
end HEXs;
