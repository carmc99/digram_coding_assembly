.data
	digramFileName:   .asciiz "dictionary.txt"  	# Nombre del archivo que contiene el diccionario
	inputFileName:    .asciiz "digram_test.java"	# Nombre del archivo a codificar
.text

.globl main
main:
	la	$a0, digramFileName	
    jal     openFile
    
    move $s0, $a0				# Obtener buffer resultante de $0. $s0 -> Contiene el diccionario de digramas
    
    la	$a0, inputFileName	
    jal     openFile
    
    move $s1, $a0				# Obtener buffer resultante de $0. $s1 -> Contiene el contenido del archivo a codificar
    
    
    # terminate program
    li      $v0, 10
    syscall