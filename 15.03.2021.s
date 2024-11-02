.data
str: .space 16

m1: .asciiz "Inserisci una stringa con soli numeri o lettere minuscole\n"
m2: .asciiz "Inserisci un numero minore di %d\n"
m3: .asciiz "Il numero corrispondente alla stringa e'  %d\n"

p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 16

.code
daddi $s0, $0, 0 ; i=0
for: 	slti $t0, $s0, 3
	beq $t0, $0, fine
	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $a0, $0, str
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	sd r1, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	jal input_unsigned
	dadd $a1, $0, r1
	jal calcola
	sd r1, val($0)
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	j for
fine: syscall 0
calcola: 	daddi $sp, $sp, -16
	sd $s1, 0($sp) ; k
	sd $s2, 8($sp) ; s
	daddi $s1, $0, 0
	daddi $s2, $0, 0
	daddi $s3, $0, 16
	for_f: 	slt $t0, $s1, $a1
		beq $t0, $0, return
		dadd $t1, $a0, $s1
		lbu $t2, 0($t1) ; t2= st[k]
		slti $t0, $t2, 58
		beq $t0, $0, false
		; s= (s+ST[k]-48) % 16;
		daddi $t1, $t2, -48
		dadd $t3, $s2, $t1 ; (s+ST[k]-48)
		ddiv $t3, $s3
		mfhi $t0
		dadd $s2, $0, $t0
		j inc 
	false: 	slti $t0, $t2, 123
		beq $t0, $0, inc
		; s= (s+ST[k]-97) % 16; 
		daddi $t1, $t2, -97
		dadd $t3, $s2, $t1 ; (s+ST[k]-97)
		ddiv $t3, $s3
		mfhi $t0
		dadd $s2, $0, $t0
		j inc 
	inc:	daddi $s1, $s1, 1
		j for_f
return: 	dadd r1, $0, $s2
	ld $s1, 0($sp)
	ld $s2, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
.include input_unsigned.s
