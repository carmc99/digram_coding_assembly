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
     		jal  atoi
    
    		move $t2, $v0
            
            bltz $t2, end_loop_main
            
             		      
			
			move $a0, $t4
    		li $v0, 1                # Código del sistema para imprimir cadena
    		syscall
			 
			addi $t8, $t8, 8   # Continuar al siguiente caracter NO FUNCIONA
			    			     
          	j loop_main           	# Volver al inicio del bucle principal
    end_loop_main:
    jal returnToMain
