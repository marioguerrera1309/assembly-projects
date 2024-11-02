;printf("Inserisci una stringa");
;scanf("%s", stringa);
;somma=0
;for(i=0; i<strlen(buffer); i++)
; somma=somma+buffer[i]-48
.data
mess: .asciiz "Inserisci una stringa"
arg_printf: .space 8
descriptor: .word 0 ;stdin
ind: .space 8
dim: .word 16
buffer: .space 16
somma: .space 8
.code
;printf
daddi $t0, r0, mess
sd $t0, arg_printf(r0)
daddi r14, r0, arg_printf
syscall 5
;scanf
daddi $t0, r0, buffer
sd $t0, ind(r0)
daddi r14, r0, descriptor
syscall 3
dadd $s0, r1, r0 ; s0=r1
daddi $s2, r0, 0 ; somma=0
;for
daddi $s1, r0, 0 ; i=0
; i<strlen(buffer)
for: slt $t0, $s1, $s0 ; i< di s0 che contiene r0 che contiene la lunghezza del buffer letto da tastiera
	beq $t0, r0, fine
	daddi $s1, $s1, 1
	; codice del for
	daddi $t1, $s1, buffer ; t1=buffer +s1
	lbu $t2, 0($t1) ; il puntatore è $t1 quindi mettiamo 0()
	daddi $t2, $t2, -48
	dadd $s2, $s2, $t2 ; somma=somma+buffer[i]
	daddi $s1, $s1, 1 ; i++
	; fine codice for	
	j for 
fine: 
sd $s2, somma(r0)

syscall 0
