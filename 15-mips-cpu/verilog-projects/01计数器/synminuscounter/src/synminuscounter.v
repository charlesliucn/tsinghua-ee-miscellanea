module synminuscounter(leds,ano,btnd,reset,clk);
output [6:0]leds;
output [3:0]ano;
input btnd,reset,clk;
reg [3:0]Q;
wire BTND;

debounce d(clk,btnd,BTND);
assign ano=4'b0000;

always @(posedge BTND or posedge reset)
  begin
    if(reset) 
    begin 
      Q[0]<=1;
      Q[1]<=1;
      Q[2]<=1;
      Q[3]<=1; 
    end 
    else 
      begin
      Q[0]<=~Q[0];
      if(~Q[0]) 
      begin
        Q[1]<=~Q[1];
        if(~Q[1]) 
        begin
          Q[2]<=~Q[2];
          if(~Q[2]) 
          begin
            Q[3]<=~Q[3];
          end
        end
      end
    end
  end

BCD7 bcd7(Q,leds);
endmodule
