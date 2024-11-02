;int elabora(char *vet, int d)
;{ int i,pari;
;pari=0;
;for(i=0;i<d;i++)
;	if(vet[i]%2==0)
;		pari++;
;return pari;
;}

;main() {
;char VAL[32];
;int i,ris,numero;
;for(i=0;i<3;i++) {
;	printf("Inserisci una stringa con almeno 4 caratteri \n");
;	scanf("%s",VAL);
;	if(strlen(VAL)<4)
;	{ printf("Inserisci un numero maggiore di %d \n",strlen(VAL));
;		scanf("%d",&ris);
;	}
;	else
;		ris=elabora(VAL,strlen(VAL));
;	printf(" Ris[%d]= %d \n",i,ris);
;}
.data

p1sy5: .space 8
val1: .space 8
val2: .space 8

m1: .asciiz "Inserisci una stringa con almeno 4 caratteri \n"
m2: .asciiz "Inserisci un numero maggiore di %d \n"
m3: .asciiz " Ris[%d]= %d \n"

VAL:  .space 32

p1sy3: .byte 0
ind3: .space 8
dim3: .byte 32

.code

;for(i=0;i<3;i++) {
	daddi $s3, $0,0  ; i-> $s3
for_m: slti $t0, $s3, 3   ; $t0 !=0 se $s3 <3 ovvero se i <3, 0 altrimenti
	 beq $t0, $0, fine_prog
;	printf("Inserisci una stringa con almeno 4 caratteri \n");
	daddi $t1, $0, m1
	sd $t1, p1sy5($0)
	daddi r14, $0, p1sy5
	syscall 5

;	scanf("%s",VAL);
	daddi $t2, $0, VAL
	sd $t2, ind3($0)
	daddi r14, $0, p1sy3
	syscall 3
	dadd $s1, $0, r1 ; move $s1, r1  		$s1=strlen(VAL)

;	if(strlen(VAL)<4)
; Saltiamo al ramo else quando la condizione e' falsa
	slti $t1, $s1, 4     ; $t1!=0 se strlen(VAL)<4 , $t1=0 se la condizione e' falsa
	beq $t1, $0, else
;	{ printf("Inserisci un numero maggiore di %d \n",strlen(VAL));
	sd $s1, val1($0)

	daddi $t1, $0, m2
	sd $t1, p1sy5($0)
	daddi r14, $0, p1sy5
	syscall 5
;	scanf("%d",&ris);
	jal input_unsigned
	dadd $s0, r1, $0    ; $s0 = ris
	j stampa
;	}
;	else

;		ris=elabora(VAL,strlen(VAL));
else: 		daddi $a0, $0, VAL	
		dadd $a1, $0, $s1   ; $a1 = strlen(VAL)
		jal elabora
		dadd $s0, r1, $0   ; $s0 = ris =elabora(  )
;	printf(" Ris[%d]= %d \n",i,ris);
stampa: 
	sd $s3, val1($0)
	sd $s0, val2($0)
	daddi $t1, $0, m3
	sd $t1, p1sy5($0)
	daddi r14, $0, p1sy5
	syscall 5

incr_i_m:   	daddi $s3, $s3, 1 ; i++
		j for_m	
;}
fine_prog: syscall 0

;int elabora(char *vet, int d)
; vet -> $a0, d -> $a1
elabora: daddi $sp, $sp, -16
	    sd  $s0, 0($sp)
	    sd $s1, 8($sp)
	
	daddi $s0, $0, 0  ;$s0 -> pari=0;
	
;for(i=0;i<d;i++)
	  daddi $s1, $0, 0 ; $s1 -> i =0
for_el:   slt $t0, $s1, $a1  ; $t0 !=0 se i<d, 0 altrimenti
	    beq $t0, $0, return
;	if(vet[i]%2==0)
	; calcoliamo &vet[i]
;	&vet[i]=vet + i = $a0 + $s1
	dadd $t0, $a0, $s1
	; leggiamo vet[i]
	lbu $t1, 0($t0)   ; $t1=vet[i]
; verificare che vet[i]%2 ==0 equivale a verificare che andi $t1, 1 sia uguale a zero
	andi $t2, $t1, 1
; se vet[i]%2!=0  non incrementiamo la variabile pari e incrementiamo solo la var i
	bne $t2, $0, incr
	daddi $s0, $s0, 1 ;		pari++;
	  
incr: 	  daddi $s1, $s1, 1 ;i++
	 j for_el
	
;return pari;
return: dadd r1, $0, $s0

	ld  $s0, 0($sp)
	ld $s1, 8($sp)
	daddi $sp, $sp, 16

	jr $ra

;}

#include input_unsigned.s
