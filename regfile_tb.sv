`timescale 1ns/1ns

module regfile_tb;

parameter CYCLE = 50;
parameter W = 8, N = 5;
integer output_file;
integer i, j, k, m, wrong, correct;

//setting up registers for interacting with DUT
reg [W-1:0] wdata, rdata1, rdata2;
reg [N-1:0] rreg1, rreg2, wreg;
reg write, clk, reset;

//instatiating DUT
//Reg_file regfile_0(.*);
gate_Reg_file regfile_0(.*);

//setting up clock signal
initial clk = 0;
always begin
	#(CYCLE/2);
	clk = ~clk;
end

//setting up output file
initial begin
	output_file = $fopen("output_data_regfile", "wb");
	if(output_file==0) $display ("ERROR: CAN NOT OPEN output_file");

write = 1'b0;
reset = 1'b1;
#(CYCLE*1.5);
reset = 1'b0;
end

//Testing with random inputs
initial begin
correct = 0;
wrong = 0;
//waiting for reset
#(CYCLE*4);
//checking registers are set to 0
repeat (10) begin
	i = $urandom_range(31,0);
	j = $urandom_range(31,0);
	rreg1 = i;
	rreg2 = j;
	#(CYCLE*2);
	if (rdata1 == 0 && rdata2 == 0) begin
		$fdisplay(output_file, "rdata1 = %d  rdata2 = %d  wdata1 = %d  wdata2 = %d  CORRECT",rdata1,rdata2,k,m);
		correct++;
	end
	else begin
		$fdisplay(output_file, "rdata1 = %d  rdata2 = %d  wdata1 = %d  wdata2 = %d  WRONG",rdata1,rdata2,k,m);
		wrong++;
	end
end

//testing write and read
repeat (1000) begin
	i = $urandom_range(31,0);
	j = $urandom_range(31,0);
	k = $urandom_range(255,0);
	m = $urandom_range(255,0);
	write = 1'b1;
	wreg = i;
	wdata = k;
	rreg1 = i;
	rreg2 = j;
	#(CYCLE)
	wreg = j;
	wdata = m;
	#(CYCLE);
	write = 1'b0;
	#(CYCLE);//mainly to help provide a clear separation in the wave view
	//checking if data was loaded written
	if (rdata1 == k && rdata2 == m) begin
		$fdisplay(output_file, "rdata1 = %d  rdata2 = %d  wdata1 = %d  wdata2 = %d  CORRECT",rdata1,rdata2,k,m);
		correct++;
	end
	//edge case where rreg1 and rreg2 got the same input addr due to random input k no longer valid to check
	else if ((rreg1 == rreg2) && (rdata1 == m) && (rdata2 == m)) begin
		$fdisplay(output_file, "rdata1 = %d  rdata2 = %d  wdata1 = %d  wdata2 = %d  CORRECT",rdata1,rdata2,k,m);
		correct++;
	end
	else begin
		$fdisplay(output_file, "rdata1 = %d  rdata2 = %d  wdata1 = %d  wdata2 = %d  WRONG",rdata1,rdata2,k,m);
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

