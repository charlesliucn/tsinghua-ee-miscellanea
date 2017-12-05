module asynaddcounter(leds,ano,btnd,reset,clk);
output [6:0]leds;//??LED???
output [3:0]ano;//??4?LED????
input btnd,reset,clk;//btnd???
reg [3:0]Q;
wire BTND;//????????

debounce d(clk,btnd,BTND);//??????
assign ano=4'b0000;//??LED??

always @(posedge BTND or posedge reset)
  begin 
    if(reset)
      Q[0]<=0;
    else Q[0]=~Q[0]; 
  end 
//??????????????1??0???????  
always @(negedge Q[0] or posedge reset)
  begin 
    if(reset)
    Q[1]<=0;
    else Q[1]=~Q[1]; 
  end
always @(negedge Q[1] or posedge reset)
  begin 
    if(reset)
    Q[2]<=0;
    else Q[2]=~Q[2]; 
  end
always @(negedge Q[2] or posedge reset)
  begin 
    if(reset)
    Q[3]<=0;
    else Q[3]=~Q[3]; 
  end
BCD7 bcd7(Q,leds);
endmodule
