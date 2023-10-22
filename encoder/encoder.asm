.data 
currentDigram:    .space 100
encodedMessageBuffer: .float 1024

.text

.globl encondedMessage
      
# Funcion para codificar un mensaje
encondedMessage:
	move $t0, $a0		# Param1: Buffer que contiene el mensaje a codificar
	move $t1, $s0 		
	# Registros
	# $s0 Diccionario original
	# $s1 Mensaje original
	# $s2 Tamano del diccionario
	# $s3 Buffer que contiene el mensaje codificado
	# $t0 Mensaje temporal
	# $t1 Diccionario temporal
	# $t2 Contador
	# $t3 Primer caracter mensaje
	# $t4 Segundo caracter mensaje
	# $t5 Primer caracter diccionario
	# $t6 Segundo caracter diccionario
	# $t7 Bandera, digrama encontrado
	# $t8 Determina si se buscara un digrama o solo un caracter en el diccionario
	li $t2, 1
	la $s3, encodedMessageBuffer
	loop_main:
	 		lb $t3, ($t0)  	   # Primer caracter mensaje
	 		#lb $t4, ($t0)      # Segundo caracter mensaje
    		addi $t0, $t0, 1
    		lb $t4, ($t0)      # Segundo caracter mensaje
    		
			beq $t3, 0xD, if_carriage_return
            j if_carriage_return_end
            	if_carriage_return:
            		li $t2, 13
            		
            		sw $t2, ($s3)  # Almacenar el valor de $t2 en la ubicación actual de $s3
    				addiu $s3, $s3, 4
    				
            		addi $t0, $t0, 1   # avanza una posicion puntero mensaje[i + 1]
            		j reset_values
            		j if_carriage_return_end
            if_carriage_return_end:
            
            beq $t4, 0xA, if_line_feed
            j if_line_feed_end 
            	if_line_feed:
            		li $t2, 10
            		
            		sw $t2, ($s3)  # Almacenar el valor de $t2 en la ubicación actual de $s3
    				addiu $s3, $s3, 4
            		
            		#addi $t0, $t0, 1   # avanza una posicion puntero mensaje[i + 1]
            		#lb $t4, ($t0)
            		
            		j reset_values
            		j loop_main
            if_line_feed_end:
            
           
           
             
            
            
            # Valida el fin del mensaje
            beq $t3, $zero, if_first_char_equal_end_line
            j loop_child
            if_first_char_equal_end_line:
            	beq $t4, $zero, if_second_char_equal_end_line
            	j loop_child
            		if_second_char_equal_end_line:
            			j end_loop_main
            		
			loop_child:    	
        		lb $t5, ($t1)      # Primer caracter diccionario
        		addi $t1, $t1, 1   # avanza una posicion puntero diccionario[i + 1]
    			lb $t6, ($t1)      # Segundo caracter diccionario
        		
        		beq $t3, $t5, if_second_character_equal
				j loop_child_continue
    			if_second_character_equal:
    				beq $t4, 0xD, go_if_digram_found
    				j continue_pair_digram_found
    				continue_pair_digram_found:
    				beq $t4, $t6, pair_digram_found
    				j go_if_digram_found
    				go_if_digram_found:
    				beq $t8, 1, digram_found
					j loop_child_continue
				digram_found:
					li $t7, 1        # establecer bandera en verdadero
					j end_loop_child
				pair_digram_found:
					li $t7, 1        # establecer bandera en verdadero
					addi $t0, $t0, 1
					lb $t3, ($t0)
					#subi $t0, $t0, 1
					j end_loop_child	
				loop_child_continue:
					beq $t6, 0xD, if_value_equal_CR # Valida que el caracter siguiente sea carriage_return
					bne $t5, 0xA, if_not_equal_LF   # Valida que el caracter no sea LF
					if_value_equal_CR:
    					addiu $t1, $t1, 2	   # Avanza 2 posiciones para ignorar caracteres CR y LF
    					j end_if_CR_LF
    				if_not_equal_LF:
    					bne $t6, 0xD, skip_characters
    					skip_characters:
    						addiu $t1, $t1, 3	# Avanza 3 posiciones para ignorar caracter actual CR y LF
    					j end_if_CR_LF
    				end_if_CR_LF:
					addi $t2, $t2, 1 # aumentar contador
					ble $t2, $s2, loop_child # validar si contador < tamano diccionario	
					j end_loop_child 
    		end_loop_child:
    		
    		beq $t7, $zero, digram_not_found
    		j continue_main_loop
    		
    		digram_not_found: 
 			jal reset_values
    		li $t8, 1 			# Buscar nuevamente pero esta vez solo comparar $t3 con $t5
    		j loop_child
    		continue_main_loop:
    		
			li $v0, 1               
    		move $a0, $t2
    		syscall
    		
    		
    		sw $t2, ($s3)  # Almacenar el valor de $t2 en la ubicación actual de $s3
    		addiu $s3, $s3, 4
    		
    		#### Reiniciar valores ####
    		jal reset_values
    		#### Reiniciar valores ####
			beqz $t4, end_loop_main    			     
          	j loop_main           	# Volver al inicio del bucle principal
    end_loop_main:
    li $t2, -1
    sb $t2, ($s3)   # Almacena un -1 al final, para indicar que alli finaliza el mensaje
    la $s3, encodedMessageBuffer # Reiniciar el puntero
    
    # Retorna: $s3 buffer con mensaje codificado
    jal returnToMain

#### Reiniciar valores ####
reset_values:
	move $t1, $s0
	li $t2, 1	# Contador
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    jr $ra
