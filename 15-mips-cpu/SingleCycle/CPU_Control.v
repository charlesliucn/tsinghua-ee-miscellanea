/***单周期处理器 控制单元***/
module CPU_Control(Instruct,PC_sv,JT,Imm16,Shamt,Rd,Rt,Rs,PCSrc,RegDst,
  RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp,IRQ);
  
  input [31:0] Instruct;
  input PC_sv;
  output [25:0] JT;
  output [15:0] Imm16;
  output [4:0] Shamt,Rd,Rt,Rs;
  output [2:0] PCSrc;
  output [1:0] RegDst,MemToReg;
  output [5:0] ALUFun;
  output RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
  input IRQ;  //中断请求
  
  wire  [5:0] Opcode, Funct;  //操作码和功能码
  wire R,I,J,JR,nop;          //指令的种类，R型(JR表示R型中的跳转指令)，J型，I型或者空指令
  wire branch_con,branch_slt; //条件分支指令和slt比较指令
  wire normal;               //表示指令为正常指令，未发生异常
  wire ILLOP,XADR;            //是否发生中断(ILLOP)或者异常(XADR)

/*--------------------------------------------------------------------------*/
  
  assign Opcode=Instruct[31:26];//指令操作码
  assign Funct=Instruct[5:0];   //指令功能码；用于区分R型指令功能
  
  assign JT=Instruct[25:0];     //target J型指令使用
  assign Imm16=Instruct[15:0];  //立即数 I型指令使用
  assign Shamt=Instruct[10:6];  //移位量R型指令使用
  assign Rd=Instruct[15:11];    //R型指令使用
  assign Rt=Instruct[20:16];    //R型和I型指令使用
  assign Rs=Instruct[25:21];    //R型和I型指令使用
 
  /*R型指令包括add,addu,sub,subu,and,or,xor,nor,sll,srl,sra,jr,jalr，这些指令R取1*/ 
  assign R= ~nop&(Opcode==6'b0)&
   			( (Instruct[10:3]==8'b00000100) |      //对应add,addu,sub,subu,and,or,xor,nor 指令
				(Instruct[10:0]==11'b00000101010) |  //对应slt指令
				((Instruct[25:21] == 5'd0)&(Instruct[5:2]==4'd0)&(Instruct[1:0]!=2'b01))| //对应sll,srl,sra移位指令
				({Instruct[20:11],Instruct[5:1]}==15'b000000000000100) |               //对应jr指令
				({Instruct[20:16],Instruct[5:0]}==11'b00000001001)                     //对应jalr指令
			);    
	
	/*I型指令包括addi,addiu,andi,slti,sltiu,lui,lw,sw,beq,bne,blez,bgtz,bltz，这些指令I取1*/
  assign I=
      ( ((Instruct[31:29]==3'b001)&((Instruct[28:26]==3'b100)|~Instruct[28]|(Instruct[28:21]==8'b11100000)))|  //对应指令addi,addiu,andi,slti,sltiu,lui
			  ((Instruct[31:30]==2'b10)&(Instruct[28:26]==3'b011))|  //对应lw,sw指令
			  ((Instruct[31:29]==3'b000)&((Instruct[28:27]==2'b10)|  //对应beq,bne指令
			  ((Instruct[20:16]==5'b00000)&((Instruct[28:27]==2'b11)|(Instruct[28:26]==3'b001)))))//对应blez,bgtz,bltz指令
		  );
		  
	/*J型指令*/
	assign J=(Instruct[31:27]==5'b00001);  //对应j,jal指令，这些指令J取1
	/*R型指令中的跳转指令*/	
	assign JR=R&(Instruct[5:1]==5'b00100); //包括jr, jalr两个指令
  /*空指令 nop (0x00000000,即sll $0,$0,0)*/
	assign nop=(Instruct==32'h0);  //空指令时nop取1
	
  assign branch_con=I&(Instruct[31:29]==3'b000);  //当指令为beq,bne,blez,bgtz,bltz条件分支指令时，branch_con=1
  assign branch_slt=(R&Instruct[3])|(I&~Instruct[31]
                  &(Instruct[28:27]==2'b01)); //当指令为比较指令slt,slti,sltiu时，branch_slt=1
  assign normal=R|I|J|nop;   //R、I、J和nop都是正常指令，其他指令该MIPS处理器不支持，因而当作异常处理
  assign ILLOP=~PC_sv&IRQ;     //监督位为0时，中断请求导致ILLOP=1
  assign XADR=~PC_sv&~normal;  //监督位为0时，指令异常导致XADR=1
 
/*-----------------------------------------------------------------------------*/
 
/*生成各控制信号*/
  //PCSrc
    /*在未出现中断的前提下，PCSc=001为条件分支指令，branch_con=1;
      PCSc=011为jr,jalr指令,JR=1;PCSc=101异常处理,XADR=1*/
    assign PCSrc[0]=(JR|branch_con|XADR)&~ILLOP;  
    /*在未出现中断的前提下，PCSrc=010跳转指令J=1或JR=1*/
    assign PCSrc[1]=(JR|J)&~ILLOP;
    /*PRSrc=100或101，即表示出现了中断或异常*/
    assign PCSrc[2]=XADR|ILLOP;
    
  //RegDst:
    /*指令正常的前提下，RegDst=01时，目的寄存器为Rt,对应I型指令;
      RegDst=11时，目的寄存器为Xp,即发生中断或异常时，返回地址保存到$26寄存器中*/
    assign RegDst[0]=I|~normal|XADR;//？
    /*指令正常的前提下，RegDst=10时，目的寄存器为$ra，即$31寄存器;
      RegDst=11时，目的寄存器为Xp,即发生中断或异常时，返回地址保存到$26寄存器中*/
    assign RegDst[1]=MemToReg[1]|~normal;//？
   
  //RegWr
  /*写寄存器堆控制指令，R型、Jr指令(写入31号寄存器)、jal指令、I型指令中的addi,addiu,andi,
    slti,sltiu,lui以及异常时将返回地址写入26号寄存器，这些指令都需要RegWr指令为1*/
    assign RegWr=(R&~(JR&~Funct[0]))|(I&~branch_con&~MemWr)|(J&Opcode[0])|XADR;
    
  //ALUSrc1
  /*ALUSrc1=1时,选择shamt[4:0],即为逻辑移位指令,sll,srl,sra的Funct[5:0]字段
    分别为000000、000010、000100。add、addu、and、sub、subu、or、nor、xor的Funct[5]全为1,
    jr、jalr的Funct[5]全为0，但Funct[3]全为1*/
    assign ALUSrc1=R&~Funct[5]&~Funct[3];  //sll,srl,sra
  
  //ALUSrc2
  /*ALUSrc2=1时，选择扩展后的立即数或偏移量，即为I型中除去分支指令的所有指令*/
    assign ALUSrc2=I&~branch_con; 
    
  //ALUFun
    /*ALUFun=[5:4]=00时,对应加减法指令;01对应逻辑运算指令;10时对应移位指令;11对应比较指令*/
    assign ALUFun[5]=(R&~Funct[5])|branch_con|branch_slt; //移位、比较和j指令               
    assign ALUFun[4]=(R&Funct[2])|branch_con|branch_slt|(Opcode[3:1]==3'b110); //逻辑指令和比较
    /*(R&(Funct[2:1]==2'b10))对应and和or;(branch_con&Opcode[1])对应blez,bgtz指令;
      (Opcode[3:1]==3'b110)对应andi指令*/
    assign ALUFun[3]=(R&(Funct[2:1]==2'b10))|(branch_con&Opcode[1])|(Opcode[3:1]==3'b110); //对应and,or,blez,bgtz,andi指令
    assign ALUFun[2]=(R&Funct[2]&(Funct[1]^Funct[0]))|((branch_con|branch_slt)&(Opcode[2:1]!=2'b10));//对应or,xor,bgtz,blez,bltz,slt,slti,sltiu指令
    assign ALUFun[1]=(R&Funct[2]&(Funct[1]^Funct[0]))|(R&Funct[0]&~Funct[5])|
                    (((Opcode[2:0]==3'b100)|(Opcode[2:0]==3'b111))&branch_con); //对应or,xor,sra,jalr,beq,bgtz指令
    assign ALUFun[0]=(R&Funct[1]&(~Funct[2]|Funct[0]))|branch_con|branch_slt; //对应sub,subi,nor,srl,sra,slt指令
  
  //Sign
    /*Sign决定ALU运算的性质，有符号运算或无符号运算。Sign=1时表示有符号运算
      包括R型指令的and,sub和I型指令的addi,slt*/                 
    assign Sign=(R&(Funct[5:2]==4'b1000)&~Funct[0])|(I&(Opcode[5:2]==4'b0010)&~Opcode[0]);
    
  //MemRd
    /*读存储器指令，只有lw指令*/
    assign MemRd=Opcode[5]&~Opcode[3]; //Opcode==6'b100011
    
  //MemWr
    /*写存储器指令，只有sw指令*/
    assign MemWr=Opcode[5]&Opcode[3];  //Opcode==6'b101011
  
  //MemToReg
    /*选择写入寄存器的数据的来源。MemToReg=00时，选择ALU的运算结果;
      MemToReg=01时，选择从存储器读取的结果，即lw指令;MemToReg=10时，选择PC+4*/
    assign MemToReg[0]=MemRd;  
    assign MemToReg[1]=(J&Opcode[0])|(JR&Funct[0])|XADR; /*对应指令jal、jalr指令及异常*/
    
  //EXTOp
    /*EXTOp，根据指令产生16位立即数的32位扩展，无符号扩展和有符号扩展。
      EXTOp=1时为有符号扩展*/
    assign EXTOp=Sign;
    
  //LUOp
    /*根据指令lui，将16位立即数装入32位数的高16位。*/
    assign LUOp=(Opcode[3:1]==3'b111); //lui
endmodule
