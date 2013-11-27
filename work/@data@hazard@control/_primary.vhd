library verilog;
use verilog.vl_types.all;
entity DataHazardControl is
    generic(
        OP_LOAD         : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi0);
        OP_STORE        : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi0);
        OP_ADD          : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi0);
        OP_SUB          : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi0);
        OP_NAND         : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi0);
        OP_BZ           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi1);
        OP_BNZ          : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi1);
        OP_BPZ          : vl_logic_vector(3 downto 0) := (Hi1, Hi1, Hi0, Hi1);
        OP_STOP         : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        OP_NOP          : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi0);
        OP_ORI          : vl_logic_vector(2 downto 0) := (Hi1, Hi1, Hi1);
        OP_SHIFT        : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi1)
    );
    port(
        IR1             : in     vl_logic_vector(7 downto 0);
        IR2             : in     vl_logic_vector(7 downto 0);
        IR3             : in     vl_logic_vector(7 downto 0);
        ALU_in1_BPSel   : out    vl_logic;
        ALU_in2_BPSel   : out    vl_logic;
        DataMem_data_BPSel: out    vl_logic;
        DataMem_address_BPSel: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OP_LOAD : constant is 2;
    attribute mti_svvh_generic_type of OP_STORE : constant is 2;
    attribute mti_svvh_generic_type of OP_ADD : constant is 2;
    attribute mti_svvh_generic_type of OP_SUB : constant is 2;
    attribute mti_svvh_generic_type of OP_NAND : constant is 2;
    attribute mti_svvh_generic_type of OP_BZ : constant is 2;
    attribute mti_svvh_generic_type of OP_BNZ : constant is 2;
    attribute mti_svvh_generic_type of OP_BPZ : constant is 2;
    attribute mti_svvh_generic_type of OP_STOP : constant is 2;
    attribute mti_svvh_generic_type of OP_NOP : constant is 2;
    attribute mti_svvh_generic_type of OP_ORI : constant is 2;
    attribute mti_svvh_generic_type of OP_SHIFT : constant is 2;
end DataHazardControl;
