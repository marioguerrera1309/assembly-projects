.data
mess1: .asciiz "indice %d Inserisci stringa\n"
mess2: .asciiz "pochi caratteri\n"
mess3: .asciiz "RIs=%d\n"
p1sys5: .space 8
num: .space 8 
valori: .space 32
p1sys3: .word 0
indsys3: .space 8
numsys3: .word 32
.code
; for(s0=0; s0<3; )
daddi $s0, r0, 0 ; s0=0
for: slti $t0, $s0, 3 ; $t0=1 se s0<3
	beq $t0, r0, fine
	; se abbiamo inserito 2 caratteri s0 non si incrementa
	; se abbiamo inserito più di 2 caratteri s0 si incrementa
	; printf mess1
	sd $s0, num(r0) ; num=s0=i
	daddi $t0, r0, mess1
	sd $t0, p1sys5(r0)
	daddi r14, r0, p1sys5
	syscall 5
	; scanf
	daddi $t0, r0, valori
	sd $t0, indsys3(r0)
	daddi r14, r0, p1sys3	
	syscall 3
	dadd $s3, r1, r0 ; contiene il numero di caratteri
	; if(s3<2)
	slti $t0, $s3, 2
	beq $t0, r0, else ; se $s3<2 è vera saltiamo al ramo falso
	; ramo vero
	; printf
	daddi $t0, r0, mess2
	sd $t0, p1sys5(r0)
	daddi r14, r0, p1sys5
	syscall 5
	j for
	else: ; ramo falso
	; somma=0
	daddi $s1, r0, 0
	;i=0
	daddi $s2, r0, 0
	;for(i<dimensione di s3)
	for2: slt $t1, $s2, $s3
		beq $t1, r0, fine_for2
		; &valori[i]=valori+i=valori+$s2
		daddi $t2, $s2, valori ; $t2=&valori[i]
		lbu $t1, 0($t2) ; leggiamo l' elemento valori[i] e lo metto in t1
		;per fare il modulo 16 di un numero prendo il numero e faccio l' and logico con un vettore con i primi 4 bit a 1 e il resto a 0
		andi $t2, $t1, 15 
		dadd $s1, $s1, $t2
		;i++
		daddi $s2, $s2, 1
	j for2
	fine_for2: ; printf(mess2)
j for	
fine:
