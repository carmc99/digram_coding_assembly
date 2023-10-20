.data
	debug_mode: 	  .word 0   # Variable global para indicar el modo de depuración (1 para habilitado, 0 para deshabilitado)
	digramFileName:   .asciiz "dictionary.txt"  	# Nombre del archivo que contiene el diccionario
	digramBuffer:     .space  1024  			# Buffer para el diccionario
	inputFileName:    .asciiz "digram_test.java"	# Nombre del archivo a codificar
	inputFileBuffer:  .space  1024  			# Buffer para el archivo a codificar
	ouputFileName:    .asciiz "output.txt"  	# Nombre del archivo que contiene el diccionario
	ouputFileBuffer:  .space  1024  			# Buffer para el diccionario
	
.text

.globl main
.globl returnToMain
main:
	lw $s7, debug_mode         # Cargar el valor de debug_mode en $s7
	li $s2, 7
	
	la	$a0, digramFileName	
	la	$a1, digramBuffer
    jal     openFile
      
    move $s0, $v0				# Obtener buffer resultante de $0. $s0 -> Contiene direccion del diccionario de digramas
    
    # Cerrar el archivo
    li $v0, 16               # Código del sistema para cerrar el archivo
    # $a0 <- proviene el descriptor, por ello no se especifica
    syscall
    
    la	$a0, inputFileName
    la	$a1, inputFileBuffer
    jal     openFile
    
    move $s1, $v0				# Obtener buffer resultante de $v0. $s1 -> Contiene direccion del archivo a codificar
     
    # Cerrar el archivo
    li $v0, 16               # Código del sistema para cerrar el archivo
    # $a0 <- proviene el descriptor, por ello no se especifica
    syscall

    # Imprimir el contenido leído si el modo depuracion esta habilitado
    ################ DEBUG ###############
    move $a0, $s0
    beq  $s7, $zero, notDebug
    jal debug
    notDebug:
    ################ DEBUG ###############
    
    move $a0, $s1
    jal encondedMessage
    
    returnToMain:
    
    #### TODO: 
    # Obtener $s3 -> Contenido codificado
    # Escribir valor $s3 en output.txt
    
    
    move $a0, $s3
    jal print_buffer
    #la	 $a0, ouputFileName	
	#move $a1, $s3
    #jal writeFile

	
	
  	#la	 $a0, ouputFileName
    #la   $a1, ouputFileBuffer
    #jal  openFile
    
    move $s3, $v0				# Obtener buffer resultante de $v0. $s1 -> Contiene direccion del archivo a codificar

end_program:
    # terminate program
    li      $v0, 10
    syscall


# Función para imprimir un buffer hasta encontrar un número negativo
# $a0: Dirección base del buffer
print_buffer:
	move $t9, $a0
	la   $t6, ouputFileBuffer 
    
    # Registros
    # $t8: Elemento actual buffer en Int
    # $t9: Direccion bufer mensaje codificado temporal
    # $t7: Elemento actual buffer ASCII
    # $t6: Buffer de salida archivo output.txt
    
    # Abrir el archivo para escribir        
    la $a0, ouputFileName  		 # Dirección de la cadena que contiene el nombre del archivo
    jal openWriteFile
    
    move $s7, $v0 # Almacenar descriptor
loop_print_buffer:
    lb $t8, ($t9)  # Almacena elemento int
    
    move   $a0, $t8
    
    # Llamar a la función itoa para convertir el entero en una cadena ASCII
    jal  itoa

	move $t7, $v0 # Pasar resultado conversion a $t7
	
    bltz $t8, end_print_buffer  # Salir del bucle si el elemento es negativo

	# Escribir en el archivo
    move $a0, $s7        # File descriptor devuelto por la llamada a abrir
    move $a1, $t7        # Dirección de la cadena que se escribirá en el archivo
    jal writeFile
    
    addiu $t9, $t9, 4  # Avanzar al siguiente elemento en el buffer
    j loop_print_buffer

end_print_buffer: 
 	# Cerrar el archivo
 	
    move $a0, $s7        # File descriptor devuelto por la llamada a abrir
    jal closeWriteFile
      
	j end_program	