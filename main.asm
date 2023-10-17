.data
	debug_mode: 	  .word 1   # Variable global para indicar el modo de depuración (1 para habilitado, 0 para deshabilitado)
	digramFileName:   .asciiz "dictionary.txt"  	# Nombre del archivo que contiene el diccionario
	inputFileName:    .asciiz "digram_test.java"	# Nombre del archivo a codificar
.text

.globl main
main:
	la	$a0, digramFileName	
    jal     openFile
    
    move $s0, $v0				# Obtener buffer resultante de $0. $s0 -> Contiene direccion del diccionario de digramas
    
    ################ DEBUG ###############
    move $a0, $s0
    beq $t1, 1, debug
    ################ DEBUG ###############

    la	$a0, inputFileName	
    jal     openFile
    
    move $s1, $v0				# Obtener buffer resultante de $0. $s1 -> Contiene direccion del archivo a codificar
    
    ################ DEBUG ###############
	move $a0, $s1
    beq $t1, 1, debug
    ################ DEBUG ###############
    
    move $a0, $s1
    jal encondedMessage
    
    # terminate program
    li      $v0, 10
    syscall