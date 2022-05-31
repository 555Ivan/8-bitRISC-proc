`timescale 1ns/1ns

module control_unit_tb;

parameter CYCLE = 50;
//parameter W = 8, N = 5;
integer output_file;
integer i, j, k, m, wrong, correct;

//setting up registers for interacting with DUT
reg [5:0] op;
reg [1:0] alu_op;
reg reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jmp;

//instatiating DUT
control_unit control_unit_0(.*);

//setting up output file
initial begin
	output_file = $fopen("output_data_control_unit", "wb");
	if(output_file==0) $display ("ERROR: CAN NOT OPEN output_file");
end

//Testing with random inputs
initial begin
correct = 0;
wrong = 0;

repeat (5000) begin
	i = $urandom_range(43,0);//constrained so it's more likely to hit the 5 possibe valid inputs rather than default
	op = i;
	#(CYCLE);
	//R-format
	if ((op == 6'b000000) && ({alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp} == 10'b1010000010)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	//lw
	else if ((op == 6'b100011) && ({alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp} == 10'b0000110110)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = $d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	//sw
	else if ((op == 6'b101011) && ({alu_op,branch,mem_read,mem_write,alu_src,reg_write,jmp} == 8'b00001100) && (reg_dst === 1'bx) &&(mem_to_reg === 1'bx)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	//beq
	else if ((op == 6'b000100) && ({alu_op,branch,mem_read,mem_write,alu_src,reg_write,jmp} == 8'b01100000) && (reg_dst === 1'bx) && (mem_to_reg === 1'bx)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	//ADDI
	else if ((op == 6'b001000) && ({alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp} == 10'b0000000110)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	//jump
	else if ((op == 6'b000010) && ({alu_op,branch,mem_read,mem_write,alu_src,reg_write,jmp} == 8'b00000001) && (reg_dst === 1'bx) &&(mem_to_reg === 1'bx)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	//default
	else if (({alu_op,reg_dst,branch,mem_read,mem_write,alu_src,reg_write,jmp} == 9'b111000000) && (mem_to_reg === 1'bx)) begin 
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  CORRECT",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		correct++;
	end
	else begin
		$fdisplay(output_file, "op = %d  alu_op = %d  reg_dst = %d  branch = %d  mem_read = %d  mem_to_reg = %d  mem_write = %d  alu_src = %d  reg_write = %d  jmp = %d  WRONG",op,alu_op,reg_dst,branch,mem_read,mem_to_reg,mem_write,alu_src,reg_write,jmp);
		wrong++;
	end

end

	$fdisplay(output_file, "Correct = %d  ~~~~~ Wrong = %d", correct, wrong);
	$display("Correct = %d  ~~~~~ Wrong = %d", correct, wrong);
	$fclose(output_file);
	$display("Operation done, Time = %0t",$time);
	$stop;

end

endmodule

