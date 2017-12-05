module Pipeline_Forward(EXMEMWr,MEMWBWr,EXMEMRd,MEMWBRd,IDEXRs,IDEXRt,forwardA,forwardB);
  input EXMEMWr;
  input MEMWBWr;
  input[4:0] EXMEMRd;
  input[4:0] MEMWBRd;
  input[4:0] IDEXRs;
  input[4:0] IDEXRt; 
  output reg[1:0] forwardA;
  output reg[1:0] forwardB;
  
  always @(*)
  begin
    if((EXMEMWr)&(|EXMEMRd)&(EXMEMRd==IDEXRs))
      forwardA<=2'b10;
    else
      if((MEMWBWr)&(|MEMWBRd)&(MEMWBRd==IDEXRs))
        forwardA<=2'b01;
      else
        forwardA<=2'b0;
      end
  always @(*)
  begin
  if((EXMEMWr)&(|EXMEMRd)&(EXMEMRd==IDEXRt))
      forwardB<=2'b10;
    else
      if((MEMWBWr)&(|MEMWBRd)&(MEMWBRd==IDEXRt))
        forwardB<=2'b01;
      else
        forwardB<=2'b0;   
  end
endmodule