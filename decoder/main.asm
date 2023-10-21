.data
	digramFileName:   .asciiz "dictionary.txt"  	# Nombre del archivo que contiene el diccionario
	digramBuffer:     .space  1024  				# Buffer para el diccionario
	inputFileName:    .asciiz "output.txt"			# Nombre del archivo a decodificar
	inputFileBuffer:  .space  1024  				# Buffer para el archivo a codificar
	ouputFileName:    .asciiz "decoded.txt"  		# Nombre del archivo resultante
	ouputFileBuffer:  .space  1024  				# Buffer para el diccionario
	
.text

.globl main
.globl returnToMain
main:
	#####
	# TAMANO DEL DICCIONARIO
	li $s2, 7
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
    jal decodedMessage
    
    returnToMain:

end_program:
    # terminate program
    li      $v0, 10
    syscall
