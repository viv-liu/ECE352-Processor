library verilog;
use verilog.vl_types.all;
entity DualMem is
    port(
        address_a       : in     vl_logic_vector(7 downto 0);
        address_b       : in     vl_logic_vector(7 downto 0);
        clock           : in     vl_logic;
        data_a          : in     vl_logic_vector(7 downto 0);
        data_b          : in     vl_logic_vector(7 downto 0);
        wren_a          : in     vl_logic;
        wren_b          : in     vl_logic;
        q_a             : out    vl_logic_vector(7 downto 0);
        q_b             : out    vl_logic_vector(7 downto 0)
    );
end DualMem;
