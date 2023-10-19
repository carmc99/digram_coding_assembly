.data 
currentDigram:    .space 100
newLine:    	  .asciiz "\n"   # Carácter de salto de línea
carriageReturn:   .asciiz "\r"   # Carácter de retorno de carro
    
.text

.globl digramIsPresent
.globl encondedMessage

# Funcion para validar si el digrama se encuentra en el diccionario
digramIsPresent:
	 # Param1: $s0 -> Diccionario
	 # Param2: $a1 -> Primer caracter del digrama
	 # Param3: $a2 -> Segundo caracter del digrama
    li $v0, 0   # inicializar el resultado como falso
    li $v1, 0   # inicializar el resultado pos del digrama en 0
    li $t1, 0   # inicializa el contador pos digrama en 0
	move $t8, $s0 # Almacena el diccionario en una variable temporal, para recorrerlo
    loopDigram:
    	lb $t6, ($t8)      # ($t6) currentItem = diccionario[j]
        
        addi $t8, $t8, 1   # diccionario[j++]
    	lb $t7, ($t8)      # ($t7) nextItem = diccionario[j]
    	beq $t7, 0xD, skipCharacters	
    	
        ##########
        #li $v0, 11         # Cargar el sistema para la llamada al servicio de impresión de entero
        #move $a0, $a1      # Mover el valor de $t3 a $a0
        #syscall 
    	###########
        ##########
        #li $v0, 11         # Cargar el sistema para la llamada al servicio de impresión de entero
        #move $a0, $t6      # Mover el valor de $t3 a $a0
        #syscall 
    	###########
    	##########
        #li $v0, 11         # Cargar el sistema para la llamada al servicio de impresión de entero
        #move $a0, $a2      # Mover el valor de $t3 a $a0
        #syscall 
    	###########
    	##########
        #li $v0, 11         # Cargar el sistema para la llamada al servicio de impresión de entero
        #move $a0, $t7      # Mover el valor de $t3 a $a0
        #syscall 
    	###########
    	
        beq $a1, $t6, checkMessageSecondCharacter
        j digramNotFound

# Valida que el caracter siguiente no sea carriage_return
skipCharacters:
    addiu $t8, $t8, 2   # Avanzar al siguiente carácter (omitiendo el retorno de carro y salto de línea)
    addi $t1, $t1, 1   # incrementar el contador
    blt $t1, $s2, loopDigram   # Si no hemos recorrido todos los elementos, continuar el bucle
    
checkMessageSecondCharacter:
	beqz $a2, digramFound  # Si el ultimo caracter a comparar es 0, se asume que es un caracter indivisual y no par
	beq $a2, $t7, digramFound

digramNotFound:
	li $v0, 0   # establecer el resultado como falso
	li $v1, 0 
	
	blt $t1, $s2, loopDigram   # si no hemos recorrido todos los elementos, continuar el bucle
	j endDigramIsPresent   # si no se encuentra, terminar la función

digramFound:
    li $v0, 1     # establecer el resultado como verdadero
    move $v1, $t1 # mover el valor del contador actual a $v1 - resultado

    j endDigramIsPresent

endDigramIsPresent:
	li $t6, 0 # limpiar registro
	li $t7, 0 # limpiar registro
    jr $ra   
      
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
			##########
        	li $v0, 1         # Cargar el sistema para la llamada al servicio de impresión de entero
        	move $a0, $v1      # Mover el valor de $t3 a $a0
        	syscall 
	    	###########
				
			# Sino encuentra el digrama, busca solo el primer caracter
    		no_found:
    			move $a1, $t3       
    			li $a2, 0
    			jal digramIsPresent
    			beq $v0, 1, found
    			j end_loop
    			
        	# Si llegamos aquí, el digrama no está presente
    		
    		continue:
            beqz $t3, end_loop  # Salir del bucle si llegamos al final de la cadena
            beqz $t4, end_loop  # Salir del bucle si llegamos al final de la cadena
            

            addi $t0, $t0, 1  	# Avanzar a la siguiente posición en la cadena
            j loop           	# Volver al inicio del bucle
    end_loop:
    jal returnToMain
