// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	a simple processor which operates basic mathematical
//					operations as follow:
//					(1)loading, (2)storing, (3)adding, (4)subtracting,
//					(5)shifting, (6)oring, (7)branch if zero,
//					(8)branch if not zero, (9)branch if positive zero
//					 
// Input(s):		1. KEY0(reset): clear all values from registers,
//									reset flags condition, and reset
//									control FSM
//					2. KEY1(clock): manual clock controls FSM and all
//									synchronous components at every
//									positive clock edge
//
//
// Output(s):		1. HEX Display: display registers value K3 to K1
//									in hexadecimal format
//
//					** For more details, please refer to the document
//					   provided with this implementation
//
// ---------------------------------------------------------------------

module multicycle
(
SW, KEY, HEX0, HEX1, HEX2, HEX3,
HEX4, HEX5, HEX6, HEX7, LEDG, LEDR 
);

// ------------------------ PORT declaration ------------------------ //
input	[2:0] KEY, SW;
output	[6:0] HEX0, HEX1, HEX2, HEX3;
output	[6:0] HEX4, HEX5, HEX6, HEX7;
output	[7:0] LEDG;
output	[17:0] LEDR;

// ------------------------- Registers/Wires ------------------------ //
wire	clock, reset;
wire	MDRLoad, MemRead, MemWrite, RegIn;
wire	FlagWrite, R1Sel_OR, RFWrite;
wire	[7:0] R2wire, R1wire, RFout1wire, RFout2wire;
wire	[7:0] ALU_in2, ALUwire, ALUOut, MDRwire, MEMwire;
wire	[7:0] SE4wire, ZE5wire, ZE3wire, RegWire;
wire	[7:0] reg0, reg1, reg2, reg3;
wire	[7:0] hexin0, hexin1;
wire	[7:0] constant8bit_d1;
wire	[2:0] ALUOp, ALU_in2_mux_ctrl;
wire	[1:0] RF_in1;
wire	Nwire, Zwire;
reg		N, Z;

reg	[15:0] counter;
wire stop_operation_finished;

wire [7:0] q_pc;


wire [7:0] mux_PC_out, PC_ALUwire;
wire PCSel;

wire [7:0] IR1_to_IR2, IR2_to_IR3, IR3_to_regw;
wire [1:0] RW_in;

wire RWSel;

wire [2:0] ALU_in1_mux_ctrl;
wire [7:0] ALU_in1;

wire [7:0] PC1_to_PC2, PC2_out;

wire squashIR1, squashIR2;

// data hazard

wire [1:0]ALU_in1_BPSel, ALU_in2_BPSel;
wire [7:0]ALU_in1_muxOut, ALU_in2_muxOut;

wire [1:0]DataMem_data_BPSel, DataMem_address_BPSel;
wire [7:0]DataMem_data, DataMem_address;

wire [1:0]R1_in_BPSel, R2_in_BPSel;
wire [7:0]R1_in, R2_in;


// ------------------------ Parameters ------------------------------ //
parameter [3:0] OP_STOP = 4'b0001;
parameter [2:0] OP_ORI = 3'b111;


// ------------------------ Input Assignment ------------------------ //
assign	clock = KEY[1];
assign	reset =  ~KEY[0]; // KEY is active high


// ------------------- DE2 compatible HEX display ------------------- //
HEXs	HEX_display(
	.in0(hexin0),.in1(hexin1),.in2(reg2),.in3(reg3),
	.out0(HEX0),.out1(HEX1),.out2(HEX2),.out3(HEX3),
	.out4(HEX4),.out5(HEX5),.out6(HEX6),.out7(HEX7)
);




// Stages: FETCH, DECODE, RF, EXEC, WB


 // (EXEC stage) Control curcuit for ALU operations. 
FSMExecute FSMExecute(
	.reset(reset),.clock(clock), .instr(IR2_to_IR3), .N(N), .Z(Z), 
	.MemRead(MemRead),.MemWrite(MemWrite), .MDRLoad(MDRLoad), .ALU_in2_mux_ctrl(ALU_in2_mux_ctrl), .ALUop(ALUOp), 
	.FlagWrite(FlagWrite), .ALU_in1_mux_ctrl(ALU_in1_mux_ctrl), .PCSel(PCSel), .stop_operation_finished(stop_operation_finished), 
	.squashIR1(squashIR1), .squashIR2(squashIR2)
);


