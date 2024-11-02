;int processa(char *num, int d) 
;{ int i,somma; 
 ;   somma=0; 
  ;  for(i=0;i<d;i++) 
    ;   somma=somma+ num[i]-48;  
 
;   return somma; 
;} 
 
;main() { 
  ;char NUMERO[16]; 
  ;int i,val;      
                
  ;for(i=0;i<4;i++) { 
  ; printf("Inserisci una stringa con soli numeri\n"); 
  ; scanf("%s",NUMERO); 
  ; if(strlen(NUMERO)<2) 
 ;val=NUMERO[0]-48; 
  ; else val=processa(NUMERO,strlen(NUMERO));        
 ; printf(" Valore= %d \n",val);  
 ; }   
;} 
.data
numero: .space 16

par: .word 0
ind: .space 8
num_byte: .word 16

m1: .asciiz "Inserisci una stringa con soli numeri\n"
m2: .asciiz "Valore=%d\n"
p1s5: .space 8
val: .space 8

.code
; for(i=0;i<4;i++)
daddi $s0, $0, 0 ; i=0
for: 	slti $t0, $s0, 4
	beq $t0, $0, fine
	; printf("Inserisci una stringa con soli numeri\n"); 
  	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%s",NUMERO);
	daddi $a0, $0, numero
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3	
	dadd $a1, $0, r1
	; if(strlen(NUMERO)<2)
	slti $t0, $a1, 2
	beq $t0, $0, falso
	daddi $t0, $0, numero
	lbu $s1, 0($t0)
	daddi $s1, $s1, -48
	j stampa
falso: 	jal processa
	dadd $s1, $0, r1
stampa:	sd $s1, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5  
	daddi $s0, $s0, 1
	j for
fine: syscall 0
processa: 	; int processa(char *num, int d)
	daddi $sp, $sp, -16
	sd $s2, 0($sp) ; i
	sd $s3, 8($sp) ; somma
	daddi $s2, $0, 0
	daddi $s3, $0, 0
	; for(i=0;i<d;i++) 
	for_f:	slt $t0, $s2, $a1
		beq $t0, $0, return
		; somma=somma+ num[i]-48;
		dadd $t0, $a0, $s2
		lbu $t1, 0($t0)
		daddi $t1, $t1, -48
		dadd $s3, $s3, $t1
		daddi $s2, $s2, 1
		j for_f
    	; somma=somma+ num[i]-48;  
return:	dadd r1, $0, $s3
	ld $s2, 0($sp)
	ld $s3, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
