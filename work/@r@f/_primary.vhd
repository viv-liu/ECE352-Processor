library verilog;
use verilog.vl_types.all;
entity RF is
    port(
        clock           : in     vl_logic;
        reg1            : in     vl_logic_vector(1 downto 0);
        reg2            : in     vl_logic_vector(1 downto 0);
        regw            : in     vl_logic_vector(1 downto 0);
        dataw           : in     vl_logic_vector(7 downto 0);
        RFWrite         : in     vl_logic;
        data1           : out    vl_logic_vector(7 downto 0);
        data2           : out    vl_logic_vector(7 downto 0);
        r0              : out    vl_logic_vector(7 downto 0);
        r1              : out    vl_logic_vector(7 downto 0);
        r2              : out    vl_logic_vector(7 downto 0);
        r3              : out    vl_logic_vector(7 downto 0);
        reset           : in     vl_logic
    );
end RF;
