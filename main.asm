.data
	diagramFileName:  .asciiz "dictionary.txt"  	# Nombre del archivo
	
.text

.globl main
main:
	la	$a0, diagramFileName	
    jal     openFile
    # terminate program
    li      $v0, 10
    syscall