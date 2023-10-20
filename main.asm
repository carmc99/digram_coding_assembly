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
loop_print_buffer:
    lb $t8, ($t9)  # Almacena elemento int
    
    move   $a0, $t8
    # Llamar a la función itoa para convertir el entero en una cadena ASCII
    jal  itoa

	move $t7, $v0 # Pasar resultado conversion a $t7
	
	sb $t7, ($t6)	# Almacenar caracter en buffer
    addiu $t6, $t6, 1 # Avanzar puntero buffer de salida

        
	la	 $a0, ouputFileName	
	move $a1, $t7
    jal writeFile
            
    bltz $t8, end_print_buffer  # Salir del bucle si el elemento es negativo
    
    #li $v0, 1
    #move $a0, $t8  # Pasar la dirección del elemento a imprimir
    #syscall
    
	li $v0, 4
    move $a0, $t7  # Pasar la dirección del elemento a imprimir
    syscall
    
    
    
    addiu $t9, $t9, 4  # Avanzar al siguiente elemento en el buffer
    j loop_print_buffer

end_print_buffer:
	
    
	j end_program	