.text

.globl debug
# Funcion para imprimir en pantalla
debug:
	move $t0, $a0 	# Param1: Mensaje
	
    li $v0, 4                # Código del sistema para imprimir cadena
    la $a0, ($t0)           	 # Dirección del búfer
    syscall
    
    jr $ra