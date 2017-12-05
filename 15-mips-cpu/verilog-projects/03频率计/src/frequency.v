module frequency(sigin,sysclk,modecontrol,highfreq,Cathodes,AN); 
  input sigin,sysclk,modecontrol; 
  output highfreq;
  output [7:0] Cathodes;
  output [3:0] AN;
  assign highfreq= modecontrol;
  wire sig_10,signal;
  wire clk_ctrl,clk_scan;
  wire reset,enable,lock; 
  wire [3:0] deci_th,deci_hun,deci_ten,deci;
  wire [3:0] latchout_th,latchout_hun,latchout_ten,latchout1;

 
  gen_clk gc(sysclk,clk_ctrl,clk_scan);
  control ctrl(clk_ctrl,enable,reset,lock);
  spanmode sm(modecontrol,sigin,sig_10); 
  assign signal= modecontrol?sig_10:sigin; 
  counter ct(enable,reset,signal,deci_th,deci_hun,deci_ten,deci);
  latch lt(deci_th,deci_hun,deci_ten,deci,latchout_th,latchout_hun,latchout_ten,latchout1,lock); 
  decoder dc(latchout_th,latchout_hun,latchout_ten,latchout1,clk_scan,Cathodes,AN);
endmodule