// (WB stage) Control curcuit for writing the results of ALU to where they are meant to go. Or storing a load.
FSMWB		FSMWB(
	.instr(IR3_to_regw[3:0]),
	.RFWrite(RFWrite),.RegIn(RegIn), .RWSel (RWSel)
);

// (RF stage) Really just checking if its the ori instruction, then the reg1 input to rf is muxed a constant 1 instead of from the instruction bits
/*FSMRF	FSMRF(
	.instr (IR1_to_IR2[3:0]),
	.R1Sel_OR (R1Sel_OR)
	); */

// (Data Hazard Detection)
DataHazardControl	DataHazardControl
(	
	.IR1(IR1_to_IR2), .IR2(IR2_to_IR3), .IR3(IR3_to_regw),
	
	.ALU_in1_BPSel(ALU_in1_BPSel), .ALU_in2_BPSel(ALU_in2_BPSel), 
	.DataMem_data_BPSel(DataMem_data_BPSel), .DataMem_address_BPSel(DataMem_address_BPSel), .R1_in_BPSel(R1_in_BPSel), .R2_in_BPSel(R2_in_BPSel)
);


memory DataMem(
	.MemRead(MemRead),
	.data(DataMem_data),
	.address(DataMem_address),
	.wren(MemWrite),
	.address_pc(PC1_to_PC2),
	.clock(clock),
	
	.q(MEMwire),
	.q_pc(q_pc)
	);
	
	
//bypasses
mux4to1_8bit 		DataMem_data_BP_mux(
	.data0x(R1wire),.data1x(ALUOut), .data2x(MDRwire), .data3x(),
	.sel(DataMem_data_BPSel),.result(DataMem_data)
);

mux4to1_8bit 		DataMem_address_BP_mux(
	.data0x(R2wire),.data1x(ALUOut), .data2x(MDRwire), .data3x(),
	.sel(DataMem_address_BPSel),.result(DataMem_address)
);



	
ALU		ALU(
	.in1(ALU_in1),.in2(ALU_in2),.out(ALUwire),
	.ALUOp(ALUOp),.N(Nwire),.Z(Zwire)
);

//bypasses
mux4to1_8bit 		ALU_in1_BP_mux(
	.data0x(ALU_in1_muxOut),.data1x(ALUOut), .data2x(MDRwire), .data3x(),
	.sel(ALU_in1_BPSel),.result(ALU_in1)
);

mux4to1_8bit 		ALU_in2_BP_mux(
	.data0x(ALU_in2_muxOut),.data1x(ALUOut), .data2x(MDRwire), .data3x(),
	.sel(ALU_in2_BPSel),.result(ALU_in2)
);


//normal operation muxes
mux5to1_8bit 		ALU_in1_mux(
	.data0x(R1wire),.data1x(PC2_out),.data2x(),
	.data3x(),.data4x(),.sel(ALU_in1_mux_ctrl),.result(ALU_in1_muxOut)
);	

mux5to1_8bit 		ALU_in2_mux(
	.data0x(R2wire),.data1x(constant8bit_d1),.data2x(SE4wire),
	.data3x(ZE5wire),.data4x(ZE3wire),.sel(ALU_in2_mux_ctrl),.result(ALU_in2_muxOut)
);

	



RF		RF_block(
	.clock(clock),.reset(reset),.RFWrite(RFWrite),
	.dataw(RegWire),.reg1(RF_in1),.reg2(IR1_to_IR2[5:4]),
	.regw(RW_in),.data1(RFout1wire),.data2(RFout2wire),
	.r0(reg0),.r1(reg1),.r2(reg2),.r3(reg3)
);

//***************************
//  IR chain



