;int calcola(char *s, int d,int num) 
;{ int j,f; 
 
;if(num==1) return 1; 
 
;f=1; 
     ;for(j=0;j<d;j++) 
       ;   if(s[j] -48 < num ) 
 ;f=f*(s[j]-48); 
  ; return f; 
;} 
 
;main() { 
  ;char NUM[8]; 
  ;int i,val,ris;      
    
    
 ;printf("Inserisci una stringa di soli numeri \n"); 
  ;   scanf("%s",NUM); 
    ; for(i=0; i<strlen(NUM);i++) 
     ;{ 
 
     ;printf("Inserisci un numero ad una cifra"); 
     ;scanf("%d",&val); 
     
     ;ris= calcola(NUM, strlen(NUM),val);        
     
 ;printf(" Valore= %d \n",ris); 
  ;}  
;} 
.data
num: .space 8

m1: .asciiz "Inserisci una stringa di soli numeri \n"
m2: .asciiz "Inserisci un numero ad una cifra"
m3: .asciiz "Valore= %d \n"
p1s5: .space 8
num1: .space 8

par: .word 0
ind: .space 8
num_byte: .word 8

.code

;printf("Inserisci una stringa di soli numeri \n"); 
daddi $t0, $0, m1
sd $t0, p1s5($0)
daddi r14, $0, p1s5
syscall 5
;scanf("%s",NUM); 
daddi $t0, $0, num
sd $t0, ind($0)
daddi r14, $0, par
syscall 3
dadd $s0, $0, r1 ; $s0=strlen(num)
;for(i=0; i<strlen(NUM);i++)
daddi $s1, $0, 0 ; $s1=i=0
for: 	slt $t0, $s1, $s0 ; se $s1<$s0 (i<strlen(num)) -> $t0!=0
	beq $t0, $0, fine
       	;printf("Inserisci un numero ad una cifra"); 
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5	
	;scanf("%d",&val);
       	jal input_unsigned
	dadd $s2, $0, r1
	 ;ris= calcola(NUM, strlen(NUM),val);
	daddi $a0, $0, num
	dadd $a1, $0, $s0
	dadd $a2, $0, $s2
	jal calcola	
	;printf(" Valore= %d \n",ris); 
	sd r1, num1($0) 
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5	
	daddi $s1, $s1, 1 ; i++
       	j for
fine: syscall 0  
calcola:	
	; daddi $s5, $0, 48
	daddi $sp, $sp, -16
	sd $s3, 0($sp) ; j
	sd $s4, 8($sp) ; f
	;int calcola(char *s, int d,int num) 
	;{ int j,f; 
 	;if(num==1) return 1;
	daddi $t0, $0, 1 
 	beq $a2, $t0, vero 
	;f=1;
	daddi $s4, $0, 1
	daddi $s3, $0, 0
	;for(j=0;j<d;j++)
	for_f: slt $t0, $s3, $a1 ; j<d -> $t0!=0
		beq $t0, $0,  fine_for 
		dadd $t1, $a0, $s3
		lbu $t2, 0($t1) 
		daddi $t3, $t2, -48 
		;if(s[j] -48 < num )
		slt $t0, $t2, $a2 ; s[j] -48 = $t2 < num
		beq $t0, $0, for_f  
	 	;f=f*(s[j]-48); 
		mult $s4, $t2
		mflo $s4
		daddi $s3, $s3, 1 ; j++
		j for_f
	fine_for: dadd r1, $0, $s4
  	; return f; 
	;}
	j return  
	vero: daddi r1, $0, 1
	j return
return: 
ld $s1, 0($sp)
ld $s2, 8($sp)
daddi $sp, $sp, 16
jr $ra
.include input_unsigned.s
