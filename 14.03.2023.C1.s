.data
stringa: .space 8

m1: .asciiz "Inserisci una stringa con al massimo 8 caratteri\n"
m2: .asciiz "Inserisci un numero con %d cifre\n"
m3: .asciiz "Risultato= %d\n"
p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 8

.code
daddi $s0, $0, 0 ;i=0
do: 	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $a0, $0, stringa
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	dadd $a1, $0, r1
	sd r1, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $a2, $0, val
	sd $a2, ind($0)
	daddi r14, $0, par
	syscall 3
	; jal input_unsigned
	; dadd $a2, $0, r1
	jal elabora
	dadd $s1, $0, r1
	sd $s1, val($0)
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	beq $s1, $0, fine
	slti $t0, $s0, 3
	beq $t0, $0, fine
	j do
fine: syscall 0
elabora:	daddi $sp, $sp, -32
	sd $s2, 0($sp) ; i
	sd $s3, 8($sp) ; t
	sd $s4, 16($sp) ; val
	daddi $s2, $0, 0
	daddi $s3, $0, 0
	daddi $s4, $0, 0
	daddi $s5, $0, 10 ; s5=10
	for:	slt $t0, $s2, $a1
		beq $t0, $0, return
			ddiv $a2, $s5
			mfhi $t1
			dadd $s4, $0, $t1 ; s4=val
			dadd $t1, $a0, $s2
			lbu $t2, 0($t1)
			daddi $t1, $t2, -48 ; t1=s[i]-48
			slt $t0, $s4, $t1
			beq $t0, $0, inc_i
			daddi $s3, $s3, 1
	inc_i:	daddi $s2, $s2, 1
		j for
return: 	dadd r1, $0, $s3
	ld $s2, 0($sp)
	ld $s3, 8($sp)
	ld $s4, 16($sp)
	daddi $sp, $sp, 32
	jr $ra
.include input_unsigned.s
