//~~~Control Unit~~~// WIP
module control_unit(input     [5:0] op,
		   output reg [1:0] alu_op,
		   output reg reg_dst, branch, mem_read, mem_to_reg,
	                      mem_write, alu_src, reg_write);
always_comb case (op)
	6'b000000 : begin  //R-format
		alu_op     <= 2'b10;
		reg_dst    <= 1'b1;
		branch     <= 1'b0;
		mem_read   <= 1'b0;
		mem_to_reg <= 1'b0;
		mem_write  <= 1'b0;
		alu_src    <= 1'b0;
		reg_write  <= 1'b1;
	end
	6'b100011 : begin  //lw
		alu_op     <= 2'b00;
		reg_dst    <= 1'b0;
		branch     <= 1'b0;
		mem_read   <= 1'b1;
		mem_to_reg <= 1'b1;
		mem_write  <= 1'b0;
		alu_src    <= 1'b1;
		reg_write  <= 1'b1;
	end
	6'b101011 : begin  //sw
		alu_op     <= 2'b00;
		reg_dst    <= 1'bx;
		branch     <= 1'b0;
		mem_read   <= 1'b0;
		mem_to_reg <= 1'bx;
		mem_write  <= 1'b1;
		alu_src    <= 1'b1;
		reg_write  <= 1'b0;
	end
	6'b000100 : begin  //beq
		alu_op     <= 2'b01;
		reg_dst    <= 1'bx;
		branch     <= 1'b1;
		mem_read   <= 1'b0;
		mem_to_reg <= 1'bx;
		mem_write  <= 1'b0;
		alu_src    <= 1'b0;
		reg_write  <= 1'b0;
	end
	default: begin
		alu_op     <= 2'b11;
		reg_dst    <= 1'b1;
		branch     <= 1'b0;
		mem_read   <= 1'b0;
		mem_to_reg <= 1'bx;
		mem_write  <= 1'b0;
		alu_src    <= 1'b0;
		reg_write  <= 1'b0;
	end
endcase
endmodule


//~~~ALU Control~~~// Control logic for the ALU
module alu_control (input  [1:0] alu_op, 
		   input  [5:0] fcode, 
		   output reg [3:0]alu_ctrl);
always casex ({alu_op,fcode})
	8'b00_xxxxxx: alu_ctrl <= 2;  //lw and sw 
	8'b01_xxxxxx: alu_ctrl <= 6;  //branch
	8'b1x_100000: alu_ctrl <= 2;  //add
	8'b1x_100010: alu_ctrl <= 6;  //sub
	8'b1x_100100: alu_ctrl <= 0;  //and
	8'b1x_100101: alu_ctrl <= 1;  //or
	8'b1x_100111: alu_ctrl <= 12; //nor
	8'b1x_101010: alu_ctrl <= 7;  //slt
	default: alu_ctrl <= 15;
endcase
endmodule
