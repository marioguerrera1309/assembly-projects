; int elabora(char *s, int d) 
;{ int i,t,c; 
 
; if(d<2) return -1; 
 
 ;t=0; 
 ;for(i=0;i<d-1;i++) 
 ;      if(s[i]==s[i+1]) 
 ;	t++; 
 
; return t; 
;} 
 
;main() { 
 ; char STR[32]; 
 ; char *a0; 
   
 ; int i,a1,ris;      
    
 ;  for(i=0;i<3; i++)  
 ;    { 
 ;do 
 ;{ 
  ;     printf("%d) Inserisci una stringa con almeno 2 caratteri\n",i);  
    ;   scanf("%s",STR); 
     ;  a1=strlen(STR); 
       
 ;a0=STR; 
; ris=elabora(a0,a1); 
 
 ;printf("Valore= %d \n",ris); 
 
 ;}while(ris<0); 
 
; } 
;} 
.data
str: .space 32

par: .word 0
ind: .space 8
num_byte: .word 32

m1: .asciiz "%d Inserisci una stringa con almeno 2 caratteri\n"
m2: .asciiz "Valore= %d \n"
p1s5: .space 8
val: .space 8

.code
;  for(i=0;i<3; i++)
daddi $s0, $0, 0 ; i=0
for: 	slti $t0, $s0, 3
	beq $t0, $0, fine
	do: 	sd $s0, val($0)
		; printf("%d) Inserisci una stringa con almeno 2 caratteri\n",i);
		daddi $t0, $0, m1
		sd $t0, p1s5($0)
		daddi r14, $0, p1s5
		syscall 5
		; scanf("%s",STR); 
		daddi $a0, $0, str
		sd $a0, ind($0)
		daddi r14, $0, par
		syscall 3
		dadd $a1, $0, r1
		jal elabora
		dadd $s1, $0, r1
		sd $s1, val($0)
		; printf("Valore= %d \n",ris);
		daddi $t0, $0, m2
		sd $t0, p1s5($0)
		daddi r14, $0, p1s5
		syscall 5
		; while(ris<0)
		slti $t0, $s1, 0
		bne $t0, $0, do
	daddi $s0, $s0, 1
	j for
fine: syscall 0
elabora:	daddi $sp, $sp, -16
	sd $s2, 0($sp) ; i
	sd $s3, 8($sp) ; t
	; int elabora(char *s, int d)
	; if(d<2) return -1;
	slti $t0, $a1, 2
	beq $t0, $0, falso
	daddi r1, $0, -1
	j return
falso: 	daddi $s2, $0, 0
	daddi $s3, $0, 0
	; for(i=0;i<d-1;i++) 
	daddi $s4, $a1, -1
	for_f: 	slt $t0, $s2, $s4
		beq $t0, $0, fine_for
		 ; if(s[i]==s[i+1]) 
 		; t++; 
		dadd $t1, $a0, $s2 ; t1 = s + i
		lbu $t2, 0($t1) 
		dadd $t3, $a0, $s2 ; t1 = s + i
		daddi $t3, $t3, 1 ; t1 = s + i + 1 
		lbu $t4, 0($t3) 
		beq $t2, $t3, falso_2
		daddi $s3, $s3, 1
	falso_2:	daddi $s2, $s2, 1
		j for_f  
fine_for: 	dadd r1, $0, $s3
return:	ld $s2, 0($sp)
	ld $s3, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
