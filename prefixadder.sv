module prefixadder (input  [7:0] a,b,
		    input  cin,
		    output [7:0] s,
		    output cout);
					  
//g-1 = cin and p-1 = 0
wire p0, p1, p2, p3, p4, p5, p6, p7, p0_1, p1_1, p2_1, p3_1, p4_1, p5_1, p6_1, p7_1, p21, p43, p65, p53, p63;
wire g0, g1, g2, g3, g4, g5, g6, g7, g0_1, g1_1, g2_1, g3_1, g4_1, g5_1, g6_1, g7_1, g21, g43, g65, g53, g63;

//Initial prefixes ~~ Generate and Propagate for each collumn			  
assign p0 = a[0]+b[0];
assign p1 = a[1]+b[1];
assign p2 = a[2]+b[2];
assign p3 = a[3]+b[3];
assign p4 = a[4]+b[4];
assign p5 = a[5]+b[5];
assign p6 = a[6]+b[6];
assign p7 = a[7]+b[7];

assign g0 = a[0]*b[0];		  
assign g1 = a[1]*b[1];		  
assign g2 = a[2]*b[2];		  
assign g3 = a[3]*b[3];		  
assign g4 = a[4]*b[4];		  
assign g5 = a[5]*b[5];		  
assign g6 = a[6]*b[6];		  
assign g7 = a[7]*b[7];		  

//Rest of prefixes ~~ internal generate and propagate signals
//level 1
assign p0_1 = p0 * 0;
assign g0_1 = g0 + (p0 * cin);

assign p21 = p2 * p1;
assign g21 = g2 + (p2 * g1);

assign p43 = p4 * p3;
assign g43 = g4 + (p4 * g3);

assign p65 = p6 * p5;
assign g65 = g6 + (p6 * g5);

//level 2
assign p1_1 = p1 * p0_1;
assign g1_1 = g1 + (p1 * g0_1);

assign p2_1 = p21 * p0_1;
assign g2_1 = g21 + (p21 * g0_1);

assign p53 = p5 * p43;
assign g53 = g5 + (p5 * g43);

assign p63 = p65 * p43;
assign g63 = g65 + (p65 * g43);

//level 3
assign p3_1 = p3 * p2_1;
assign g3_1 = g3 + (p3 * g2_1);

assign p4_1 = p43 * p2_1;
assign g4_1 = g43 + (p43 * g2_1);

assign p5_1 = p53 * p2_1;
assign g5_1 = g53 + (p53 * g2_1);

assign p6_1 = p63 * p2_1;
assign g6_1 = g63 + (p63 * g2_1);

assign p7_1 = p7 * p6_1;
assign g7_1 = g7 + (p7 * g6_1);

//Calculate S output for each collumn
assign s[0] = (a[0] ^ b[0]) ^ cin;
assign s[1] = (a[1] ^ b[1]) ^ g0_1;
assign s[2] = (a[2] ^ b[2]) ^ g1_1;
assign s[3] = (a[3] ^ b[3]) ^ g2_1;
assign s[4] = (a[4] ^ b[4]) ^ g3_1;
assign s[5] = (a[5] ^ b[5]) ^ g4_1;
assign s[6] = (a[6] ^ b[6]) ^ g5_1;
assign s[7] = (a[7] ^ b[7]) ^ g6_1;

assign cout = p7_1 + g7_1;

					  
endmodule
