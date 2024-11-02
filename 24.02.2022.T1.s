.data
st: .space 16

m1: .asciiz "Inserisci una stringa di soli numeri\n"
m2: .asciiz "Insersci un numero a una cifra\n"
m3: .asciiz "Valore=%d\n"

p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 16

.code
daddi $s0, $0, 0 ; i=0
do: 	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $a0, $0, st
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3 ; a0=ST
	dadd $a1, $0, r1 ; a1=strlen(ST)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	jal input_unsigned
	dadd $a2, $0, r1 ; a2= num
	jal calcola
	sd r1, val($0)
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	slti $t0, $s0, 3
	beq $t0, $0, fine
	j do
fine: syscall 0
calcola: 	daddi $sp, $sp, -16
	sd $s2, 0($sp) ; j
	sd $s3, 8($sp) ; count
	daddi $s2, $0, 0
	daddi $s3, $0, 0
	for: 	slt $t0, $s2, $a1
		beq $t0, $0, return
		dadd $t0, $a0, $s2
		lbu $t1, 0($t0)
		daddi $t0, $t1, -48 ; t0=st[j]-48
		slt $t1, $t0, $a2
		beq $t1, $0, falso
		daddi $s3, $s3, 1
		j inc
	falso: 	daddi $s3, $s3, 2
	inc:	daddi $s2, $s2, 1
		j for
return: 	dadd r1, $0, $s3
	ld $s2, 0($sp)
	ld $s3, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
.include input_unsigned.s