register_8bit_ir	IR1_reg(
	.clock(clock),.aclr(reset|stop_operation_finished),.enable(1'b1), .squash(squashIR1),
	.data(q_pc),.q(IR1_to_IR2)
);

register_8bit_ir	IR2_reg(
	.clock(clock),.aclr(reset|stop_operation_finished),.enable(1'b1), .squash(squashIR2),
	.data(IR1_to_IR2),.q(IR2_to_IR3)
);



register_8bit_ir	IR3_reg(
	.clock(clock),.aclr(reset),.enable(1'b1),
	.data(IR2_to_IR3),.q(IR3_to_regw)
);


mux2to1_2bit		RWSel_mux(
	.data0x(IR3_to_regw[7:6]),.data1x(constant8bit_d1[1:0]),
	.sel(RWSel),.result(RW_in)
);



register_8bit	MDR_reg(
	.clock(clock),.aclr(reset),.enable(MDRLoad),
	.data(MEMwire),.q(MDRwire)
);

//***************************
// FETCH



register_8bit	PC1(
	.clock(clock),.aclr(reset),.enable(1'b1),
	.data(mux_PC_out),.q(PC1_to_PC2)
);

register_8bit	PC2(
	.clock(clock),.aclr(reset),.enable(1'b1),
	.data(PC1_to_PC2),.q(PC2_out)
);






mux2to1_8bit 		PcSel_mux(
	.data0x(ALUwire),.data1x(PC_ALUwire),
	.sel(PCSel),.result(mux_PC_out)
);

ALU		PC_ALU(
	.in1(8'b1),.in2(PC1_to_PC2),.out(PC_ALUwire),
	.ALUOp(3'b000),.N(),.Z()
);
//****************************


register_8bit	R1(
	.clock(clock),.aclr(reset),.enable(1'b1),
	.data(R1_in),.q(R1wire)
);

register_8bit	R2(
	.clock(clock),.aclr(reset),.enable(1'b1),
	.data(R2_in),.q(R2wire)
);



//bypasses
mux4to1_8bit 		R1_in_BP_mux(
	.data0x(RFout1wire),.data1x(ALUOut), .data2x(MDRwire), .data3x(),
	.sel(R1_in_BPSel),.result(R1_in)
);

mux4to1_8bit 		R2_in_BP_mux(
	.data0x(RFout2wire),.data1x(ALUOut), .data2x(MDRwire), .data3x(),
	.sel(R2_in_BPSel),.result(R2_in)
);


register_8bit	ALUOut_reg(
	.clock(clock),.aclr(reset),.enable(1'b1),
	.data(ALUwire),.q(ALUOut)
);

mux2to1_2bit		R1Sel_mux(
	.data0x(IR1_to_IR2[7:6]),.data1x(constant8bit_d1[1:0]),
	.sel(R1Sel_OR),.result(RF_in1)
);

assign R1Sel_OR = (IR1_to_IR2[2:0] == OP_ORI) ? 1 : 0;




mux2to1_8bit 		RegMux(
	.data0x(ALUOut),.data1x(MDRwire),
	.sel(RegIn),.result(RegWire)
);




sExtend		SE4(.in(IR2_to_IR3[7:4]),.out(SE4wire));
zExtend		ZE3(.in(IR2_to_IR3[5:3]),.out(ZE3wire));
zExtend		ZE5(.in(IR2_to_IR3[7:3]),.out(ZE5wire));

// define parameter for the data size to be extended
defparam	SE4.n = 4;
defparam	ZE3.n = 3;
defparam	ZE5.n = 5;

always@(posedge clock or posedge reset)
begin
if (reset)
	begin
	N <= 0;
	Z <= 0;
	end
else
if (FlagWrite)
	begin
	N <= Nwire;
	Z <= Zwire;
	end
end



//Counter
always@(posedge clock or posedge reset)
begin
	if (reset) 									counter <= 0;
	else if (stop_operation_finished)  	counter <= counter;
	else  										counter <= counter+1;
	
end




// Mux for hex display register values vs cycle count
assign hexin0 = (SW[2]) ? counter[7:0] : 	reg0;
assign hexin1 = (SW[2]) ? counter[15:8] : reg1;





// ------------------------ Assign constants ----------------------- //
assign	constant8bit_d1 = 1;



endmodule
