.text

.globl digramIsPresent
.globl getDigramKey
.globl encondedMessage

# Funcion para validar si el digrama se encuentra en el diccionario
digramIsPresent:
    
# Funcion para obtener la llave del digrama a partir del caracter de entrada
getDigramKey:
    
# Funcion para codificar un mensaje
encondedMessage:
	move $t0, $a0		# Param1: Buffer que contiene el mensaje a codificar
	
	#la $a0, $s1		# Cargar direccion del mensaje
	loop:
            lb $t3, ($t0)  	    # Cargar el byte actual de la cadena en $t3
            beqz $t3, end_loop  # Salir del bucle si llegamos al final de la cadena

	 		# Imprimir el valor de $t3
            li $v0, 11         # Cargar el sistema para la llamada al servicio de impresión de entero
            move $a0, $t3      # Mover el valor de $t3 a $a0
            syscall            # Llamada al sistema para imprimir el valor de $t3
            
            addi $t0, $t0, 1  	# Avanzar a la siguiente posición en la cadena
            j loop           	# Volver al inicio del bucle
    end_loop:
    
    jr $ra
