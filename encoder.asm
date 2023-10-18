.data 
currentDigram:    .space 100
newLine:    	  .asciiz "\n"   # Carácter de salto de línea
carriageReturn:   .asciiz "\r"   # Carácter de retorno de carro
    
.text

.globl digramIsPresent
.globl getDigramKey
.globl encondedMessage

# Funcion para validar si el digrama se encuentra en el diccionario
digramIsPresent:
	 # Param1: $s0 -> Diccionario
	 # Param2: $a1 -> Primer caracter del digrama
	 # Param3: $a2 -> Segundo caracter del digrama
    li $v0, 0   # inicializar el resultado como falso
    li $v1, 0   # inicializar el resultado pos del digrama en 0
    li $t1, 0   # contador para identificar la posicion del digrama
	
    loopDigram:
    
        lb $t6, ($s0)      # ($t6) currentItem = diccionario[j]
        addi $s0, $s0, 1   # diccionario[j++]
    	lb $t7, ($s0)      # ($t7) nextItem = diccionario[j]
        
        beq $a1, $t6, checkSecondCharacter
        j digramNotFound

        addiu $s0, $s0, 4   # avanzar al siguiente elemento del diccionario
        addi $t1, $t1, 1   # incrementar el contador

        bnez $s0, loopDigram   # si no hemos recorrido todos los elementos, continuar el bucle

        j endDigramIsPresent   # si no se encuentra, terminar la función

checkSecondCharacter:
	beq $a2, $t7, digramFound
	
digramNotFound:
	li $v0, 0   # establecer el resultado como falso
	
	j endDigramIsPresent

digramFound:
    li $v0, 1   # establecer el resultado como verdadero
    move $v1, $t1 # Mover el valor del contador actual a $v1 - resultado
    j endDigramIsPresent

endDigramIsPresent:
    jr $ra   # regresar de la llamada
    
# Funcion para obtener la llave del digrama a partir del caracter de entrada
getDigramKey:
    
# Funcion para codificar un mensaje
encondedMessage:
	move $t0, $a0		# Param1: Buffer que contiene el mensaje a codificar
	
	la $t5, currentDigram
	loop:
            lb $t3, ($t0)  	   # ($t3) firsCharacter = message[i]
            addi $t0, $t0, 1   # i++
    		lb $t4, ($t0)      # ($t4) nextCharacter = message[i]
            
    		move $a1, $t3       # Primer caracter del digrama como arg
        	move $a2, $t4		# Segundo caracter del digrama como arg
        	# Llamada a la función
        	jal digramIsPresent
    		
    		# Resultado en $v0
        	beq $v0, $zero, no_found
        	# Si llegamos aquí, el digrama está presente
        	j found
			found:
			
				
    		no_found:
    		
    			
        	# Si llegamos aquí, el digrama no está presente
    		
    		continue:
    		##########
            li $v0, 11         # Cargar el sistema para la llamada al servicio de impresión de entero
            move $a0, $t3      # Mover el valor de $t3 a $a0
            syscall 
    		###########
            
            beqz $t3, end_loop  # Salir del bucle si llegamos al final de la cadena
            beqz $t4, end_loop  # Salir del bucle si llegamos al final de la cadena
            

            addi $t0, $t0, 1  	# Avanzar a la siguiente posición en la cadena
            j loop           	# Volver al inicio del bucle
    end_loop:
    
    jr $ra
