library verilog;
use verilog.vl_types.all;
entity register_8bit is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        data            : in     vl_logic_vector(7 downto 0);
        enable          : in     vl_logic;
        q               : out    vl_logic_vector(7 downto 0)
    );
end register_8bit;
