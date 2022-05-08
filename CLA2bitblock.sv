module CLA2bitblock (input [1:0] a,b,
							input cin,
							output [1:0] s,
							output cout);
							
wire cout_interal;
fulladder fa0(
          .a(a[0]),
			 .b(b[0]),
			 .cin(cin),
			 .s(s[0]),
			 .cout(cout_interal)
);
fulladder fa1(
          .a(a[1]),
			 .b(b[1]),
			 .cin(cout_interal),
			 .s(s[1]),
			 .cout()        
);

//            |    G1            P1         G0      |   |      P1          P0         | 
assign cout = ((a[1]*b[1])+((a[1]+b[1])*(a[0]*b[0]))) + (((a[1]+b[1])*(a[0]+b[0]))*cin);
	

endmodule
