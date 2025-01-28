main:            
        lw   $a0, 0($a1)          
        jal  stoi  
        add $a0,$v0,$0
        jal hash_fn
        lui $t3 , 0x1001
	sw  $v0 ,0($t3)wawa
	add $s0 , $0 , $v0
        j exitprog

hash_fn: 
 	addi $sp, $sp, -12       
        sw   $ra, 0($sp)
        sw   $s0, 4($sp)
        sw   $s1, 8($sp)
        addi $s0,$0,0x53 
        
        add $s1,$a0,$0			#input number  #s1 = input
	
			# bits 31-24
	srl $t0,$s1,24
	andi $t0, $t0, 0xFF        # last 8 bits only
			# XOR with current hash
	xor $t1,$t0,$s0	
			# Apply Func
	add $a0,$t1,$0
	jal get_poly
			# Update hash
	add $s0 ,$v0,$0
	andi $s0,0xff
	
			#  bits 23-16
	srl $t0,$s1,16
	andi $t0, $t0, 0xFF
			# XOR with current hash
	xor $t1,$t0,$s0
			# Apply Func
	add $a0,$t1,$0
	jal get_poly
			# Update hash
	add $s0 ,$v0,$0
	andi $s0,0xff
	
			# bits 15-8
	srl $t0,$s1,8
	andi $t0, $t0, 0xFF
			# XOR with current hash
	xor $t1,$t0,$s0
			# Apply Func
	add $a0,$t1,$0
	jal get_poly
			# Update hash
	add $s0,$v0,$0
	andi $s0,0xff 
	
			# bits 7-0
	andi $t0, $s1, 0xFF
			# XOR with current hash
	xor $t1,$t0,$s0
			# Apply Func
	add $a0,$t1,$0
	jal get_poly
			# Update hash
	add $s0,$v0,$0
	andi $s0,0xff
	add $v0,$0,$s0
	

        lw  $ra, 0($sp)
        lw  $s0, 4($sp)
        lw  $s1, 8($sp)
        addi $sp, $sp, 12 
        jr $ra   
	
get_poly:
	# X is passed in a0
	addi $sp ,$sp,-20
	sw $ra,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	sw $s4,12($sp)
	sw $s6,16($sp)
	
	andi $a0,0xff
	add $s1,$0,$a0	#s1 =x
	add $s6 , $0 , $a0
	
	add $a1,$0,$a0  #a1 = x = a0
	jal multiply
	add $s4,$0,$v0 #v0 return with X^2  s4 = x^2
			
	add $a0 , $0, $s6		#a0 =x
	add $a1 ,$0 , $s4		#a1 =x^2
	jal multiply
			#return with v0 = x^3
	addi $a0,$0,766
	andi $v0,0xff
	add $a1,$0,$v0
	jal multiply
			#return with v0 = 766x^3
	sub $s2,$0,$v0
	
	addi $a0 , $0 , 80
	add $a1,$s4,$0
	jal  multiply
			#return with 80x^2
	add  $s2, $s2, $v0
	addi $a0, $zero, 16
	add  $a1, $zero, $s1
	jal  multiply
			#return with 16x
	add  $v0, $s2, $v0
	addi $v0, $v0, 135 # +135 to all the above
	
	lw  $ra, 0($sp)
	lw  $s1, 4($sp)
	lw $s2,8($sp)
	lw $s4,12($sp)
	lw $s6,16($sp)
	addi $sp, $sp, 20
	jr   $ra
	
multiply: #a0 counter #a1  result of XOR (X)
	  slt  $t5, $a0, $zero
	  add $v0 , $0 ,$0
	  beq  $t5, $zero, initialize 
	  sub  $a0, $0,$a0
	  sub  $a1, $0 ,$a1	
	
initialize:
	add $t4 , $a0 ,$0
loop2:
	beq $t4 , $0 , return2	
	add $v0 ,$v0, $a1
	addi $t4 ,$t4 ,-1
	j loop2
return2:
	jr $ra
	  																																																						
stoi:
        addi $sp, $sp, -4       
        sw   $ra, 0($sp)       

        addi   $v0,$0, 0             
        add $t1,$0, $a0             
	addi $t6,$0,45
	addi $t7,$0,0
loop:
        lb   $t2, 0($t1)    # first char "1" "11"      
        beq  $t2, $zero, return  
        beq  $t2,$t6,negative
        addi $t2, $t2, -48      
       						
        add $t3,$0, $v0      
        sll  $t4, $t3, 3 
        sll  $t5, $t3, 1     
        add  $v0, $t4, $t5    
        add  $v0, $v0, $t2        
        addi $t1, $t1, 1      
        j    loop            
negative:
	addi $t1,$t1,1
	addi $t7,$0,1
	j loop
return:
	beq $t7,$0,L
	sub $v0,$0,$v0
L:	
        lw   $ra, 0($sp)         
        addi $sp, $sp, 4         
        jr   $ra   
        
          
exitprog:           
