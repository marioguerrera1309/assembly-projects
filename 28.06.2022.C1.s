;int calcola(char *st, int d, int val) 
;{ int j,cnt; 
 
 ;   cnt=0; 
 ;   for(j=0;j<d;j++) 
 ;    if(st[j]-48==val) 
 ;cnt++; 
 ;  return cnt; 
;} 
 
;main() { 
 ; char ST[16]; 
 ; int VAL[3]; 
 ; int i,num;      
    
 ;printf("Inserisci una stringa di soli numeri\n"); 
 ;   scanf("%s",ST); 
    
 ;  for(i=0;i<3;i++) 
  ; { 
   ; printf("Inserisci un numero a una cifra"); 
   ; scanf("%d",&num); // usare input_unsigned 
   ; VAL[i]= calcola(ST,strlen(ST),num);  
 ;printf(" V[%d]= %d \n",i,VAL[i]); 
 ;  } 
      
;} 
.data
st: .space 16
val: .space 24

m1: .asciiz "Inserisci una stringa di soli numeri\n"
m2: .asciiz "Inserisci un numero a una cifra"
m3: .asciiz "V[%d]= %d \n"
p1s5: .space 8
val1: .space 8
val2: .space 8

par: .word 0
ind: .space 8
num_byte: .word 16

.code
 ; printf("Inserisci una stringa di soli numeri\n"); 
daddi $t0, $0, m1
sd $t0, p1s5($0)
daddi r14, $0, p1s5
syscall 5 
; scanf("%s",ST); 
daddi $a0, $0, st
sd $a0, ind($0)
daddi r14, $0, par
syscall 3
dadd $a1, $0, r1
; for(i=0;i<3;i++)
daddi $s0, $0, 0 ; i=0
daddi $s3, $0, 8 ; s3=8
for: 	slti $t0, $s0, 3
	beq $t0, $0, fine
	; printf("Inserisci un numero a una cifra"); 
   	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5 
	; scanf("%d",&num); // usare input_unsigned 
	jal input_unsigned
	dadd $a2, $0, r1
	; VAL[i]= calcola(ST,strlen(ST),num);  
 	jal calcola
	mult $s0, $s3 ; i*8
	mflo $t1 ; t1=i*8
	daddi $t0, $t1, val
	sd r1, 0($t0)
	;printf(" V[%d]= %d \n",i,VAL[i]);
	sd $s0, val1($0)
	; sd r1, val2($0)
	mult $s0, $s3 ; i*8
	mflo $t1 ; t1=i*8
	daddi $t0, $t1, val ; t0=val[i]
	lbu $t1, 0($t0) ; t1=*val[i]
	sd $t1, val2($0)
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5  
	daddi $s0, $s0, 1
	j for
fine: syscall 0
calcola: 	daddi $sp, $sp, -16
	sd $s1, 0($sp) ; j
	sd $s2, 8($sp) ; cnt
	daddi $s1, $0, 0
	daddi $s2, $0, 0
	; int calcola(char *st, int d, int val) 
	;{ int j,cnt;  
 	; cnt=0; 
	; for(j=0;j<d;j++) 
	for_f: 	slt $t0, $s1, $a1
		beq $t0, $0, return
 		; if(st[j]-48==val) 
 		dadd $t0, $a0, $s1
		lbu $t1, 0($t0)
		daddi $t0, $t1, -48
		bne $t0, $a2, inc_i
		; cnt++;
		daddi $s2, $s2, 1
inc_i:	daddi $s1, $s1, 1
	j for_f
return: 	dadd r1, $0, $s2
	ld $s1, 0($sp)
	ld $s2, 8($sp)
	daddi $sp, $sp, 16
	jr $ra
.include input_unsigned.s
