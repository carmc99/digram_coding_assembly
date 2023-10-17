.text

.globl debug
# Funcion para imprimir en pantalla
debug:
	move $t0, $a0 	# Param1: Mensaje
	
    li $v0, 4                # Código del sistema para imprimir cadena
    move $a0, $t0           	 # Dirección del búfer
    syscall
    
    # Volver $s7 = 0, para que no entre en un ciclo sin fin, (Solo se podra habilitar un debug al tiempo)
    li $s7, 0          # Cargar el valor 1 en $t1
    
    jr $ra
