/*
the compounants used: 
3 of 4x1 multiplexer
4 of 2x1 multiplexer
1 not
1 and gate 
3 of full adders
*/

// Structural descriptions for  full adder.
module full_adder (output sum,output carry,input bit1,input bit2,input bit3);
// the logical  expression: 
// sum1 = bit1 ^ bit2
// carry1 = bit1 & bit2
// carry2= bit3 & sum1
// sum = bit3 ^ sum1
// carry= carry1 | carry 2

wire sum1,carry1,carry2;

xor (sum1,bit1,bit2);
and(carry1,bit1,bit2);
xor(sum,bit3,sum1);
and(carry2,bit3,sum1);

or(carry,carry1,carry2);
endmodule

// Structural descriptions for  2x1 multiplexer
module MUX2x1 (output out,input s, in0, in1);
wire b0,b1,snot;
not(snot,s);
and(b0,in0,snot);
and(b1,in1,s);
or(out,b0,b1);
endmodule

// Structural descriptions for  4x1 multiplexer
module MUX4x1 (output out,input s0,input s1,input in0,input in1,input in2,input in3);
// the logical  expression: 
// out = (s1' s0' in0) + (s1' s0 in1) + (s' s0' in2) + (s1 s0 in3)

 wire a0,a1,a2,a3,s0not,s1not;
 not(s0not,s0);
 not(s1not,s1);
 and(a0,s1not,s0not,in0);
 and(a1,s1not,s0,in1);
 and(a2,s1,s0not,in2);
 and(a3,s1,s0,in3);

 or(out,a0,a1,a2,a3);

endmodule

// Structural descriptions for the main curcuit which do the following --> (a+b,a-b,a-1,-b)
module arithmetic_curcuit(output [2:0] g,input s0,input s1,input[2:0] a,input[2:0] b);
// the curcuit is a 3 full adderr and some multuiplexers
// each adder takes input (wire from 2x1 mux and wire from 4x1 mux and a carry) and gives the output "g" and a carry for the next full adder
// the 4x1 mux have selectors {s0, s1} and selects from (1,b,b',b')
// the 2x1 mux have selector (s1&s2) and selects from (a,0)

wire [0:2]b_not;
wire [0:2]A_in; // out from the 2x1 mux
wire [0:2]B_in; // out from the 4x1 mux

wire s0ands1; // s0 & s1
and(s0ands1,s0,s1);

// b bar
not(b_not[0],b[0]);
not(b_not[1],b[1]);
not(b_not[2],b[2]);

// 3 2x1 mux 1 for each bit
//it prevents the input "A" from going to the adder when we have the case "-B" 
MUX2x1 mm1(A_in[0],s0ands1,a[0],1'b0);
MUX2x1 mm2(A_in[1],s0ands1,a[1],1'b0);
MUX2x1 mm3(A_in[2],s0ands1,a[2],1'b0);

// carry input for the first adder 
// this carry is coming from a 2x1 mux
// to pass "1" to the full adder in case (A-B) and (-B) 
wire incarry; 
MUX2x1 mm4(incarry,s1,1'b0,1'b1);

// 4x1 mux for each bit
// passes "B bar" or "1" or "B" 
MUX4x1 m1(B_in[0],s0,s1,1'b1,b[0],b_not[0],b_not[0]);
MUX4x1 m2(B_in[1],s0,s1,1'b1,b[1],b_not[1],b_not[1]);
MUX4x1 m3(B_in[2],s0,s1,1'b1,b[2],b_not[2],b_not[2]);

// the carries coming from a full adder and given to the next full adder
wire [0:2]carries;


// the full adder which gives the output
full_adder f1(g[0],carries[0],incarry,A_in[0],B_in[0]);
full_adder f2(g[1],carries[1],carries[0],A_in[1],B_in[1]);
full_adder f3(g[2],carries[2],carries[1],A_in[2],B_in[2]);

endmodule


module test();

wire [2:0] g; // output
reg s0,s1;
reg [2:0]a; // A input 
reg [2:0]b; // B input
   
arithmetic_curcuit ac(.g(g),.s0(s0),.s1(s1),.a(a),.b(b));
initial
 begin
$monitor($time, "  a=%b,  b=%b,  s0=%b,  s1=%b,  g=%b",a,b, s0,s1, g);

// a=-2 ,b=-1;
#10 a=110; b=111; s1=0; s0=0; // a-1 = -3 = 101
#10 a=110; b=111; s1=0; s0=1; // a+b = -3 = 101
#10 a=110; b=111; s1=1; s0=0; // a-b = -1 = 111
#10 a=110; b=111; s1=1; s0=1; // -b = 1 = 001

// a=-3 ,b=-3;
#10 a=101; b=101; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=101; s1=0; s0=1; // a+b = -6 = 010
#10 a=101; b=101; s1=1; s0=0; // a-b = 0 = 000
#10 a=101; b=101; s1=1; s0=1; // -b = 3 = 011

// a=-3 ,b=-2;
#10 a=101; b=110; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=110; s1=0; s0=1; // a+b = -5 = 011
#10 a=101; b=110; s1=1; s0=0; // a-b = -1 = 111
#10 a=101; b=110; s1=1; s0=1; // -b = 2 = 010

// a=-3 ,b=-1;
#10 a=101; b=111; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=111; s1=0; s0=1; // a+b = -4 = 100
#10 a=101; b=111; s1=1; s0=0; // a-b = -2 = 110
#10 a=101; b=111; s1=1; s0=1; // -b = 1 = 001

// a=-3 ,b=0;
#10 a=101; b=000; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=000; s1=0; s0=1; // a+b = -3 = 101
#10 a=101; b=000; s1=1; s0=0; // a-b = -3 = 101
#10 a=101; b=000; s1=1; s0=1; // -b = 0 = 000

// a=-3 ,b=1;
#10 a=101; b=001; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=001; s1=0; s0=1; // a+b = -2 = 110
#10 a=101; b=001; s1=1; s0=0; // a-b = -4 = 100
#10 a=101; b=001; s1=1; s0=1; // -b = -1 = 111

// a=-3 ,b=2;
#10 a=101; b=010; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=010; s1=0; s0=1; // a+b = -1 = 111
#10 a=101; b=010; s1=1; s0=0; // a-b = -5 = 011
#10 a=101; b=010; s1=1; s0=1; // -b = -2 = 110

// a=-3 ,b=3;
#10 a=101; b=011; s1=0; s0=0; // a-1 = -4 = 100
#10 a=101; b=011; s1=0; s0=1; // a+b = 0 = 000
#10 a=101; b=011; s1=1; s0=0; // a-b = -6 = 010
#10 a=101; b=011; s1=1; s0=1; // -b = -3 = 101

// a=-2 ,b=-2;
#10 a=110; b=110; s1=0; s0=0; // a-1 = -3 = 101
#10 a=110; b=110; s1=0; s0=1; // a+b = -4 = 100
#10 a=110; b=110; s1=1; s0=0; // a-b = 0 = 000
#10 a=110; b=110; s1=1; s0=1; // -b = 2 = 010

$finish;
end

endmodule