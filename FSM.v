// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------





module	FSMExecute
(
reset, clock, instr, N, Z, 
MemRead, MemWrite, MDRLoad, ALU2, ALUop, 
FlagWrite, ALU_in1_mux_ctrl, PCSel, stop_operation_finished
);

	input	[3:0] instr;
	input	reset, clock;
	input N, Z;
	output reg MemRead, MemWrite, MDRLoad;
	output reg FlagWrite;
	output reg [2:0] ALU2, ALUop;
	output reg [7:0] ALU_in1_mux_ctrl;
	output reg PCSel, stop_operation_finished;
	
	//op codes for the instructions
	parameter [3:0] OP_LOAD = 4'b0000, OP_STORE = 4'b0010, OP_ADD = 4'b0100, OP_SUB = 4'b0110, OP_NAND = 4'b1000;
	parameter [3:0] OP_BZ = 4'b0101, OP_BNZ = 4'b1001, OP_BPZ = 4'b1101, OP_STOP = 4'b0001, OP_NOP = 4'b1010;
	parameter [2:0] OP_ORI = 3'b111, OP_SHIFT = 3'b011;
	
	//ALU op codes corresponding to insturctions
	parameter [2:0] ALU_ADD = 3'b000, ALU_SUB = 3'b001, ALU_NAND = 3'b011, ALU_SHIFT = 3'b100, ALU_ORI = 3'b010;
					
	
	//detecting stop
	always@(posedge clock or posedge reset)
	begin
		if (reset) 						stop_operation_finished <= 0;
		else if (instr == OP_STOP)	stop_operation_finished <= 1;
		else								stop_operation_finished <= stop_operation_finished;
	end
	
	
	
	
	always @(*) 
	begin
		if(~stop_operation_finished)
		begin
				if (instr == OP_LOAD)	// Load RESET DOES THIS
				begin
					MemRead = 1; // read from memory
					MDRLoad = 1; // enable 
				end
				else
				begin
					MemRead = 0;
					MDRLoad = 0;
				end
				
				if (instr == OP_STORE) // Store	
						MemWrite = 1;
				else	MemWrite = 0;			
				
				if( instr == OP_ADD ) 		// Add
				//control = 19'b0000000010000001001;
				begin	
					ALU2 = 0;
					ALUop = ALU_ADD;
					FlagWrite = 1;
					ALU_in1_mux_ctrl = 0;
				end	
				else if ( instr == OP_SUB ) 	// Sub
				//control = 19'b0000000010000011001;
				begin
					ALU2 = 0;
					ALUop = ALU_SUB;	
					FlagWrite = 1;
					ALU_in1_mux_ctrl = 0;
				end
				else if (instr == OP_NAND)		// Nand
					//control = 19'b0000000010000111001;
				begin	
					ALU2 = 0;
					ALUop = ALU_NAND;		
					FlagWrite = 1;
					ALU_in1_mux_ctrl = 0;
				end
				else if (instr[2:0] == OP_SHIFT)	// Shift
				//control = 19'b0000000011001001001;
				begin
					ALU2 = 4;
					ALUop = ALU_SHIFT;
					FlagWrite = 1;
					ALU_in1_mux_ctrl = 0;
				end
				else if (instr[2:0] == OP_ORI) // Ori
				//control = 19'b0000010100000000000;
				begin
					ALU2 = 3;
					ALUop = ALU_ORI;
					FlagWrite = 1;
					ALU_in1_mux_ctrl = 0;
				end
				else if (instr == OP_BNZ || instr == OP_BPZ || instr == OP_BZ) // Ori
				//control = 19'b0000010100000000000;
				begin
					ALU2 = 2;
					ALUop = ALU_ADD;
					FlagWrite = 0;
					ALU_in1_mux_ctrl = 1;
				end
				
				else	//control = 19'b0000000000000000000; ????????????????????????????
				begin
					ALU2 = 3'b000;
					ALUop = 3'b000;
					FlagWrite = 0;
					ALU_in1_mux_ctrl = 0;
				end
				
				
		
					
				if(instr == OP_BZ && Z)
					PCSel = 0;
				else if(instr == OP_BNZ && ~Z)
					PCSel = 0;
				else if(instr == OP_BPZ && ~N)
					PCSel = 0;
				else
					PCSel = 1;
		end
		else
		begin
			MemRead = 0;
			MDRLoad = 0;
			MemWrite = 0;
			FlagWrite = 0;
		end
	end	
	
	
	
