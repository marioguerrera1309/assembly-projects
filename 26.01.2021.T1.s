;int processa(char *num, int d) 
;{ int i,somma; 
  ;  somma=0; 
   ; for(i=0;i<d;i++) 
    ;   somma=somma+ num[i]-48;  
 
   ;return somma; 
;} 
 
;main() { 
 ; char NUMERO[16]; 
 ; int i,val;      
                
 ; for(i=0;i<4;i++) { 
 ;  printf("Inserisci una stringa con soli numeri\n"); 
  ; scanf("%s",NUMERO); 
   ;if(strlen(NUMERO)<2) 
 ;val=NUMERO[0]-48; 
 ;  else val=processa(NUMERO,strlen(NUMERO));        
 ; printf(" Valore= %d \n",val);  
 ; }   
;} 
.data
numero: .space 16

m1: .asciiz "Inserisci una stringa con soli numeri\n"
m2: .asciiz "Valore= %d \n"
p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 16

.code
daddi $s0, $0, 0 ; i=0
; for(i=0;i<4;i++) {
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
	dadd $s1, $0, r1 ; s1=strlen(numero)
	; if(strlen(NUMERO)<2)
	slti $t0, $s1, 2
	beq $t0, $0, else
	; val=NUMERO[0]-48;
	daddi $t0, $0, numero
	lbu $t1, 0($t0)
	daddi $s2, $t1, -48
	j incr_i
else: 	dadd $a1, $0, $s1
	jal processa
	dadd $s2, $0, r1
incr_i:	sd $s2, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	j for
fine: syscall 0
processa:	daddi $sp, $sp, -16
	sd $s3, 0($sp) ; i
	sd $s4, 8($sp) ; somma
	; int processa(char *num, int d)
	; somma=0; 
	daddi $s3, $0, 0
	daddi $s4, $0, 0
   	; for(i=0;i<d;i++)
	for_f: 	slt $t0, $s3, $a1 
		beq $t0, $0, return
		; somma=somma+ num[i]-48;
		dadd $t0, $s3, $a0
		lbu $t1, 0($t0)
		daddi $t2, $t1, -48
		dadd $s4, $s4, $t2
		daddi $s3, $s3, 1
		j for_f
return: 	dadd r1, $0, $s4
	ld $s3, 0($sp)
	ld $s4, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
