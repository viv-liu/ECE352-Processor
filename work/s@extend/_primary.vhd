library verilog;
use verilog.vl_types.all;
entity sExtend is
    generic(
        n               : integer := 3
    );
    port(
        \in\            : in     vl_logic_vector;
        \out\           : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
end sExtend;