endmodule


module FSMWB
(
instr,
RFWrite, RegIn, RWSel
);

	input [3:0] instr;
	output reg RFWrite, RegIn, RWSel;
	
	//op codes for the instructions
	parameter [3:0] OP_LOAD = 4'b0000, OP_STORE = 4'b0010, OP_ADD = 4'b0100, OP_SUB = 4'b0110, OP_NAND = 4'b1000;
	parameter [3:0] OP_BZ = 4'b0101, OP_BNZ = 4'b1001, OP_BPZ = 4'b1101, OP_STOP = 4'b0001, OP_NOP = 4'b1010;
	parameter [2:0] OP_ORI = 3'b111, OP_SHIFT = 3'b011;
	
	always @(*)
	begin

		
			
			if(instr == OP_ADD || instr == OP_SUB || instr == OP_NAND ||
				instr[2:0] == OP_ORI || instr[2:0] == OP_SHIFT) // ASN || ORI || SHIFT
			begin	
				RFWrite = 1;
				RegIn = 0;
			end 
			else if(instr == OP_LOAD) // Load RESET MAKES YOU DO THIS.
			begin	
				RFWrite = 1;
				RegIn = 1;
			end
			else
			begin
				RFWrite = 0;
				RegIn = 0;
			end
			
			if(instr[2:0] == OP_ORI) // OR
				RWSel = 1;
			else
				RWSel = 0;
			

				
		//end
			
	// Branch with 
	
				
	
	end
	


endmodule

/*
module FSMRF
(
	instr,
	R1Sel_OR
);

input [3:0] instr;
output R1Sel_OR;

//op codes for the instructions
	parameter [3:0] OP_LOAD = 4'b0000, OP_STORE = 4'b0010, OP_ADD = 4'b0100, OP_SUB = 4'b0110, OP_NAND = 4'b1000;
	parameter [3:0] OP_BZ = 4'b0101, OP_BNZ = 4'b1001, OP_BPZ = 4'b1101, OP_STOP = 4'b0001, OP_NOP = 4'b1010;
	parameter [2:0] OP_ORI = 3'b111, OP_SHIFT = 3'b011;

	

endmodule */

