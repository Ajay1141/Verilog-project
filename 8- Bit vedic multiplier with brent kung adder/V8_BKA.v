`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Design Name: 
// Module Name: V8_BKA
// Project Name:  
//////////////////////////////////////////////////////////////////////////////////

module V8_BKA(a,b,Q);
input[7:0]a,b;
output[15:0]Q;
wire [7:0]q0,q1,q2,q3,q4,q5;
wire [7:0]x0;
wire [3:0]x1,x2;
wire t3,t2,t0,t1;

V_M4 v0(a[3:0],b[3:0],q0[7:0]);
V_M4 v1(a[7:4],b[3:0],q1[7:0]);
V_M4 v2(a[3:0],b[7:4],q2[7:0]);
V_M4 v3(a[7:4],b[7:4],q3[7:0]);
assign x0={q3[3:0],q0[7:4]};
BKA8 a0(q1[7:0],q2[7:0],0,q4,t0);
BKA8 a1(q4,x0,0,q5,t1);
or o0(t2,t1,t0);
assign x2={4'b0000};
BKA4 a2(q3[7:4],x2[3:0],t2,x1[3:0],t3);
assign Q[3:0]=q0[3:0];
assign Q[11:4]=q5[7:0];
assign Q[15:12]=x1[3:0];
endmodule

// 4bit vedic multiplier
module V_M4(a,b,Q);
input[3:0]a,b;
output[7:0]Q;
wire [3:0]q0,q1,q2,q3,q4,q5;
wire [3:0]x0;
wire [1:0]x1,x2;
wire  t0,t1,t2;

V_M v0(a[1:0],b[1:0],q0[3:0]);
V_M v1(a[3:2],b[1:0],q1[3:0]);
V_M v2(a[1:0],b[3:2],q2[3:0]);
V_M v3(a[3:2],b[3:2],q3[3:0]);
assign x0={q3[1:0],q0[3:2]};
BKA4 a0(q1[3:0],q2[3:0],0,q4,t0);
BKA4 a1(q4,x0,0,q5,t1);
or o0(t2,t0,t1);
assign x2={2'b0};
CLA2 a2(q3[3:2],x2,t2,x1);
assign Q[1:0]=q0[1:0];
assign Q[5:2]=q5[3:0];
assign Q[7:6]=x1[1:0];
endmodule

//2bit vedic multiplier
module V_M(a,b,q);
input [1:0] a,b;
output [3:0]q;
wire [3:0]x;
assign q[0]=a[0]&b[0];
assign x[0]=a[1]&b[0];
assign x[1]=a[0]&b[1];
assign x[2]=a[1]&b[1];
ha h1(x[0],x[1],q[1],x[3]);
ha h2(x[2],x[3],q[2],q[3]);
endmodule

// 8bit BKA adder 
module BKA8(a,b,cin,s,cout);
input[7:0] a,b; input cin;
output[7:0] s; output cout;
wire[7:0] P,G; wire[10:0] ip,ig; wire[6:0] C;
stage0 s0(P,G,a,b);
stage1 s1(ip[3:0],ig[3:0],P,G);
stage2 s2(ip[5:4],ig[5:4],ip[3:0],ig[3:0]);
stage3 s3(ip[6],ig[6],ip[5:4],ig[5:4]);
stage4 s4(ip[9:7],ig[9:7],ip[0],P[2],ip[4],P[4],ip[2],ig[0],G[2],ig[4],G[4],ig[2]);
stage5 s5(ip[10],ig[10],ip[9],P[6],ig[9],G[6]);
carry  c6(C,cout,cin,ip,ig,P[0],G[0]);
sum    s7(s,C,cin,P);
endmodule

module stage0(P,G,a,b);
input[7:0] a, b;
output[7:0] P, G;
assign P[0]=a[0]^b[0], P[1]=a[1]^b[1], P[2]=a[2]^b[2], P[3]=a[3]^b[3], P[4]=a[4]^b[4], P[5]=a[5]^b[5], P[6]=a[6]^b[6], P[7]=a[7]^b[7],
       G[0]=a[0]&b[0], G[1]=a[1]&b[1], G[2]=a[2]&b[2], G[3]=a[3]&b[3], G[4]=a[4]&b[4], G[5]=a[5]&b[5], G[6]=a[6]&b[6], G[7]=a[7]&b[7];    
endmodule

module stage1(ip,ig,p,g);
input[7:0] p,g;
output[3:0] ip,ig;
assign ip[0]=p[0]&p[1], ip[1]=p[2]&p[3], ip[2]=p[4]&p[5], ip[3]=p[6]&p[7],
       ig[0]=g[1]|(g[0]&p[1]), ig[1]=g[3]|(g[2]&p[3]), ig[2]=g[5]|(g[4]&p[5]), ig[3]=g[7]|(g[6]&p[7]);
endmodule


module stage2(ip,ig,p,g);
input[3:0] p,g;
output[1:0] ip,ig;
assign ip[0]=p[0]&p[1], ip[1]=p[2]&p[3], ig[0]=g[1]|(g[0]&p[1]), ig[1]=g[3]|(g[2]&p[3]);
endmodule


module stage3(ip,ig,p,g);
input[1:0] p,g;
output ip,ig;
assign ip=p[0]&p[1], ig=g[1]|(g[0]&p[1]);
endmodule


module stage4(ip,ig,ip0,P2,ip4,P4,ip2,ig0,G2,ig4,G4,ig2);
input ip0,P2,ip4,P4,ip2,ig0,G2,ig4,G4,ig2;
output[2:0] ip,ig;
assign ip[0]=ip0&P2, ip[1]=ip4&P4, ip[2]=ip4&ip2,
       ig[0]=G2|(ig0&P2), ig[1]=G4|(ig4&P4), ig[2]=ig2|(ig4&ip2);
endmodule


module stage5(ip,ig,ip9,P6,ig9,G6);
input ip9,P6,ig9,G6;
output ip,ig;
assign ip=ip9&P6, ig=G6|(ig9&P6);
endmodule


module carry(C,cout,cin,ip,ig,P0,G0);
input cin,P0,G0; input[10:0] ip,ig;
output[6:0] C; output cout;
assign C[0]=G0|(P0&cin), C[1]=ig[0]|(ip[0]&cin), C[2]=ig[7]|(ip[7]&cin), C[3]=ig[4]|(ip[4]&cin),
       C[4]=ig[8]|(ip[8]&cin), C[5]=ig[9]|(ip[9]&cin), C[6]=ig[10]|(ip[10]&cin), cout=ig[6]|(ip[6]&cin);
endmodule


module sum(s,C,cin,P);
input[6:0] C; input[7:0] P; input cin;
output[7:0] s;
assign s[0]=P[0]^cin, s[1]=P[1]^C[0], s[2]=P[2]^C[1], s[3]=P[3]^C[2],
       s[4]=P[4]^C[3], s[5]=P[5]^C[4], s[6]=P[6]^C[5], s[7]=P[7]^C[6];
endmodule

// 4bit BKA adder
module BKA4(a,b,cin,s,cout);
input[3:0] a,b; input cin;
output[3:0] s; output cout;
wire[3:0] P,G; wire[3:0] ip,ig; wire[2:0] C;
stage0_4 s0(P,G,a,b);
stage1_4 s1(ip[1:0],ig[1:0],P,G);
stage2_4 s2(ip[3],ig[3],ip[1:0],ig[1:0]);
stage3_4 s3(ip[2],ig[2],P[2],G[2],ip[0],ig[0]);
carry_4  c4(C,cout,cin,ip,ig,P[0],G[0]);
sum_4    s5(s,C,cin,P);
endmodule

module stage0_4(P,G,a,b);
input[7:0] a, b;
output[7:0] P, G;
assign P[0]=a[0]^b[0], P[1]=a[1]^b[1], P[2]=a[2]^b[2], P[3]=a[3]^b[3],
       G[0]=a[0]&b[0], G[1]=a[1]&b[1], G[2]=a[2]&b[2], G[3]=a[3]&b[3]; 
endmodule

module stage1_4(ip,ig,p,g);
input[3:0] p,g;
output[1:0] ip,ig;
assign ip[0]=p[0]&p[1], ip[1]=p[2]&p[3],
       ig[0]=g[1]|(g[0]&p[1]), ig[1]=g[3]|(g[2]&p[3]);
endmodule

module stage2_4(ip,ig,p,g);
input[1:0] p,g;
output ip,ig;
assign ip=p[0]&p[1], ig=g[1]|(g[0]&p[1]);
endmodule


module stage3_4(ip,ig,P2,G2,p0,g0);
input  P2,G2,p0,g0;
output ip,ig;
assign ip=P2&p0, ig=G2|(g0&P2);
endmodule

module carry_4(C,cout,cin,ip,ig,P0,G0);
input cin,P0,G0; input[3:0] ip,ig;
output[2:0] C; output cout;
assign C[0]=G0|(P0&cin), C[1]=ig[0]|(ip[0]&cin), C[2]=ig[2]|(ip[2]&cin),cout=ig[3]|(ip[3]&cin);
endmodule


module sum_4(s,C,cin,P);
input[2:0] C; input[3:0] P; input cin;
output[3:0] s;
assign s[0]=P[0]^cin, s[1]=P[1]^C[0], s[2]=P[2]^C[1], s[3]=P[3]^C[2];
endmodule

// 2bit CLA 
module CLA2(a,b,ci,s);
input [1:0]a,b;
input ci;
output [2:0]s;
wire [1:0] G,P,C;
    assign G = a & b; //Generate
    assign P = a ^ b; //Propagate
    assign C[0] = ci;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign s[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign s[1:0] = P ^ C;
endmodule 

//Half adder
module ha(a,b,s,co);
input a,b;
output s,co;
xor x1(s,a,b);
and a1(co,a,b);
endmodule 
