library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        in1             : in     vl_logic_vector(7 downto 0);
        in2             : in     vl_logic_vector(7 downto 0);
        \out\           : out    vl_logic_vector(7 downto 0);
        ALUOp           : in     vl_logic_vector(2 downto 0);
        N               : out    vl_logic;
        Z               : out    vl_logic
    );
end ALU;
