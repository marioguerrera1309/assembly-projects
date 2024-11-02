;int calcola(char *s, int d) 
;{ int i,t; 
 
; t=0; 
 ;for(i=0;i<d;i++) 
 ;      t=t+s[i]%16; 
 ;return t; 
;} 
 
;main() { 
 ;char SNUM[32]; 
 ;int i,cont,valore;      
    
; for(i=0;i<4; )  
 ;{printf("Inserisci una stringa (numeri) con almeno 2 caratteri\n");  
 ; scanf("%s",SNUM); 
 ; if(strlen(SNUM)<2) 
  ;   { 
 ;printf("Pochi caratteri. Vuoi continuare?\n (1=si,0=no)"); 
 ;scanf("%d",&cont); 
 ;if(cont==0) 
 ;i=4; // fine esecuzione 
 ;} 
  ; else { valore=calcola(SNUM,strlen(SNUM)); 
 ;printf(" Valore= %d \n",valore); 
 ;i++; 
 ;} 
 ;} 
;} 
.data

snum: .space 32

m1: .asciiz "%d) inserisci una stringa (numeri) con almeno 2 caratteri\n"
m2: .asciiz "Pochi caratteri. Vuoi continuare?\n (1=si,0=no)"
m3: .asciiz "Valore= %d \n"
p1s5: .space 8
val: .space 8

par: .word 0
ind: .space 8
num_byte: .word 32

.code
daddi $s0, $0, 0 ; i=0
; for(i=0;i<4; )
for: 	slti $t0, $s0, 4
	beq $t0, $0, fine
	; printf("%d) inserisci una stringa (numeri) con almeno 2 caratteri\n");
	sd  $s0, val($0)
	daddi $t0, $0, m1
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%s",SNUM)
	daddi $a0, $0, snum
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	dadd $a1, $0, r1
	;  if(strlen(SNUM)<2)
	slti $t0, $a1, 2
	beq $t0, $0, else
	; printf("Pochi caratteri. Vuoi continuare?\n (1=si,0=no)"); 
 	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%d",&cont); 
	jal input_unsigned
	dadd $t0, $0, r1
 	; if(cont==0) 
	beq $t0, $0, fine
 	; i=4; // fine esecuzione
	j for
else:	jal calcola
	; printf(" Valore= %d \n",valore); 
	sd r1, val($0)
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
 	; i++;
	daddi $s0, $s0, 1
	j for
fine: syscall 0
calcola:	daddi $sp, $sp, -16
	sd $s1, 0($sp) ; i
	sd $s2, 8($sp) ; t
	; int calcola(char *s, int d)
	daddi $s1, $0, 0
	daddi $s2, $0, 0
	daddi $s3, $0, 16
	; for(i=0;i<d;i++)
	for_f:	slt $t0, $s1, $a1
		beq  $t0, $0, return
 		; t=t+s[i]%16;
		dadd $t0, $a0, $s1 ; s[i]
		lbu $t1, 0($t0)
		ddiv $t1, $s3
		mfhi $t1
		dadd $s2, $s2, $t1
		daddi $s1, $s1, 1
		j for_f
return:	dadd r1, $0, $s2
	ld $s1, 0($sp)
	ld $s2, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
.include input_unsigned.s
