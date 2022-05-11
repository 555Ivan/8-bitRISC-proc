//MIPS RISC 8-bit processor
//
//Needs to be tested, set up for external programing on the instruction mem
module proc_top(input clk, reset);
//parameter W represents data width
parameter data_width = 8, addr_width = 8, num_reg = 5, instruct_width = 32;

wire [instruct_width-1:0] instruct, inst_addr, pc_next, extended, pc_1, pc_branch;
wire [data_width-1:0] dm_o, rdata1, rdata2, wdata, ALU_o, ALU_b;
wire [num_reg-1:0] wreg, rreg1, rreg2;
wire [5:0] op, fcode;
wire [3:0] ALU_ctrl;
wire [1:0] alu_op;
wire reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, zero;

//Program counter
assign pc_1 = inst_addr + 32'b1;
assign pc_branch = pc_1 + extended;
assign pc_next = (branch & zero) ? pc_branch : pc_1;
prog_cnt #(.W(instruct_width)) prog_cnt_0(
.pc_i(pc_next), .reset(reset), .clk(clk), .pc_o(inst_addr)
);

//Instruction memory
//set up for external programing
SRAM #(.W(instruct_width), .N(instruct_width)) i_mem(
.addr(inst_addr), .d_i(), .cs(1'b1), .oe(1'b1), .we(1'b0), .d_o(instruct)
);

//Control Uniti
assign op = instruct[31:26];
control_unit control_u_0(
.op(op), .alu_op(alu_op), .reg_dst(reg_dst), .branch(branch), .mem_read(mem_read), 
.mem_to_reg(mem_to_reg), .mem_write(mem_write), .alu_src(alu_src), .reg_write(reg_write)
);

//Register file
assign rreg1 = instruct[25:21];
assign rreg2 = instruct[20:16];
assign wreg  = reg_dst ? instruct [15:11] : rreg2;
assign wdata = mem_to_reg ? dm_o : ALU_o;
Reg_file #(.W(data_width),. N(num_reg)) Reg_file_0(
.rreg1(rreg1), .rreg2(rreg2), .wreg(wreg), .wdata(wdata), .write(reg_write), 
.clk(clk), .reset(reset), .rdata1(rdata1), .rdata2(rdata2)
);

//ALU Control
assign fcode = instruct[5:0];
alu_control alu_ctrl_0(
.alu_op(alu_op), .fcode(fcode), .alu_ctrl(ALU_ctrl)
);

//Sign-extend
sign_extend sign_extend_0(
.in(instruct[15:0]), .out(extended)
); 

//ALU
assign ALU_b = alu_src ? extended[7:0] : rdata2 ;
ALUnit #(.W(data_width)) ALU_0(
.A(rdata1), .B(ALU_b), .ALU_ctrl(ALU_ctrl), .ALU_o(ALU_o), .cout(), .zero(zero)
);

//Data memory
SRAM #(.W(data_width), .N(addr_width)) d_mem(
.addr(ALU_o), .d_i(rdata2), .cs(1'b1), .oe(mem_read), .we(mem_write), .d_o(dm_o) 
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


//~~~Sign-extend~~~//
module sign_extend (input  [15:0] in,
		    output [31:0] out);
assign out = {16'b0, in};
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
		7:  ALU_o <= A < B ? 8'b1:8'b0; //slt
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
