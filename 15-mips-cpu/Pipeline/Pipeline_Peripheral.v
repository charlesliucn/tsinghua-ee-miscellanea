module Pipeline_Peripheral(clk,reset,Addr,WriteData,MemRd,MemWr,ReadData,led,AN,digital,switch,irqout);
  input clk,reset,MemRd,MemWr;
  input [7:0] switch;
  input [31:0] Addr,WriteData;
  output reg [31:0] ReadData;
  output reg [3:0] AN;
  output reg [7:0] digital,led;
  output irqout;
	
	reg [31:0] TH,TL;
    reg [2:0] TCON;
	assign irqout=TCON[2]; 
		
	initial 
	 begin
	  TH<=32'hfffff800;
    TL<=32'hfffff800;
    TCON<=3'b0;
	  led<=8'b0;
	  AN<=4'b1111;
	  digital<=8'b11111111;
	  ReadData<=32'b0;
	 end

   
  always@(negedge reset or posedge clk)
  begin
		if(reset)
		begin
		  TH<=32'hfffff800;
		  TL<=32'hfffff800;
		  TCON<=3'b0;
		end 
		else 
		begin
		  if(TCON[0]) 
		  begin
			   if(TL==32'hffffffff) 
			   begin
				    TL <= TH;
				    if(TCON[1]) 
						TCON[2]<=1;
			   end
			   else TL <= TL + 1;
		  end
	
		  if(MemWr) 
		  begin
			 case(Addr)
				  32'h40000000: TH <= WriteData;
				  32'h40000004: TL <= WriteData;
				  32'h40000008: TCON <= WriteData[2:0];		
				  32'h4000000C: led <= WriteData[7:0];			
				  32'h40000014: begin AN<=~WriteData[11:8];digital<=WriteData[7:0]; end
				  default: ;
			 endcase
	   end
	 end
  end	

  always @(*)
  begin
    if(MemRd)
    begin
      case(Addr)
        32'h40000000: ReadData<= TH;			
	      32'h40000004: ReadData<= TL;			
		    32'h40000008: ReadData<= {29'b0,TCON};				
		    32'h4000000C: ReadData<= {24'b0,led};			
		    32'h40000010: ReadData<= {24'b0,switch};
		    32'h40000014: ReadData<= {20'b0,~AN,digital};
       default: ReadData<=32'b0;
      endcase
    end
    else ReadData<=32'b0;
  end

endmodule

