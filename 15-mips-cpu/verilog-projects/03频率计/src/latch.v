module latch(deci_th,deci_hun,deci_ten,deci,latchout_th,latchout_hun,latchout_ten,latchout1,lock); 
  input [3:0] deci_th,deci_hun,deci_ten,deci;
  input lock; 
  output reg [3:0] latchout_th,latchout_hun,latchout_ten,latchout1;
  always @(posedge lock) 
    begin 
    if(lock) //lock???????????????????
      latchout_th<=deci_th;
      latchout_hun<=deci_hun; 
      latchout_ten<=deci_ten; 
      latchout1<=deci;  
    end 
endmodule