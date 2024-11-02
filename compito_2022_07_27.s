;int elabora(char *op1, char *op2, int d)
;{ int j,somma;
;somma=0;
;for(j=0;j<d;j++)
;somma = somma + op1[j] op2[j];
;return somma;
;}
;main() {
;char OP1[16 ],OP2[16];
;int i,dim,ris;
;for(i=0;i<3;i++)
;printf("Inserisci una prima stringa di soli numeri \n");
;scanf("%s",OP1);
;printf("Inserisci una seconda stringa di soli numeri \n");
;scanf("%s",OP2);
;dim=strlen(OP1);
;if(strlen(OP2)<strlen(OP1))
;dim=strlen(OP2);
;ris= elabora(OP1,OP2,dim);
;printf("Risultato=' %d \n",ris);
;}
;}
.data
OP1: .space 16
OP2: .space 16

st1: .asciiz "Inserisci una prima stringa di soli numeri \n"
st2: .asciiz "Inserisci una seconda stringa di soli numeri \n"
st3: .asciiz "Risultato=' %d \n"

p1s3: .word 0
ind3: .space 8
dim3: .word 16

p1s5: .space 8
ris: .space 8

.code

;for(i=0;i<3;i++)
	daddi $s0, $0, 0
for: 	slti $t0, $s0, 3 ; $t=0 se la condizione i<3 e' falsa
	beq $t0, $0, fine_esec
;printf("Inserisci una prima stringa di soli numeri n");
	daddi $t0, $0, st1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

;scanf("%s",OP1);
	daddi $a0, $0, OP1
	sd $a0, ind3($0)
	daddi r14, $0, p1s3
	syscall 3

	dadd $s1, $0, r1  ; $s1 = strlen(OP1)

;printf("Inserisci una seconda stringa di soli numeri n");
	daddi $t0, $0, st2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

;scanf("%s",OP2);
	daddi $a1, $0, OP2
	sd $a1, ind3($0)
	daddi r14, $0, p1s3
	syscall 3

	dadd $s2, $0, r1  ; $s2 = strlen(OP2)

;dim=strlen(OP1);
	dadd $a2, $0, $s1  ; $a2 = $s1 =dim = strlen(OP1);
;if(strlen(OP2)<strlen(OP1))
  ; se la condizione strlen(OP2)<strlen(OP1) e' falsa saltiamo alla funzione elabora
	slt $t1, $s2, $s1   ; $t1 == 0 se la condizione strlen(OP2)<strlen(OP1) e' falsa
	beq $t1, $0, chiama_elabora
;dim=strlen(OP2);
	dadd $a2, $0, $s2  ; ; $a2 = $s2 =dim = strlen(OP2);

;ris= elabora(OP1,OP2,dim);
; i 3 parametri della funzione elabora sono stati inizializzati prima
chiama_elabora:   jal elabora

	;printf("Risultato=' %d n",ris);
		sd r1, ris($0)

	daddi $t0, $0, st3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
;}
	daddi $s0, $s0, 1 ; i++
	j for
;}

fine_esec: syscall 0



;int elabora(char *op1, char *op2, int d)
; op1 -> $a0, op -> $a1, d- > $a2
; somma -> $s0
; j -> $s1
elabora: daddi $sp, $sp, -16
	     sd $s0, 0($sp)
	     sd $s1, 8($sp)

	daddi $s0, $0, 0 ;somma=0;
;for(j=0;j<d;j++)
	daddi $s1, $0, 0 ; j=0
for_el:     slt $t0, $s1, $a2   ; $t0==0 se la condizione j<d e' falsa
	     beq $t0, $0, return_s

;somma = somma + op1[j] - op2[j];
		; &op1[j]= op1 + j = $a0 + $s1
		dadd $t1, $a0, $s1
		lbu $t2, 0($t1)   ; $t2 = op1[j]
		
		dadd $s0, $s0, $t2 ;  $s0 = somma + op1[j]

		; &op2[j]= op2 + j = $a1 + $s1
		dadd $t3, $a1, $s1
		lbu $t4, 0($t3)   ; $t4 = op2[j]

		dsub $s0, $s0, $t4   ; $s0 = somma + op2[j]


		
	     daddi $s1, $s1, 1  ; j++
	     j for_el

;return somma;
return_s:      dadd r1, $0, $s0
 		ld $s0, 0($sp)
	     	ld $s1, 8($sp)
		daddi $sp, $sp, 16

		jr r31 
		
;}
