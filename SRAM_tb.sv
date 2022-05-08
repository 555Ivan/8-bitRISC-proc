`timescale 1ns/1ns

module sram_tb;

parameter CYCLE = 50;
parameter W = 8, N = 8;
integer output_file;
integer i, j, k, m, wrong, correct;

//setting up registers for interacting with DUT
reg [W-1:0] d_i, d_o;
reg [N-1:0] addr;
reg cs, oe, we;

//instatiating DUT
SRAM SRAM_0(.*);

//setting up output file
initial begin
	output_file = $fopen("output_data_SRAM", "wb");
	if(output_file==0) $display ("ERROR: CAN NOT OPEN output_file");

end

//Testing
initial begin
correct = 0;
wrong = 0;
cs = 1'b0;
oe = 1'b0;
we = 1'b0;
#(CYCLE);
cs = 1'b1;
#(CYCLE);

repeat (1000) begin
	i = $urandom_range(2**N,0);
	j = $urandom_range(2**W,0);
	k = $urandom_range(1,0);
	we = 1'b1;
	addr = i;
	d_i  = j;
	#(CYCLE);
	we = 1'b0;
	oe = k;
	#(CYCLE)

	if (d_i == d_o) begin
		$fdisplay(output_file, "d_i = %d  d_o = %d  addr = %d  cs = %d  we = %d  oe = %d  CORRECT",d_i,d_o,addr,cs,we,oe);
		correct++;
	end
	else if (oe == 0 && $countbits(d_o,'z)) begin
		$fdisplay(output_file, "d_i = %d  d_o = %d  addr = %d  cs = %d  we = %d  oe = %d  CORRECT",d_i,d_o,addr,cs,we,oe);
		correct++;
	end
	else begin
		$fdisplay(output_file, "d_i = %d  d_o = %d  addr = %d  cs = %d  we = %d  oe = %d  WRONG",d_i,d_o,addr,cs,we,oe);
		wrong++;
	end
	oe = 1'b0;
end

	$fdisplay(output_file, "Correct = %d  ~~~~~ Wrong = %d", correct, wrong);
	$display("Correct = %d  ~~~~~ Wrong = %d", correct, wrong);
	$fclose(output_file);
	$display("Operation done, Time = %0t",$time);
	$stop;

end

endmodule

