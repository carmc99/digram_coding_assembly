.data 
decodedMessageBuffer: .space 4096 

.text

.globl decodedMessage
      
# Funcion para decodificar un mensaje
decodedMessage:
	move $t9, $s0		# Diccionario temporal
	move $t8, $a0		# Param1: Buffer que contiene el mensaje a decodificar 		
	# Registros
	# $s0 Diccionario original
	# $s1 Mensaje original
	# $s4 Buffer que contiene el mensaje decodificado
	# $t9 Diccionar temporal
	# $t8 Mensaje temporal
	# $s2 Contador
	# $t2 Posicion del digrama


	la $s4, decodedMessageBuffer
			
	# Loop mensaje
	loop_main:
			li $s2, 1		   # index = 0   
            la $t2, ($t8)  	   # message[i]	
     		move   $a0, $t2    # Cargar la dirección de la cadena en $a0
     		jal  atoi		   # Convertir Ascii a entero	
     		
    		move $t2, $v0
            
            beq $t2, 0xD, if_carriage_return
            j if_carriage_return_end
            	if_carriage_return:
            		li $t5, 13
            		
            		sb $t5, ($s4)  # Almacenar el valor de $t2 en la ubicación actual de $s4
    				addiu $s4, $s4, 1
					
					addi $t8, $t8, 8   # Continuar al siguiente caracter
					
					li $s2, 1 # Reiniciar indice
					
            		j loop_main
            if_carriage_return_end:
            
            beq $t2, 0xA, if_line_feed
            j if_line_feed_end 
            	if_line_feed:
            		li $t5, 10
            		
            		sb $t5, ($s4)  # Almacenar el valor de $t2 en la ubicación actual de $s3
    				addiu $s4, $s4, 1
					
					addi $t8, $t8, 8   # Continuar al siguiente caracter
					
					li $s2, 1 # Reiniciar indice
					
            		j loop_main
            if_line_feed_end:
            
            # Loop diccionario
			loop_child:    	
        		lb $t5, ($t9)      # Caracter actual
				addi $t9, $t9, 1   # avanza una posicion puntero diccionario[i + 1]
    			lb $t6, ($t9)      # Caracter siguiente
    			
        		blt $s2, $t2, increase_index # if( index < message[i].value )
        		j if_found
        		increase_index:
        			beq $t6, 0xD, if_value_equal_CR # Valida que el caracter siguiente sea carriage_return
					bne $t5, 0xA, if_not_equal_LF   # Valida que el caracter no sea LF
					if_value_equal_CR:
    					addiu $t9, $t9, 2	   # Avanza 2 posiciones para ignorar caracteres CR y LF
    					j end_if_CR_LF
    				if_not_equal_LF:
    					bne $t6, 0xD, skip_characters
    					skip_characters:
    						addiu $t9, $t9, 3	# Avanza 3 posiciones para ignorar caracter actual CR y LF
    					j end_if_CR_LF
    				end_if_CR_LF:
    				
        			addi $s2, $s2, 1   # aumenta contador
        			j loop_child
        		if_found:
        			beq $s2, $t2, value_found
        			j end_loop_main
        		value_found:
        			
        			#### DEBUG ###
        			#move $a0, $t5
    				#li $v0, 1                # Código del sistema para imprimir cadena
    				#syscall
    				#### DEBUG ###
    				
        			sb $t5, ($s4)  # Almacenar el valor de $t5 en la ubicación actual de $s4
    				addiu $s4, $s4, 1
        					
        			bne $t6, 0xD, if_not_equal_CR_3
        			j end_loop_child
        			if_not_equal_CR_3:
        				bne $t6, 0xA, if_not_equal_LF_3
        				if_not_equal_LF_3:

							#### DEBUG ###
        					#move $a0, $t6
    						#li $v0, 1                # Código del sistema para imprimir cadena
    						#syscall
    				 		#### DEBUG ###
        					
        					sb $t6, ($s4)
        					addiu $s4, $s4, 1
        		j end_loop_child
    		end_loop_child:
            
            
            #### DEBUG ###
            #move $a0, $t2
    		#li $v0, 1                # Código del sistema para imprimir cadena
    		#syscall
    		#### DEBUG ###
    		
            blez $t2, end_loop_main	# Si entero es 0 indica fin del mensaje
			 
			addi $t8, $t8, 8   # Continuar al siguiente caracter
			
			jal reset_values
          	j loop_main           	# Volver al inicio del bucle principal
    end_loop_main:
    la $s4, decodedMessageBuffer	# Reiniciar puntero buffer
    jal returnToMain

#### Reiniciar valores ####
reset_values:
	move $t9, $s0 # Reinicia puntero diccionario	     
    li $s2, 1
    li $t5, 0
    li $t6, 0
    jr $ra
