`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Design Name: 
// Module Name: V8_BKA_tb
// Project Name:  
//////////////////////////////////////////////////////////////////////////////////


module V8_BKA_tb();
reg [7:0]a,b;
wire [15:0]q;
V8_BKA DUT(a,b,q);
initial
begin 
repeat(5)
begin
#50
{a,b}= $random ;
end
#50 $finish;
end
initial
$monitor($time,"a=%b,b=%b,q=%b",a,b,q);
endmodule
