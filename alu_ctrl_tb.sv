`timescale 1ns/1ns

module alu_ctrl_tb;

parameter CYCLE = 50;
//parameter W = 8, N = 5;
integer output_file;
integer i, j, k, m, wrong, correct;

//setting up registers for interacting with DUT
reg [5:0] fcode;
reg [3:0] alu_ctrl;
reg [1:0] alu_op;

//instatiating DUT
alu_control alu_control_0(.*);

//setting up output file
initial begin
	output_file = $fopen("output_data_alu_control", "wb");
	if(output_file==0) $display ("ERROR: CAN NOT OPEN output_file");
end

//Testing with random inputs
initial begin
correct = 0;
wrong = 0;

repeat (1000) begin
	i = $urandom_range(3,0);
	j = $urandom_range(42,32);//constrained so it's more likely to hit the 6 possible valid inputs
	alu_op = i;
	fcode = j;
	#(CYCLE);
	//lw, sw, and ADDI
	if ((alu_op == 0) && (alu_ctrl == 2)) begin
		$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
		correct++;
	end
	//branch
	else if (( alu_op == 1) && (alu_ctrl == 6)) begin
		$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
		correct++;
	end
	//R-format
	else if ((alu_op == 2) || (alu_op == 3)) begin
		//add
		if ((fcode == 6'b100000) && (alu_ctrl == 2)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
		//sub
		else if ((fcode == 6'b100010) && (alu_ctrl == 6)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
		//and
		else if ((fcode == 6'b100100) && (alu_ctrl == 0)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
		//or
		else if ((fcode == 6'b100101) && (alu_ctrl == 1)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
		//nor
		else if ((fcode == 6'b100111) && (alu_ctrl == 12)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
		//slt
		else if ((fcode == 6'b101010) && (alu_ctrl == 7)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
		//default
		else if ((alu_ctrl == 15)) begin
			$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  CORRECT",alu_op,fcode,alu_ctrl);
			correct++;
		end
	end
	else begin
		$fdisplay(output_file, "alu_op = %d  fcode = %d  alu_ctrl = %d  WRONG",alu_op,fcode,alu_ctrl);
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

