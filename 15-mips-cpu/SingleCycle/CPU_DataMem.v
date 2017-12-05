/*单周期处理器  数据存储器单元*/
module CPU_DataMem(clk,reset,Addr,WriteData,MemRd,MemWr,ReadData);
  input clk,reset,MemRd,MemWr;	//读写控制信号
  input [31:0] Addr,WriteData;	//地址和要写入的数据
  output [31:0] ReadData;		//从数据存储器中读取的数据

  parameter RAM_SIZE = 256;		//数据存储器大小
  //(* ram_style = "distributed" *)
  reg [31:0] RAMDATA [RAM_SIZE-1:0];
  //读数据
  assign ReadData=(MemRd&&(Addr<RAM_SIZE)) ? RAMDATA[Addr[31:2]] : 32'b0;
  //写数据
  always@(posedge clk) 
  begin
		  if((Addr[31:2]<RAM_SIZE)&&MemWr) 
		    RAMDATA[Addr[31:2]]<=WriteData;
  end
endmodule