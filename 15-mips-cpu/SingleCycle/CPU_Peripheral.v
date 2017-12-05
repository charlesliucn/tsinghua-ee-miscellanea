/*单周期处理器 定时器、led、七段数码管、switch外设模块*/
module CPU_Peripheral(clk,reset,Addr,WriteData,MemRd,MemWr,ReadData,led,AN,digital,switch,irqout);
  input clk,reset,MemRd,MemWr;	//读写控制信号
  input [7:0] switch;			//switch外设输入
  input [31:0] Addr,WriteData;	//地址和写入数据
  output reg [31:0] ReadData;	//读取数据
  output reg [3:0] AN;			//控制4个数字的亮暗
  output reg [7:0] digital,led;	//数码管和led灯
  output irqout;
	
	reg [31:0] TH,TL;		//TH和TL定时器
    reg [2:0] TCON;			//TCON定时器控制信号
	assign irqout=TCON[2]; 	//TCON最高位为1时中断
		
	initial 
	begin//初始化
		TH<=32'hfffff800;	//起始的基数
		TL<=32'hfffff800;	//
		TCON<=3'b0;			//控制信号初始为0
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
		  if(TCON[0]) //定时器使能信号为1
		  begin
			   if(TL==32'hffffffff) //从32'hfffff800到32'hffffffff
			   begin
				    TL <= TH;		//当TL全为1时，TL重新从基数开始计数
				    if(TCON[1]) 
						TCON[2]<=1; //产生中断信号  由此中断用于产生扫描频率（具体实现见MIPS汇编）
			   end
			   else TL <= TL + 1;	
		  end
	
		  if(MemWr) 	//写入数据
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
    if(MemRd)	//从外设部分读取数据
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
