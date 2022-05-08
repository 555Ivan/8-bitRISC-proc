module CLAadder (input [7:0] a,b,
					  input cin,
					  output [7:0] s,
					  output cout);	


wire cout0, cout1, cout2;

CLA2bitblock CLAb0(
             .a(a[1:0]),
				 .b(b[1:0]),
				 .cin(cin),
				 .s(s[1:0]),
				 .cout(cout0)
);

CLA2bitblock CLAb1(
             .a(a[3:2]),
				 .b(b[3:2]),
				 .cin(cout0),
				 .s(s[3:2]),
				 .cout(cout1)
);

CLA2bitblock CLAb2(
             .a(a[5:4]),
				 .b(b[5:4]),
				 .cin(cout1),
				 .s(s[5:4]),
				 .cout(cout2)
);

CLA2bitblock CLAb3(
             .a(a[7:6]),
				 .b(b[7:6]),
				 .cin(cout2),
				 .s(s[7:6]),
				 .cout(cout)
);

					  
endmodule