/*module FSM
(
reset, instr, insRF, insExec, insWb, clock,
N, Z,
PCwrite, AddrSel, MemRead,
MemWrite, IRload,
R1Sel, MDRload,
R1R2Load, ALU1, ALU2, ALUop,
ALUOutWrite, RFWrite, RegIn, FlagWrite, state
);
	input	[3:0] instr, insRF, insExec, insWb;
	input	N, Z;
	input	reset, clock;
	output	PCwrite, AddrSel, MemRead, MemWrite, 
	output	IRload, IRdecode, IRexec, IRwb, 
	output 	R1Sel, MDRload;
	output	R1R2Load, ALU1, ALUOutWrite, RFWrite, RegIn, FlagWrite;
	output	[2:0] ALU2, ALUop;
	output reg	[4:0] state;
	
	reg	PCwrite, AddrSel, MemRead, MemWrite, IRload, R1Sel, MDRload;
	reg	R1R2Load, ALU1, ALUOutWrite, RFWrite, RegIn, FlagWrite;
	reg	[2:0] ALU2, ALUop;
	
	// state constants (note: asn = add/sub/nand, asnsh = add/sub/nand/shift)
	parameter [4:0] reset_s = 0, c1 = 1, c2 = 2, c3_asn = 3,
					c4_asnsh = 4, c3_shift = 5, c3_ori = 6,
					c4_ori = 7, c5_ori = 8, c3_load = 9, c4_load = 10,
					c3_store = 11, c3_bpz = 12, c3_bz = 13, c3_bnz = 14, c3_nop = 15, c3_stop = 16;
	
	always @(posedge clock or posedge reset) 
	begin
		if (reset)
		begin
			PCwrite = 0;
			AddrSel = 0;
			MemRead = 0;
			MemWrite = 0;
			IRload = 0;
			R1Sel = 0;
			MDRload = 0;
			R1R2Load = 0;
			ALU1 = 0;
			ALU2 = 3'b000;
			ALUop = 3'b000;
			ALUOutWrite = 0;
			RFWrite = 0;
			RegIn = 0;
			FlagWrite = 0;
		end
		
		// Fetch, Decode
		PCwrite = 1;
		AddrSel = 1;
		MemRead = 1;
		MemWrite = 0;
		IRLoad = 1;
		
		// RF
		R1Sel = 0;
		RFWrite = 0;
		// The end
		insWb = insExec;
		insExec = insRF;
		insRF = instr;
		
		
	end
	// determines the next state based upon the current state; supports
	// asynchronous reset
	always @(posedge clock or posedge reset)
	begin
		if (reset) state = reset_s;
		else
		begin
			case(state)
				reset_s:	state = c1; 		// reset state
				c1:			state = c2; 		// cycle 1
				c2:			begin				// cycle 2
								if(instr == 4'b0100 | instr == 4'b0110 | instr == 4'b1000) state = c3_asn;
								else if( instr[2:0] == 3'b011 ) state = c3_shift;
								else if( instr[2:0] == 3'b111 ) state = c3_ori;
								else if( instr == 4'b0000 ) state = c3_load;
								else if( instr == 4'b0010 ) state = c3_store;
								else if( instr == 4'b1101 ) state = c3_bpz;
								else if( instr == 4'b0101 ) state = c3_bz;
								else if( instr == 4'b1001 ) state = c3_bnz;
								else if( instr == 4'b1010 ) state = c3_nop;
								else if( instr == 4'b0001 ) state = c3_stop;
								else state = 0;
							end
				c3_asn:		state = c4_asnsh;	// cycle 3: ADD SUB NAND
				c4_asnsh:	state = c1;			// cycle 4: ADD SUB NAND/SHIFT
				c3_shift:	state = c4_asnsh;	// cycle 3: SHIFT
				c3_ori:		state = c4_ori;		// cycle 3: ORI
				c4_ori:		state = c5_ori;		// cycle 4: ORI
				c5_ori:		state = c1;			// cycle 5: ORI
				c3_load:	state = c4_load;	// cycle 3: LOAD
				c4_load:	state = c1; 		// cycle 4: LOAD
				c3_store:	state = c1; 		// cycle 3: STORE
				c3_bpz:		state = c1; 		// cycle 3: BPZ
				c3_bz:		state = c1; 		// cycle 3: BZ
				c3_bnz:		state = c1; 		// cycle 3: BNZ
				c3_nop:		state = c1;			// cycle 3: NOP
				c3_stop:		state = c3_stop;
			endcase
		end
	end


	// sets the control sequences based upon the current state and instruction
	always @(*)
	begin
		case (state)
			reset_s:	//control = 19'b0000000000000000000;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end					
			c1: 		//control = 19'b1110100000010000000;
				begin
					PCwrite = 1;
					AddrSel = 1;
					MemRead = 1;
					MemWrite = 0;
					IRload = 1;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b001;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end	
			c2: 		//control = 19'b0000000100000000000;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 1;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_asn:		begin
							if ( instr == 4'b0100 ) 		// add
								//control = 19'b0000000010000001001;
							begin
								PCwrite = 0;
								AddrSel = 0;
								MemRead = 0;
								MemWrite = 0;
								IRload = 0;
								R1Sel = 0;
								MDRload = 0;
								R1R2Load = 0;
								ALU1 = 1;
								ALU2 = 3'b000;
								ALUop = 3'b000;
								ALUOutWrite = 1;
								RFWrite = 0;
								RegIn = 0;
								FlagWrite = 1;
							end	
							else if ( instr == 4'b0110 ) 	// sub
								//control = 19'b0000000010000011001;
							begin
								PCwrite = 0;
								AddrSel = 0;
								MemRead = 0;
								MemWrite = 0;
								IRload = 0;
								R1Sel = 0;
								MDRload = 0;
								R1R2Load = 0;
								ALU1 = 1;
								ALU2 = 3'b000;
								ALUop = 3'b001;
								ALUOutWrite = 1;
								RFWrite = 0;
								RegIn = 0;
								FlagWrite = 1;
							end
							else 							// nand
								//control = 19'b0000000010000111001;
							begin
								PCwrite = 0;
								AddrSel = 0;
								MemRead = 0;
								MemWrite = 0;
								IRload = 0;
								R1Sel = 0;
								MDRload = 0;
								R1R2Load = 0;
								ALU1 = 1;
								ALU2 = 3'b000;
								ALUop = 3'b011;
								ALUOutWrite = 1;
								RFWrite = 0;
								RegIn = 0;
								FlagWrite = 1;
							end
				   		end
			c4_asnsh: 	//control = 19'b0000000000000000100;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 1;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_shift: 	//control = 19'b0000000011001001001;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 1;
					ALU2 = 3'b100;
					ALUop = 3'b100;
					ALUOutWrite = 1;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 1;
				end
			c3_ori: 	//control = 19'b0000010100000000000;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 1;
					MDRload = 0;
					R1R2Load = 1;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c4_ori: 	//control = 19'b0000000010110101001;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 1;
					ALU2 = 3'b011;
					ALUop = 3'b010;
					ALUOutWrite = 1;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 1;
				end
			c5_ori: 	//control = 19'b0000010000000000100;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 1;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 1;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_load: 	//control = 19'b0010001000000000000;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 1;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 1;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c4_load: 	//control = 19'b0000000000000001110;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 1;
					RFWrite = 1;
					RegIn = 1;
					FlagWrite = 0;
				end
			c3_store: 	//control = 19'b0001000000000000000;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 1;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_bpz: 	//control = {~N,18'b000000000100000000};
				begin
					PCwrite = ~N;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b010;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_bz: 		//control = {Z,18'b000000000100000000};
				begin
					PCwrite = Z;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b010;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_bnz: 	//control = {~Z,18'b000000000100000000};
				begin
					PCwrite = ~Z;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b010;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
			c3_nop:
				begin
					PCwrite = 0; //DC
					AddrSel = 0;  //DC
					MemRead = 0; //disable
					MemWrite = 0; //disable
					IRload = 0; //disable
					R1Sel = 0; //dc
					MDRload = 0; //disable
					R1R2Load = 0; //disable
					ALU1 = 0;  //dc
					ALU2 = 3'b010; //dc
					ALUop = 3'b000; // operation op code? Dc
					ALUOutWrite = 0; //disable
					RFWrite = 0; //disable
					RegIn = 0; //dc
					FlagWrite = 0; //make it follow itself
				end
				
			c3_stop:
				begin
					PCwrite = 0; //DC
					AddrSel = 0;  //DC
					MemRead = 0; //disable
					MemWrite = 0; //disable
					IRload = 0; //disable
					R1Sel = 0; //dc
					MDRload = 0; //disable
					R1R2Load = 0; //disable
					ALU1 = 0;  //dc
					ALU2 = 3'b010; //dc
					ALUop = 3'b000; // operation op code? Dc
					ALUOutWrite = 0; //disable
					RFWrite = 0; //disable
					RegIn = 0; //dc
					FlagWrite = 0; //make it follow itself
				end
			
			default:	//control = 19'b0000000000000000000;
				begin
					PCwrite = 0;
					AddrSel = 0;
					MemRead = 0;
					MemWrite = 0;
					IRload = 0;
					R1Sel = 0;
					MDRload = 0;
					R1R2Load = 0;
					ALU1 = 0;
					ALU2 = 3'b000;
					ALUop = 3'b000;
					ALUOutWrite = 0;
					RFWrite = 0;
					RegIn = 0;
					FlagWrite = 0;
				end
		endcase
	end
	
endmodule*/
