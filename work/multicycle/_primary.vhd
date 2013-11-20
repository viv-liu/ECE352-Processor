library verilog;
use verilog.vl_types.all;
entity multicycle is
    generic(
        OP_STOP         : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        OP_ORI          : vl_logic_vector(2 downto 0) := (Hi1, Hi1, Hi1)
    );
    port(
        SW              : in     vl_logic_vector(2 downto 0);
        KEY             : in     vl_logic_vector(2 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0);
        HEX6            : out    vl_logic_vector(6 downto 0);
        HEX7            : out    vl_logic_vector(6 downto 0);
        LEDG            : out    vl_logic_vector(7 downto 0);
        LEDR            : out    vl_logic_vector(17 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OP_STOP : constant is 2;
    attribute mti_svvh_generic_type of OP_ORI : constant is 2;
end multicycle;
