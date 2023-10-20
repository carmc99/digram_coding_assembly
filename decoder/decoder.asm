.data 
decodedMessageBuffer: .space 1024 

.text

.globl decodedMessage
      
# Funcion para codificar un mensaje

decodedMessage:
	move $t0, $a0		# Param1: Buffer que contiene el mensaje a decodificar
	move $t1, $s0		# Diccionario temporal 		
	# Registros
	la $s4, decodedMessageBuffer
	# Loop mensaje
	loop_main:
            lb $t2, ($t0)  	   # message[i]
            li $t3, 0		   # index = 0    		      
            
            # Loop diccionario
			loop_child:    	
        		lb $t4, ($t1)     
        		blt $t3, $t2, increase_index # if( index < message[i].value )
        		increase_index:
        			addi $t1, $t1, 1   # avanza una posicion puntero diccionario[i + 1]
        			j loop_child
        		beq $t3, $t2, value_found
        		value_found:
        			lb $t5, ($t1) # $t5 = diccionario[index]
        			sb $t5, ($s4)  # Almacenar el valor de $t5 en la ubicación actual de $s4
    				addiu $s4, $s4, 4
        		j end_loop_child
    		end_loop_child:

    		continue_main_loop:

			beqz $t2, end_loop_main    			     
          	j loop_main           	# Volver al inicio del bucle principal
    end_loop_main:
    jal returnToMain
