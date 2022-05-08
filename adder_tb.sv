`timescale 1ns/1ns

module adder_tb;


parameter CYCLE = 100;
parameter W = 8;
integer output_file;
integer i, j, k, wrong, correct;

//setting up registers for interacting with DUT
reg [W-1:0] a, b, s;
reg cin, cout;


//instatiating DUT
prefixadder preadd_0(
	.a(a),
	.b(b),
	.cin(cin),
	.s(s),
	.cout(cout)
);

//CLAadder CLAadder_0(
//         .a(a),
//         .b(b),
//	 .cin(cin),
//	 .s(s),
//	 .cout(cout)
//);

//setting up output file
initial begin
	output_file = $fopen("output_data_adder", "wb");
	if(output_file==0) $display ("ERROR: CAN NOT OPEN output_file");
end

//Testing all possible inputs
initial begin
correct = 0;
wrong = 0;
	for (i = 0; i < (2**W); i++) begin
		for (j = 0; j < (2**W); j++) begin
			for (k = 0; k < 2; k++) begin
				a = i;
				b = j;
				cin = k;
				#(CYCLE);
				if({cout, s} == (i+j+k)) begin
					$fdisplay(output_file, "a = %d  b = %d  cin = %d  s = %d  cout = %d CORRECT",a,b,cin,s,cout);
					correct++;
				end
				else begin
					$fdisplay(output_file, "a = %d  b = %d  cin = %d  s = %d  cout = %d WRONG",a,b,cin,s,cout);
					wrong++;
				end
			end
		end
	end	
	$fdisplay(output_file, "Correct = %d  ~~~~~ Wrong = %d", correct, wrong);
	$fclose(output_file);
	$display("Operation done, Time = %0t",$time);
	$stop;

end

endmodule

