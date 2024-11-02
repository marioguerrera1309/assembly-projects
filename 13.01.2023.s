.data
str: .space 16
m1: .asciiz "Inscerisci una stringa con almeno 4 caratteri\n"
m2: .asciiz "Stringa troppo corta\n"
m3: .asciiz "Inserisci un numero a una cifra\n"
m4: .asciiz "Valore=%d\n"
p1s5: .space 8
val: .space 8
par: .word 0
ind: .space 8
num_byte: .word 16
.code
daddi $s0, $0, 0 ; i=0
for: 	slti $t0, $s0, 4
	beq $t0, $0, fine
	do: 	daddi $t0, $0, m1
		sd $t0, p1s5($0)
		daddi r14, $0, p1s5
		syscall 5
		daddi $a0, $0, str
		sd $a0, ind($0)
		daddi r14, $0, par
		syscall 3
		dadd $a1, $0, r1 ; a1=strlen(STR)
		slti $t0, $a1, 4
		beq $t0, $0, falso_1
		daddi $t0, $0, m2
		sd $t0, p1s5($0)
		daddi r14, $0, p1s5
		syscall 5
	falso_1:	slti $t0, $a1, 4
		bne $t0, $0, do
	 jal processa
	dadd $s1, $0, r1 ; $s1=ris
	bne $s1, $a1, falso_2
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	jal input_unsigned
	dadd $s1, $s1, r1
falso_2: 	sd $s1, val($0)
	daddi $t0, $0, m4
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	j for
fine: syscall 0
processa:	daddi $sp, $sp, -16
	sd $s2, 0($sp) ; j
	sd $s3, 8($sp) ; valore
	daddi $s2, $0, 0
	daddi $s3, $0, 0
	daddi $s4, $0, 2
	for_f: 	slt $t0, $s2, $a1
		beq $t0, $0, return
		dadd $t0, $a0, $s2
		lbu $t1, 0($t0)
		slti $t0, $t1, 58
		beq $t0, $0, falso_3
		daddi $s3, $s3, 1
		j inc
	falso_3: 	daddi $t0, $s3, 1
		mult $t0, $s4
		mflo $t1
		dadd $s3, $0, $t1
	inc:	daddi $s2, $s2, 1
		j for_f
return:	dadd r1, $0, $s3
	ld $s2, 0($sp)
	ld $s3, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
.include input_unsigned.s
