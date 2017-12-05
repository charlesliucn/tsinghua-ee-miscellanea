module test(testmode,sysclk,modecontrol,highfreq,Cathodes,AN);
  input [1:0] testmode;
  input sysclk,modecontrol;
  output [3:0] AN;
  output highfreq;
  output [7:0] Cathodes;
  wire sigin;
  signalinput signalin(testmode,sysclk,sigin);
  frequency freq(sigin,sysclk,modecontrol,highfreq,Cathodes,AN);
endmodule