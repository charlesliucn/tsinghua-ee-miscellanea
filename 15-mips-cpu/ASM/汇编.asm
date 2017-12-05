j initial
j Interrupt
jr $k0


initial:
addiu $s4, $zero, 3
lui   $s0, 16384
sw    $s4, 8($s0)
addiu $a0,$zero,192
sw $a0,0($zero)
addiu $a0, $zero,249
sw $a0,4($zero)
addiu $a0, $zero,164
sw $a0,8($zero)
addiu $a0, $zero,176
sw $a0,12($zero)
addiu $a0, $zero,153
sw $a0,16($zero)
addiu $a0, $zero,146
sw $a0,20($zero)
addiu $a0, $zero,130
sw $a0,24($zero)
addiu $a0, $zero, 248
sw $a0,28($zero)
addiu $a0, $zero, 128
sw $a0, 32($zero)
addiu $a0, $zero, 144
sw $a0, 36($zero)
addiu $a0, $zero, 136
sw $a0, 40($zero)
addiu $a0, $zero, 131
sw $a0, 44($zero)
addiu $a0, $zero, 198
sw $a0, 48$($zero)
addiu $a0, $zero, 161
sw $a0, 52($zero)
addiu $a0, $zero, 134
sw $a0, 56($zero)
addiu $a0, $zero, 142
sw $a0, 60($zero)
addiu $v0, $zero, 1    
  
  
pre:
lw $s1, 28($s0)        
add  $a1, $s1, $zero
lw   $s2, 28($s0)        
add  $a2, $s2, $zero
beq  $a1, $zero, caseC   
beq  $a2, $zero, caseD   


Loop1:
beq  $a1, $a2, caseD
slt  $a0, $a1, $a2
bne  $a0, $zero, caseB


caseA:
sub $a1,$a1,$a2    
j Loop1


caseB:
sub  $a2, $a2, $a1      
j Loop1


caseC:
add $v1, $a2, $zero
j AN 
 
 
caseD:
add $v1,$a1,$zero


AN:
srl  $t0, $v0, 1        	 
beq $t0, $zero, num1     
srl $t0, $v0, 2 
beq $t0, $zero, num2   
srl $t0, $v0, 3 		 
beq $t0, $zero, num3 
addiu $v0, $zero, 1
andi $s3, $s1, 15		 
sll  $s3, $s3, 2
j Output


num1:
srl  $s3, $s1, 4  
sll $s3, $s3, 2 
j shift 


num2:
andi $s3, $s2,15		 
sll $s3, $s3, 2
j shift

num3:
srl  $s3, $s2,4 
sll $s3, $s3, 2 
j shift


shift:
sll $v0, $v0,1


Output:
j Output
j pre


Interrupt:
sw   $s4, 8($s0)
lw   $s5, 0($s3)
sll  $s6, $v0, 8
add  $s6, $s5, $s6
sw   $s6, 20($s0)
sw   $v1, 12($s0)
sw   $v1, 24($s0)
jr   $ra