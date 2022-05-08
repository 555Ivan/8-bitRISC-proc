`timescale 1ns/1ns

module ALU_tb;


parameter CYCLE = 100;
parameter W = 8;
integer output_file;
integer i, j, k, wrong, correct;

//setting up registers for interacting with DUT
reg [W-1:0] a, b, alu_o;
reg [3:0] alu_ctrl;
reg cout, zero;

//instatiating DUT
ALUnit ALUnit_0(
	.A(a),
	.B(b),
	.ALU_ctrl(alu_ctrl),
	.zero(zero),
	.ALU_o(alu_o),
	.cout(cout)
);



//setting up output file
initial begin
	output_file = $fopen("output_data_ALU", "wb");
	if(output_file==0) $display ("ERROR: CAN NOT OPEN output_file");
end

initial begin
correct = 0;
wrong = 0;

//~~Testing all possible inputs~~
/*for(i=0;i<(2**W);i++) begin
	for(j=0;j<(2**W);j++) begin
		for(k=0;k<6;k++) begin
			if(k==0)      alu_ctrl = 0; //mapping for loop to proper ALU_ctrl inputs
			else if(k==1) alu_ctrl = 1;
			else if(k==2) alu_ctrl = 2;
			else if(k==3) alu_ctrl = 6;
			else if(k==4) alu_ctrl = 7;
			else if(k==5) alu_ctrl = 12;
			else          alu_ctrl = 0;
		a = i;
		b = j;
		#(CYCLE);
		if ((alu_o == (a & b)) && (alu_ctrl == 0)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
		end
		else if ((alu_o == (a | b)) && (alu_ctrl == 1)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
		end
		else if(({cout, alu_o} == (a+b)) && (alu_ctrl == 2)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
		end
		else if ((alu_o == (a-b)) && (alu_ctrl == 6)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
		end
		else if ((alu_o == (a < b ? 1:0)) && (alu_ctrl == 7)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
		end
		else if ((alu_o == ~(a | b)) && (alu_ctrl == 12)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
		end
		else begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  WRONG",a,b,alu_o,cout,alu_ctrl,zero);
		wrong++;
		end
		end
	end
end*/

//~~Testing using random inputs~~
repeat (1000) begin
	a = $urandom_range((2**W)-1,0);
	b = $urandom_range((2**W)-1,0);
	i = $urandom_range(5,0);
	if(i==0)      alu_ctrl = 0; //mapping i to proper ALU_ctrl inputs
	else if(i==1) alu_ctrl = 1;
	else if(i==2) alu_ctrl = 2;
	else if(i==3) alu_ctrl = 6;
	else if(i==4) alu_ctrl = 7;
	else if(i==5) alu_ctrl = 12;
	else          alu_ctrl = 0;
	#(CYCLE);
	if ((alu_o == (a & b)) && (alu_ctrl == 0)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
	end
	else if ((alu_o == (a | b)) && (alu_ctrl == 1)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
	end
	else if(({cout, alu_o} == (a+b)) && (alu_ctrl == 2)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
	end
	else if ((alu_o == (a-b)) && (alu_ctrl == 6)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
	end
	else if ((alu_o == (a < b ? 1:0)) && (alu_ctrl == 7)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
	end
	else if ((alu_o == ~(a | b)) && (alu_ctrl == 12)) begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  CORRECT",a,b,alu_o,cout,alu_ctrl,zero);
		correct++;
	end
	else begin
		$fdisplay(output_file, "a = %d  b = %d  alu_o = %d  cout = %d  alu_ctrl = %d  zero = %d  WRONG",a,b,alu_o,cout,alu_ctrl,zero);
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

