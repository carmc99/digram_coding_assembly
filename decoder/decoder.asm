.data 
decodedMessageBuffer: .space 1024 

.text

.globl decodedMessage
      
# Funcion para codificar un mensaje

decodedMessage:
	move $t9, $s0		# Diccionario temporal
	move $t8, $a0		# Param1: Buffer que contiene el mensaje a decodificar 		
	# Registros
	# $s0 Diccionario original
	# $s1 Mensaje original
	# $t9 Diccionar temporal
	# $t8 Mensaje temporal
	# 
	la $s4, decodedMessageBuffer
			
	# Loop mensaje
	loop_main:
			li $t3, 0		   # index = 0   
            la $t2, ($t8)  	   # message[i]	
     		move   $a0, $t2    # Cargar la dirección de la cadena en $a0
     		jal  atoi		   # Convertir Ascii a entero	
     		
    		move $t2, $v0
            
            #########
            # Loop diccionario
			loop_child:    	
        		lb $t5, ($t9)      # Caracter actual
        		addi $t9, $t9, 1   # avanza una posicion puntero diccionario[i + 1]
    			lb $t6, ($t9)      # Caracter siguiente
    			
        		blt $t3, $t2, increase_index # if( index < message[i].value )
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
    				
        			addi $t3, $t3, 1   # aumenta contador
        			j loop_child
        		if_found:
        			beq $t3, $t2, value_found
        			
        			#move $a0, $t2
    				#li $v0,                 # Código del sistema para imprimir cadena
    				#syscall
        			j end_loop_main
        		value_found:
        			#addi $t9, $t9, 1
        			#lb $t7, ($t9) # $t5 = diccionario[index]
        			# Almacenar $t5 -> primer caracter
        			# $t6 -> Segundo caracter
        			#xor $
        			move $a0, $t5
    				li $v0, 1                # Código del sistema para imprimir cadena
    				syscall
    		
        			sb $t5, ($s4)  # Almacenar el valor de $t5 en la ubicación actual de $s4
    				addiu $s4, $s4, 4
    				
        			bne $t6, 0xD, if_not_equal_CR
        			if_not_equal_CR:
        				bne $t6, 0xA, if_not_equal_LF_2
        				if_not_equal_LF_2:
        					#addi $t8, $t8, 8		# Como encontro un par avanza otra posicion en el puntero del mensaje
        					
        					move $a0, $t6
    						li $v0, 1                # Código del sistema para imprimir cadena
    						syscall
    				
        					sb $t6, ($s4)
        					addiu $s4, $s4, 4
        		j end_loop_child
    		end_loop_child:
            
            
            ########
            #move $a0, $t2
    		#li $v0, 1                # Código del sistema para imprimir cadena
    		#syscall
    		
            bltz $t2, end_loop_main	# Si entero es negativo indica fin del mensaje
			 
			addi $t8, $t8, 8   # Continuar al siguiente caracter
			
			jal reset_values
          	j loop_main           	# Volver al inicio del bucle principal
    end_loop_main:
    jal returnToMain

#### Reiniciar valores ####
reset_values:
	move $t9, $s0 # Reinicia puntero diccionario	     
    li $t5, 0
    li $t6, 0
    jr $ra