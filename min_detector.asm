.data
	resultString: .space 1024
	inputString: .asciiz "SolO)_miN"
	result: .asciiz "\n Caracteres resultantes: "
.text

main:
	la $s0, inputString # Obtiene de la memoria el apuntador y lo guarda en el registro $s0
	la $s1, resultString
	
	# Llamado a la funcion
	move $a0, $s0
	move $a1, $s1
	jal deleteUpperCase
	
	la $t0, result
	
	# Imprimir mensaje reuslt
	li $v0, 4
	move $a0, $t0
	syscall
	
	move $t0, $v0
	
	# Imprimir numero de caracteres resultantens, luego del filtro
	li $v0, 1
	move $a0, $t0
	syscall
	
	# Finaliza el programa
	li $v0, 10
	syscall


deleteUpperCase:
	# Registros
	# $a0 Apuntador cadena
	# $a1 Apuntandor cadena resulante
	
	li $t0, 0	# Contador numero de caracteres resultante
	move $t1, $a0 # Mover cadena de entrada a registro temporal
	move $t3, $a1 
	
	# Recorrer cadena de entrada
	while:
		lb $t2, ($t1)	# Obtener primer caracter cadena de entrada, almacenarlo en $t2
		bge $t2, 97, if_upper_case_1 # Primera validacion caracter ASCII es mayor o igual a 97 (Inicio caracteres en minus imprimibles)
		j end_if_upper_case
		if_upper_case_1:
			ble $t2, 122, if_upper_case_2	# Segunda validacion caracter ASCII es menor o igual a 122 (Fin caracteres en minus imprimibles) 
			j end_if_upper_case
			if_upper_case_2:
				
				# Imprimir caracter detectado
				li $v0, 1
				move $a0, $t2
				syscall

				addi $t0, $t0, 1    # Aumentar contador cadena resultante
				sb $t2, ($t3)		# Almacena el caracter en el apuntador de salida
				addi $t3, $t3, 1	# Avanza el apuntador de salida a la siguiente posicion
		end_if_upper_case:		
		
		addi $t1, $t1, 1 # Avanzar al siguiente caracter		
		beqz $t2, endWhile	# Sino hay ningun caracter, el ciclo finaliza
		j while
	endWhile:
	
	move $v0, $t3	# Numero de caracteres resultanten
	move $v1, $t3	# Cadena resultante
	
	jr $ra