.data
	buffer:           .space  1024  			# Buffer para leer el archivo
	errorOpenMsg:     .asciiz "Error al abrir el archivo\n"
	errorReadMsg:	  .asciiz "Error al leer el archivo\n"
	errorOpenWriteFileMsg: .asciiz "Error al abrir el archivo de escritura\n"
	errorWriteFileMsg: .asciiz "Error al escribir en el archivo\n"

.text

.globl openFile
.globl fileOpened
.globl fileOpenError
.globl openWriteFile
.globl writeFile
.globl closeWriteFile



openWriteFile:
	move $t0, $a0					# Param1: Direccion del archivo
    
    # Abrir el archivo para escribir
            
    la $a0, ($t0)  		 # Dirección de la cadena que contiene el nombre del archivo
    li $a1, 1            # Modo de apertura: 1 para escritura
    li $v0, 13            
    syscall

    # Verificar si hubo algún error al abrir el archivo
    bltz $v0, fileWriteOpenError
    
    jr $ra

writeFile:
	move $t0, $a0					# Param1: Descriptor
	move $t1, $a1					# Parama2: Buffer

	# Escribir en el archivo
    move $a0, $t0        # File descriptor devuelto por la llamada a abrir
    move $a1, $t1       # Dirección de la cadena que se escribirá en el archivo
    li $a2, 2           # Longitud de la cadena a escribir
    li $v0, 15           # Código de la llamada al sistema para escribir en el archivo
    syscall

    # Verificar si hubo algún error al escribir en el archivo
    bltz $v0, fileWriteError
    
    jr $ra
    
closeWriteFile:
    move $t0, $a0					# Param1: Descriptor
	
	move $a0, $t0        # File descriptor devuelto por la llamada a abrir
    li $v0, 16           # Código de la llamada al sistema para cerrar el archivo
    syscall

    # Salir de la función
    jr $ra

  
fileWriteError:
	# Manejar el error de apertura de archivo
    li $v0, 4
    la $a0, errorWriteFileMsg
    syscall

    # Terminar el programa con error
    li $v0, 10
    syscall
          
fileWriteOpenError:
    li $v0, 4
    la $a0, errorOpenWriteFileMsg
    syscall

    # Terminar el programa con error
    li $v0, 10
    syscall
    
# Funcion para cargar un archivo
openFile:
	move $t0, $a0					# Param1: Direccion del archivo
	move $t1, $a1					# Parama2: Buffer
	
   	# Abrir el archivo
    la   $a0, ($t0)      			# Dirección del nombre del archivo
    li   $a1, 0             		# Modo de apertura (solo lectura)
    li   $v0, 13            		# Código de la llamada al sistema para abrir un archivo
    syscall
        
    bltz $v0, fileOpenError     	# Si $v0 es menor que cero, el archivo se abrió con errores
    
    move $a0, $v0					# Retornar el descriptor de archivo (negativo en caso de error)
    move $a1, $t1					# Buffer
    j fileOpened
    
    jr $ra
    	
fileOpened:
	move $t0, $a0 			#Param1: Descriptor
	move $t1, $a1			# Parama2: Buffer
	
    # Leer contenido del archivo y almacenar en el búfer
    li $v0, 14               # Código del sistema para leer desde el archivo
    move $a0, $t0            # Descriptor de archivo
    move $a1, $t1            # Dirección del búfer
    li $a2, 1024             # Número máximo de bytes a leer
    syscall
	
	bltz $v0, fileReadError     	# Si $v0 es menor que cero, erro al leer el archivo
	
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
