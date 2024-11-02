;int confronta(char *st1, char *st2,int d) 
;{ int j,cnt; 
 
    ;cnt=0; 
    ;for(j=0;j<d;j++) 
     ;if(st1[j]==st2[j]) 
 ;cnt++; 
  ; return cnt; 
;} 
 
;main() { 
  ;char ST1[16],ST2[16]; 
  ;int i,num,ris;      
     
 
   ;for(i=0;i<3;i++) 
   ;{ 
 ;printf("Inserisci una stringa\n"); 
  ;  scanf("%s",ST1);   
    ;printf("Inserisci una stringa\n");  
    ;// Si assuma di inserire una stringa con almeno lo stesso numero di 
;caratteri della prima stringa 
  ;  scanf("%s",ST2); 
    
   ; ris= confronta(ST1,ST2,strlen(ST1));  
    ;printf("Il numero di caratteri uguali nella stessa posizione e' %d 
;\n",ris);       
  ; } 
    
;} 
.data
st1: .space 16
st2: .space 16

par: .word 0
ind: .space 8
num_byte: .word 16

m1: .asciiz "Inserisci una stringa\n"
m2: .asciiz "Il numero di caratteri uguali nella stessa posizione e' %d "
m3: .asciiz "Carattere %d=%d\n"
p1s5: .space 8
val: .space 8
val1: .space 8

.code
; for(i=0;i<3;i++)
daddi $s0, $0, 0 ; i=0
for: slti $t0, $s0, 3 ; $t0!=0 se $t0<3
	beq $t0, $0, fine
	; printf("Inserisci una stringa\n");
	daddi $t1, $0, m1
	sd $t1, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%s",ST1);
	daddi $a0, $0, st1
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	dadd $a2, $0, r1 ; strlen(ST1)
	; daddi $a0, $0, st1 ; salvo st1 in a0
	; printf("Inserisci una stringa\n");
	daddi $t1, $0, m1
	sd $t1, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%s",ST2);
	daddi $a1, $0, st2
	sd $a1, ind($0)
	daddi r14, $0, par
	syscall 3
	; daddi $a1, $0, st2 ; salvo st2 in a1
	 ; ris= confronta(ST1,ST2,strlen(ST1));
	; a0=st1 a1=st2 a2=strlen(st1)
	jal confronta
	; printf("Il numero di caratteri uguali nella stessa posizione e' %d 
;\n",ris);
	dadd $t1, $0, r1
	sd $t1, val($0)
	daddi $t1, $0, m2
	sd $t1, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1 ; i++
	j for
fine: syscall 0
confronta:    daddi $sp, $sp, -16
	sd $s1, 0($sp) ; j
	sd $s2, 8($sp) ; count
	;int confronta(char *st1, char *st2,int d)
	; count=0
	daddi $s2, $0, 0
	; j=0
	daddi $s1, $0, 0
	; for(j=0;j<d;j++)
	for_f: 	slt $t0, $s1, $a2
		beq  $t0, $0, return
		; if(st1[j]==st2[j])
		dadd $t2, $a0, $s1 ; $t2=st1[j]
		lbu $t4, 0($t2)
		dadd $t3, $a1, $s1 ; $t3=st2[j]
		lbu $t5, 0($t3)
		bne $t4, $t5,  falso
		sd $t4, val($0)
		sd $t5, val1($0)
		daddi $t1, $0, m3
		sd $t1, p1s5($0)
		daddi r14, $0, p1s5
		syscall 5
		daddi $s2, $s2, 1
	falso: daddi $s1, $s1, 1
	j for_f
return:	
	dadd r1, $0, $s2
	ld $s1, 0($sp)
	ld $s2, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
