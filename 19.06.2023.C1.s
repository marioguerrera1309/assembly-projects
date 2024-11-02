.data 
stringa: .space 8

m1: .asciiz "Inserisci il numero minimo di caratteri da inserire\n"
m2: .asciiz "Inserisci una stringa con almeno %d caratteri\n"
m3: .asciiz "Stringa di dimensione sbagliata. Fine esecuzione\n"
m4: .asciiz "Risultato=%d\n"

p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 8

.code
daddi $s0, $0, 0 ; i=0
while: 	slti $t0, $s0, 3
	beq $t0, $0, fine
	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	jal input_unsigned
	dadd $a1, $0, r1 ; a1=num
	sd $a1, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $a0, $0, stringa
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	dadd $s1, $0, r1 ; s1=strlen(stringa)
	slt $t0, $s1, $a1
	beq $t0, $0, falso
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $0, 3
	j while
falso:	jal esegui
	sd r1, val($0)
	daddi $t0, $0, m4
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	j while
fine: syscall 0
esegui:	daddi $sp, $sp, -16
	sd $s2, 0($sp) ; i
	sd $s3, 8($sp) ; t
	daddi $s2, $0, 0
	daddi $s3, $0, 0
	daddi $s4, $0, 4 ; s4=4
	for: 	slt $t0, $s2, $a1
		beq $t0, $0, return
		dadd $t1, $a0, $s2
		lbu $t0, 0($t1) ; t0=s[i]
		ddiv $t0, $s4
		mfhi $t1
		dadd $s3, $s3, $t1 
		daddi $s2, $s2, 1
		j for
return: 	dadd r1, $0, $s3
	ld $s2, 0($sp)
	ld $s3, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
.include input_unsigned.s
