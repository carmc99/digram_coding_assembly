.data
	inputFileName:    .asciiz "digram_test.java"	# Nombre del archivo de entrada

.globl printAsciiz

    # $t5 = address of ASCIIz string, modifies $v0
printAsciiz:
    # store original $a0 to stack (to preserve it)
    addi    $sp, $sp, -4
    sw      $a0, ($sp)
    # output the message from t5
    li      $v0, 4
    move    $a0, $t5
    syscall
    # restore $a0 from stack
    lw      $a0, ($sp)
    addi    $sp, $sp, 4
    # return from function
    jr      $ra