.data
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
	#####
	# TAMANO DEL DICCIONARIO
	li $s2, 255
	#####
	
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
  
    move $a0, $s1
    jal encondedMessage
    
    returnToMain:
    
    #lb $t8, ($s3)
    
    #li $v0, 1
    #move $a0,$t8
    #syscall
     
    move $a0, $s3
    jal saveEncodedMessage

    move $s3, $v0				# Obtener buffer resultante de $v0. $s1 -> Contiene direccion del archivo a codificar

end_program:
    # terminate program
    li      $v0, 10
    syscall


# Función para imprimir un buffer hasta encontrar un número negativo
# $a0: Dirección base del buffer
saveEncodedMessage:
	move $t9, $a0
	la   $t6, ouputFileBuffer 
    
    # Registros
    # $t8: Elemento actual buffer en Int
    # $t9: Direccion bufer mensaje codificado temporal
    # $t7: Elemento actual buffer ASCII
    # $t6: Buffer de salida archivo output.txt
    
    # Abrir el archivo para escribir        
    la $a0, ouputFileName  		 
    jal openWriteFile
    
    move $s7, $v0 # Almacenar descriptor
loop_save_encoded_message:
	
	# Dado que el valor de almaceno usando el metodo complemento a 2
	# Es necesario realizar la siguiente validacion: < -2, cargar sin signo, ver: https://en.wikipedia.org/wiki/Two%27s_complement
    lb $t8, ($t9)  # Almacena elemento int
    blt $t8, -2, use_lbu # Usar lb
    j continue
		use_lbu: 
			lbu $t8, ($t9)
	
	continue:	
    move   $a0, $t8
    
    # Llamar a la función itoa para convertir el entero en una cadena ASCII
    jal  itoa

	move $t7, $v0 # Pasar resultado conversion a $t7
	
	# Escribir en el archivo
    move $a0, $s7        # File descriptor devuelto por la llamada a abrir
    move $a1, $t7        # Dirección de la cadena que se escribirá en el archivo
    jal writeFile
    
    bltz $t8, end_loop_save_encoded_message  # Salir del bucle si el elemento es negativo

    addiu $t9, $t9, 4  # Avanzar al siguiente elemento en el buffer
    j loop_save_encoded_message

end_loop_save_encoded_message: 
    move $a0, $s7        # File descriptor devuelto por la llamada a abrir
    jal closeWriteFile
      
	j end_program	
