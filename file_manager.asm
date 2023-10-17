.data
	debug_mode: 	  .word 0   # Variable global para indicar el modo de depuración (1 para habilitado, 0 para deshabilitado)
	buffer:           .space  1024  			# Buffer para leer el archivo
	errorOpenMsg:     .asciiz "Error al abrir el archivo\n"
	errorReadMsg:	  .asciiz "Error al leer el archivo\n"

.text

.globl openFile
.globl fileOpened
.globl fileOpenError

# Funcion para cargar un archivo
openFile:
	move $t0, $a0					# Param1: Direccion del archivo
	
   	# Abrir el archivo
    la   $a0, ($t0)      			# Dirección del nombre del archivo
    li   $a1, 0             		# Modo de apertura (solo lectura)
    li   $v0, 13            		# Código de la llamada al sistema para abrir un archivo
    syscall
        
    bltz $v0, fileOpenError     	# Si $v0 es menor que cero, el archivo se abrió con errores
    
    move $a0, $v0					# Retornar el descriptor de archivo (negativo en caso de error)
    j fileOpened
    
    jr $ra
    	
fileOpened:
	move $t0, $a0 			#Param1: Descriptor
	
	lw $t1, debug_mode         # Cargar el valor de debug_mode en $t0
	
    # Leer contenido del archivo y almacenar en el búfer
    li $v0, 14               # Código del sistema para leer desde el archivo
    move $a0, $t0            # Descriptor de archivo
    la $a1, buffer           # Dirección del búfer
    li $a2, 1024             # Número máximo de bytes a leer
    syscall
	
	bltz $v0, fileReadError     	# Si $v0 es menor que cero, erro al leer el archivo
	
	################ DEBUG ###############
    # Imprimir el contenido leído si el modo depuracion esta habilitado
    la $a0, buffer
    beq $t1, 1, debug
    ################ DEBUG ###############
    
    # Cerrar el archivo
    li $v0, 16               # Código del sistema para cerrar el archivo
    move $a0, $v0            # Descriptor de archivo
    syscall
    
    move $v0, $a1 			 # Devolver la dirección del búfer en $v0

	jr $ra
fileOpenError:
    # Manejar el error de apertura de archivo
    li $v0, 4
    la $a0, errorOpenMsg
    syscall

    # Terminar el programa con error
    li $v0, 10
    syscall

fileReadError:
    # Manejar el error de apertura de archivo
    li $v0, 4
    la $a0, errorReadMsg
    syscall

    # Terminar el programa con error
    li $v0, 10
    syscall