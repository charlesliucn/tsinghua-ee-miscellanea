module seqdetector_FSM_CT(clk_in,system_clk,x,reset,z,Q);
 input clk_in,system_clk,x,reset;
 output z;
 output reg [3:1]Q;
 wire [3:1]D;
 wire clk_o;
 
 debounce d(system_clk,clk_in,clk_o);
 
 assign D[3]=(Q[3]&~Q[1]&x|Q[3]&Q[1]&~x|Q[2]&Q[1]&~x);
 assign D[2]=(Q[2]&~Q[1]&x|~Q[3]&~Q[2]&Q[1]&~x);
 assign D[1]=x;
 assign z=(Q[3]&~Q[2]&Q[1]&x);
 
 always@(posedge clk_o or negedge reset)
 begin 
 if(reset)
  Q<=0;
 else 
  Q<=D;
 end
endmodule
