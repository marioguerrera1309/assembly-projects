;int esegui(char *s, int n)
;{ int i,t;
;t=0;
;for(i=0;i<n;i++)
;t=t+s[i]%4;
;return t;
;}
;main() {
;char STRINGA[8];
;int i,valore;
;int num;
;i=0;
;while(i<3)
;printf("Inserisci il numero minimo caratteri da inserire\ n");
;scanf("%d",&num);
;printf("Inserisci una stringa con almeno %d caratteri \n",num);
;scanf("%s",STRINGA);
;if(strlen(STRINGA)<num)
;{ printf("Stringa di dimensione sbagliata. Fine \n");
;i=3;
;else {valore= esegui(STRINGA,num);
;printf(" Risultato= %d \n",valore);
;i++;
;}

.data
m1: .asciiz "Inserisci il numero minimo caratteri da inserire \n"
m2: .asciiz  "Inserisci una stringa con almeno %d caratteri \n"
m3: .asciiz "Stringa di dimensione sbagliata. Fine \n"
m4: .asciiz " Risultato= %d \n"

p1s5: .space 8
p2s5: .space 8

p1s3: .word 0
inds3: .space 8
dims3: .word 8

STRINGA: .space 8

.code
; i-> $s1

	daddi $s1, $0, 0  ;i=0;
;while(i<3)
while:   slti $t0, $s1, 3	 ;$t= 0 se la condizione i<3 e' falsa
	  beq $t0, $0, fine
;printf("Inserisci il numero minimo caratteri da inserire n");

	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	
;scanf("%d",&num);
	jal input_unsigned
	dadd $a1, $0, r1	; $a1= num

;printf("Inserisci una stringa con almeno %d caratteri n",num);
	sd $a1, p2s5($0)

	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

;scanf("%s",STRINGA);
	daddi $a0, $0, STRINGA
	sd $a0, inds3($0)
	daddi r14, $0, p1s3
	syscall 3
	dadd $s2, $0, r1  ; $s2=strlen(STRINGA)

;if(strlen(STRINGA)<num)
	slt $t1, $s2, $a1 ; $t1==0 se la condizione strlen(STRINGA)<num e' falsa
	beq $t1, $0, else   ; saltiamo al ramo else se la condizione e' falsa
;	{ printf("Stringa di dimensione sbagliata. Fine n");
	
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	  
	daddi $s1, $0, 3  ;	i=3;
	j while
;	}
;else {
;	valore= esegui(STRINGA,num);
;       i 2 parametri $a0, $a1 sono stati inizializzati in precedenza
else:   jal esegui

;        printf(" Risultato= %d n",valore);
	sd r1, p2s5($0)

	daddi $t0, $0, m4
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

        daddi $s1, $s1, 1 ;i++;
      
salto:        j while     
;}                                       

;}
fine: syscall 0


;int esegui(char *s, int n)
; s-> $a0, n -> $a1
esegui: daddi $sp, $sp, -16
	sd $s0, 0($sp)
	sd $s1, 8($sp)

;t->  $s0
; i-> $s1

	daddi $s0, $0, 0 ;t=0;
;for(i=0;i<n;i++)
	daddi $s1, $0, 0  ; i=0
for_f:   slt $t0, $s1, $a1
	  beq $t0, $0, return 

;t=t+s[i]%4;
	; calcoliamo &s[i]= s + i = $a0+ $s1
	dadd $t0, $a0, $s1

;	leggiamo s[i]
	lbu $t1, 0($t0)	; $t1 = s[i]

; calcoliamo s[i]%4
; possiamo calcolare tale valore applicando al registro $t1 (s[i] ) una maschera con tutti i bit a 0 tranne i 2 bit meno significativi che valgono 1
	 andi $t2, $t1, 3  ; $t2 = s[i]%4

	dadd $s0, $s0, $t2   ; $s0 = t + s[i]%4

	  daddi $s1, $s1, 1 ; i++
	 j for_f

;return t;
return:   dadd r1, $0, $s0

	    ld $s0, 0($sp)
	    ld $s1, 8($sp)	
	   daddi $sp, $sp, 16

	jr $ra
;}

#include input_unsigned.s
