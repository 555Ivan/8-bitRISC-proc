//MIPS RISC 8-bit processor
module proc_top(input clk, reset);

//parameter W represents data width
parameter data_width = 8, addr_width = 8, num_reg = 5, instruct_width = 32;

reg [instruct_width-1:0] instruct;

prog_cnt #(.W(data_width)) prog_cnt_0(
.pc_i(), .reset(reset), .clk(clk), .pc_o(inst_addr)
);

//set up for external programing
SRAM #(.W(instruct_width), .N(addr_width)) i_mem(
.addr(inst_addr), .d_i(), .cs(1'b1), .oe(1'b1), .we(1'b0), .d_o(instruct)
);

//needs ctrl signals
SRAM #(.W(data_width), .N(addr_width)) d_mem(
.addr(ALU_o), .d_i(rdata2), .cs(1'b1), .oe(), .we(), .d_o(dm_o) 
);

//needs ctrl signal
ALUnit #(.W(data_width)) ALU_0(
.A(rdata1), .B(), .ALU_ctrl(), .ALU_o(ALU_o), .cout(), .zero()
);

//needs ctrl signal
Reg_file #(.W(data_width),. N(num_reg)) Reg_file_0(
.rreg1(instruct[25:21]), .rreg2(instruct[20:16]), .wreg(instruct[15:11]), 
.wdata(), .write(), .clk(clk), .reset(reset), .rdata1(rdata1), .rdata2(rdata2)
);
endmodule


//~~~Program Counter~~~//
module prog_cnt #(parameter W = 8)
                (input  [W-1:0] pc_i,
		 input  reset, clk,
	 	 output [W-1:0] pc_o);
d_ff d_ff [W] (.D(pc_i),
	       .clk(clk),
	       .reset(reset),
	       .Q(pc_o));
endmodule


//~~~SRAM~~~// 256 X 8 
module SRAM #(parameter W = 8, N = 8)
             (input  [N-1:0] addr,
              input  [W-1:0] d_i,
              input  cs, oe, we,
              output [W-1:0] d_o);

reg [W-1:0] mem [2**N];

always @(*) begin
	if(cs & we) mem[addr] <= d_i;
end

assign d_o = (cs & oe & !we) ? mem[addr] : 'hz;
endmodule


//~~~ALU~~~// 
module ALUnit #(parameter W = 8)
	       (input  [W-1:0] A, B,
	        input  [3:0] ALU_ctrl,
		output reg [W-1:0] ALU_o,
		output reg cout, 
		output zero);
integer i;
reg [W-1:0] B_inv, result;
wire sub;

always@(ALU_ctrl, A, B, result) begin
	case (ALU_ctrl) 
		0:  ALU_o <= A & B;       //and
		1:  ALU_o <= A | B;       //or
		2:  ALU_o <= result;      //add
		6:  ALU_o <= result;      //sub
		7:  ALU_o <= A < B ? 1:0; //slt
		12: ALU_o <= ~(A|B);      //nor
		default: ALU_o <= 0;
	endcase
end

always @(*) begin
	for(i=0;i<W;i++) B_inv[i] = B[i] ^ sub;
end
prefixadder preadd_0(.a(A),
		     .b(B_inv),
		     .cin(sub),
		     .s(result),
		     .cout(cout)
);
assign sub = (ALU_ctrl == 6);
assign zero = (ALU_o == 0);
endmodule


//~~~RegisterFile~~~// 2 read addresses and 2 read outputs with 1 write port
module Reg_file #(parameter W = 8, N = 5)
		(input  [N-1:0]   rreg1, rreg2, wreg,
		 input  [W-1:0] wdata,
		 input          write, clk, reset,
		 output [W-1:0] rdata1, rdata2);
integer i;
reg [W-1:0] reg_block [2**N];
assign rdata1 = reg_block[rreg1];
assign rdata2 = reg_block[rreg2];

always @(posedge clk) begin
	if(reset)
		for(i=0;i<2**N;i++) reg_block[i] <= 0;
	else if(write)
		reg_block[wreg] <= wdata;
end
endmodule


//~~~D-flipflop~~~//
module d_ff (input  D, clk, reset,
	     output reg Q);

always_ff @(posedge clk) begin
	if(reset) begin
		Q <= 1'b0; 
	end
	else begin
     		Q <= D; 
	end	
end
endmodule


//~~~tristate buffer~~~//
module tristate (input  A, enable,
		 output B);
assign B = enable? A:'bz;
endmodule

//~~~ALU~~~// using implicit add and sub
/*module ALUnit #(parameter W = 8)
	       (input  [W-1:0] A, B,
	        input  [3:0] ALU_ctrl,
		output reg [W-1:0] ALU_o,
		output reg cout, 
		output zero);

always@(ALU_ctrl, A, B) begin
	case (ALU_ctrl) 
		0:  ALU_o <= A & B;
		1:  ALU_o <= A | B;
		2:  {cout, ALU_o} <= A + B;
		6:  ALU_o <= A - B;
		7:  ALU_o <= A < B ? 1:0;
		12: ALU_o <= ~(A|B);
		default: ALU_o <= 0;
	endcase
end
assign zero = (ALU_o == 0);
endmodule*/
