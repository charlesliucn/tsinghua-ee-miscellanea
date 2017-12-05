module Pipeline_Hazard(IDEXRead,IDEXRt,IFIDRs,IFIDRt,Stall);
 input IDEXRead;
 input[4:0] IDEXRt,IFIDRs,IFIDRt;
 output reg Stall;
 always @(*)
 begin
   if(IDEXRead&((IDEXRt==IFIDRs)|(IDEXRt==IFIDRt)))
     Stall<=1'b1;
   else
     Stall<=1'b0;
   end
 endmodule