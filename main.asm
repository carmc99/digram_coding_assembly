.data
	debug_mode: 	  .word 1   # Variable global para indicar el modo de depuración (1 para habilitado, 0 para deshabilitado)
	digramFileName:   .asciiz "dictionary.txt"  	# Nombre del archivo que contiene el diccionario
	digramBuffer:     .space  1024  			# Buffer para el diccionario
	inputFileName:    .asciiz "digram_test.java"	# Nombre del archivo a codificar
	inputFileBuffer:  .space  1024  			# Buffer para el archivo a codificar
.text

.globl main
main:
	lw $s7, debug_mode         # Cargar el valor de debug_mode en $s7
	
	la	$a0, digramFileName	
	la	$a1, digramBuffer
    jal     openFile
      
    move $s0, $v0				# Obtener buffer resultante de $0. $s0 -> Contiene direccion del diccionario de digramas
    
    # Cerrar el archivo
    li $v0, 16               # Código del sistema para cerrar el archivo
    syscall
    
    la	$a0, inputFileName
    la	$a1, inputFileBuffer	
    jal     openFile
    
    move $s1, $v0				# Obtener buffer resultante de $0. $s1 -> Contiene direccion del archivo a codificar
     
    # Cerrar el archivo
    li $v0, 16               # Código del sistema para cerrar el archivo
    syscall

    # Imprimir el contenido leído si el modo depuracion esta habilitado
    ################ DEBUG ###############
    move $a0, $s1
    beq $s7, 1, debug
    ################ DEBUG ###############
    
    #move $a0, $s0
    #jal encondedMessage
    
    # terminate program
    li      $v0, 10
    syscall
