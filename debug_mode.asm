.text

.globl debug
# Funcion para imprimir en pantalla
debug:
	# $a0 	# Param1: Mensaje, Dirección del búfer
	
    li $v0, 4                # Código del sistema para imprimir cadena
    syscall
    
    # Volver $s7 = 0, para que no entre en un ciclo sin fin, (Solo se podra habilitar un debug al tiempo)
    li $s7, 0          # Cargar el valor 1 en $t1

	jr $ra