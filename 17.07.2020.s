; 4. int somma_numeri(char *st, int d) 
;{   int i,somma; 
  ;  somma=0; 
    ;for(i=0;i<d;i++) 
    ;  {if(st[i]<58) 
; somma++; 
; else return -1; 
 ;}   
 ;  return somma; 
;} 
 
;main() { 
 ; char ST[16]; 
 ; int i,cnt;      
                
 ; for(i=0;i<2;i++){ 
 ;  printf("Inserisci una stringa di numeri)\n"); 
  ; scanf("%s",ST); 
  ; cnt=somma_numeri(ST,strlen(ST));        
  ; printf(" Numero= %d \n",cnt);  
  ;} 
   
;} 
.data 

st: .space 16

m1: .asciiz "Inserisci una stringa di numeri\n"
m2: .asciiz "Numero=%d\n"
p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 16

.code
; for(i=0;i<2;i++){ 
daddi $s0, $0, 0 ; i=0
for:	slti $t0, $s0, 2
	beq $t0, $0, fine
	; printf("Inserisci una stringa di numeri)\n"); 
	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%s",ST);
	daddi $a0, $0, st
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	dadd $a1, $0, r1 ; a1=strlen(ST)
	; cnt=somma_numeri(ST,strlen(ST));
	jal somma_numeri
  	; printf(" Numero= %d \n",cnt);
	sd r1, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5  
	daddi $s0, $s0, 1
	j for
fine: syscall 0
somma_numeri:
	; int somma_numeri(char *st, int d)
	daddi $sp, $sp, -16
	sd $s0, 0($sp) ; i
	sd $s1, 8($sp) ; somma
	daddi $s0, $0, 0
	daddi $s1, $0, 0
	; for(i=0;i<d;i++)
	for_f: 	slt $t0, $s0, $a1
		beq $t0, $0, fine_f
		; if(st[i]<58) 
		dadd $t0, $a0, $s0 ; $t0=st[i]	
		lbu $t1, 0($t0)
		slti $t2, $t1, 58
		beq $t2, $0, falso
		; somma++; 
		daddi $s1, $s1, 1
		daddi $s0, $s0, 1
		j for_f
falso: 	daddi r1, $0, -1
	j return
fine_f: 	dadd r1, $0, $s1
return: 
	daddi $sp, $sp, 16
	ld $s0, 0($sp)
	ld $s1, 8($sp)
	jr $ra
