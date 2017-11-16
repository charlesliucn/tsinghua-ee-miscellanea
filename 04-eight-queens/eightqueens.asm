     .data 
str1:
     .asciiz "Use assembler language to solve the Eight Queens Problem\n"
str2:
     .asciiz "The number of the solutions is:\n"
     .text  
 
#main主函数
main:  
	li      $v0,4            #系统调用syscall的代码4，print string打印字符串
	la      $a0,str1    	 #将strl的地址装入print string的默认寄存器$a0中
	syscall			 #打印字符串str1
	
	addi    $sp,$sp,-32      #将栈指针从高地址移到地址，得到8位数组的空间    
	addi    $s0,$sp,0        #$s0指向数组的基址loc[0]  
	#$a0到$a1=2都是EightQueens函数中用的变量
	li 	$a0,0    	 #$a0表示n，n为中间变量，放置的第n个皇后，给$a0赋值为0     
	li   	$a1,8  	 	 #&a1表示Qn，Qn为皇后的数量，在八皇后问题中，Qn=8，给$a1赋值为8
	li	$a2,0        	 #$a2表示num，num是EightQueens函数中记录解的总数的计数器，初始化为0
	jal     EightQueens       #调用EightQueens函数,求得八皇后问题解的个数，返回值保存在$v0中
	move    $a1,$v0        	 #将EightQueens函数的返回值$v0存入赋给$a0 
	
	li      $v0,4            #系统调用syscall的代码4，print string打印字符串
	la      $a0,str2    	 #将str2的地址装入print string的默认寄存器$a0中
	syscall
	move	$a0,$a1		#将$a1中的数值（八皇后问题的解的个数）装入print string的默认寄存器$a0中
	li      $v0,1          	#系统调用syscall的代码1，print integer打印参数$a0中的数字  
	syscall 
	li      $v0,10          #系统调用syscall的代码10，退出程序   
	syscall

#Judge_Chaos函数，用于判断放置第n个皇后时是否会与已放入的皇后发生冲突
Judge_Chaos: 
	li	$t4,0     		#j=0,$t4用于保存循环时的参量j   
LOOP2:  
	slt  	$t0,$t4,$a0     	#当j比n小时，$t0=1 
	beq   	$t0,$zero,Return1  	#当$t0=0,即j>=n时，跳转到Return1,返回值为1，表示没有与第n个皇后冲突的项；$t0=1时，继续执行下一步
	#寻址，对小于n的每个i都与n比较
	sll   	$t1,$a0,2        	#将$a0即n进行两位逻辑左移，移位后存入$t1中，即$t1=n*4   
	add   	$s1,$s0,$t1      	#$s0指向loc数组的基址，因而现在得到loc[n]     
	sll   	$t2,$t4,2       	#将$t4即j进行两位逻辑左移，移位后存入$t2中，即$t2=j*4
  	add   	$t3,$s0,$t2      	#$s0指向loc数组的基址，因而现在得到loc[j]  
	lw    	$t6,0($s1)       	#从地址中得到数值，$t6=loc[n]    
	lw    	$t7,0($t3)       	#从地址中得到数值，$t7=loc[j] 
	sub  	$t0,$t7,$t6      	#减法运算$t0=(loc[j]-loc[n]) 		
	abs   	$t0,$t0          	#$t0=(abs(loc[j]-loc[n]))    
	sub   	$t5,$a0,$t4      	#$t1=(n-j) 
	seq   	$t2,$t0,$t5      	#如果abs(loc[j]-loc[n])=(n-j)，则$t2=1
	bne   	$t2,$zero,Return0	#$t2等于1即abs(loc[j]-loc[n])=(n-j)时跳转到Return0，否则执行下一指令
	beq   	$t6,$t7,Return0    	#loc[n]=loc[j]时跳转到Return0,否则执行下一指令    
	addi  	$t4,$t4,1        	#如果没有跳出循环，则j+1后继续循环    
	j     	LOOP2            	#继续循环 
Return0: 
	li	$v1,0       		#Judge_Chaos函数的返回值为0，$v1=0 
 	jr   	$ra			#跳转到寄存器指定的地址
Return1: 
	li	$v1,1			#Judge_Chaos函数的返回值为1，$v1=1     
	jr   	$ra 			#跳转到寄存器指定的地址
	
#EightQueens函数
EightQueens: 
	addi  	$sp,$sp,-24      	#移动栈指针，开辟6位数字空间    
	sw   	$ra,20($sp)     	#EightQueens函数返回地址$ra入栈   
	sw   	$v0,16($sp)     	#八皇后解的总数返回值$v0入栈   
	sw    	$a0,12($sp)     	#$a0入栈    
	sw  	$a2,8($sp)       	#$a2入栈   
	sw   	$s1,4($sp)      	#$s1入栈
	#递归的方法求解八皇后问题       
	bne   	$a0,$a1,Recursion    	#n不等于Qn时跳到递归函数Recursion大板块；n等于Qn时，表示已经将所有的8个皇后全部无冲突放置完毕，继续执行下一指令   
	addi  	$a2,$a2,1       	#解法数目num=num+1，
	sw    	$a2,8($sp)     		#将新得的num再存入$a2  
 	jal     Return         		#直接跳到Return，得到返回值
Recursion:      
	li    	$s2,1     		#给$s2赋初值1 
	sw    	$s2,0($sp)      	#$s2=i值入栈
	jal	LOOP1			#跳转到LOOP1进行递归求解
LOOP1: 
	lw    	$a0,12($sp)      	#读栈中n值，存入$a0    
	sle   	$t0,$s2,$a1      	#若i<=Qn时，令$t0=1 
	beq  	$t0,$zero,Return  	#当$t0=0即i>Qn时，跳转到Return;否则继续执行下一指令
	#实现loc[n]=i
	sll   	$t1,$a0,2        	#将n进行两位逻辑左移，移位后存入$t1中，即$t1=n*4   
	add  	$s1,$s0,$t1      	#将数组基址从loc[0]增加至loc[n]，
	sw   	$s2,0($s1)       	#将loc[n]保存到i中
	jal   	Judge_Chaos           	#调用函数Judge_Chaos(n),判断放入第n个皇后时候会发生冲突，返回值存入$v1 
	beq  	$v1,$0,EXIT     	#若返回值$v1=0，则说明发生冲突，不能放入第n个皇后，跳转到EXIT；可以放入第n个皇后，继续执行下一指令    
	addi  	$a0,$a0,1        	#放入第n个皇后之后，继续放入第n+1个
	jal   	EightQueens      	#递归调用EightQueens函数，直到能够返回结果
	move  	$a2,$v0   		#将解的数目num赋给$a2    
	sw    	$a2,8($sp)       	#将$a2压入栈中 
		
EXIT:  #如果当前放入的皇后无法放置（发生冲突）时，返回上一皇后重新放置
	lw   	$s2,0($sp)       	#从栈中读取保存的i值存入$s2中    
	addi  	$s2,$s2,1        	#将i加1，尝试下一位置
	sw   	$s2,0($sp)       	#同时将栈中的i也更新   
	jal     LOOP1            	#重新进入LOOP1，继续尝试
	
Return: 
	lw    	$ra,20($sp)      	#$ra出栈
	addi  	$sp,$sp,24       	#栈指针恢复 
	move  	$v0,$a2          	#将EightQueens函数的返回值方法总数num存入$v0 
	jr    	$ra              	#跳转到跳转寄存器指向的地址
