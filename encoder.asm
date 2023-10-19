.data 
currentDigram:    .space 100
newLine:    	  .asciiz "\n"   # Carácter de salto de línea
carriageReturn:   .asciiz "\r"   # Carácter de retorno de carro
    
.text

.globl encondedMessage
      
# Funcion para codificar un mensaje
encondedMessage:
	move $t0, $a0		# Param1: Buffer que contiene el mensaje a codificar
	move $t1, $s0 		
	# Registros
	# $s0 Diccionario original
	# $s1 Mensaje original
	# $s3 Tamano del diccionario
	# $t0 Mensaje temporal
	# $t1 Diccionario temporal
	# $t2 Contador
	# $t3 Primer caracter mensaje
	# $t4 Segundo caracter mensaje
	# $t5 Primer caracter diccionario
	# $t6 Segundo caracter diccionario
	# $t7 Bandera, digrama encontrado
	li $t2, 0
	loop_main:
            lb $t3, ($t0)  	   
            addi $t0, $t0, 1   # avanza una posicion puntero texto[i + 1]
    		lb $t4, ($t0)      
            
			loop_child:    	
        		lb $t5, ($t1)     
        		addi $t1, $t1, 1   # avanza una posicion puntero diccionario[i + 1]
    			lb $t6, ($t1)      
        		
        		beq $t3, $t5, if_second_character_equal
        		j loop_child_continue
    			if_second_character_equal:
					beq $t4, $t6, digram_found
				digram_found:
					li $t7, 1     # establecer bandera en verdadero
					j end_loop_child
				loop_child_continue:
					beq $t6, 0xD, if_value_equal_CR
					if_value_equal_CR:
    					addiu $t1, $t1, 2    # Valida que el caracter siguiente no sea carriage_return
					addi $t2, $t2, 1 # aumentar contador
					ble $t2, $s3, loop_child # validar si contador < tamano diccionario	
					j end_loop_child 
    		end_loop_child:
          	j loop_main           	# Volver al inicio del bucle
    end_loop_main:
    jal returnToMain
