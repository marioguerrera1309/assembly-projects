;int elabora(char *st, int num)
;{ int s0,s1;

 ; s0=0;
 ; for(s1=0;s1<num;s1++)
;	 s0=s0+st[s1]-48;

 ; return s0;
;}

;main() {
 ; char STR[16];
 ; int val,i,a;     
   
  ;   for(i=0;i<3;i++) {
		
; printf("Inserisci una stringa contenente solo numeri\n");
 ;    scanf("%s",STR);
;	 printf("Inserisci un numero minore di %d\n",strlen(STR));
 ;    scanf("%d",&a);
  ;   if(a<strlen(STR))
   ;   {val= elabora(STR,a);
    ;   printf(" Val = %d \n",val); 
 ;}

;
 ;   }  
;}
.data
STR: .space 16
msg1:  .asciiz "Inserisci una stringa contenente solo numeri\n"
msg2: .asciiz "Inserisci un numero minore di %d\n"
msg3: .asciiz " Val = %d \n"

p1s5:  .space 8
val: .space 8

p1s3: .word 0
ind3: .space 8
dim3: .word  16

stack: .space 32

.code
daddi $sp, $0, stack
daddi $sp, $sp, 32


 ;   for(i=0;i<3;i++) {
	daddi $s0, $0, 0 ; i=0
for:  slti $t0, $s0, 3		
	beq $t0, $0, fine_for
; printf("Inserisci una stringa contenente solo numeri\n");
	daddi $t1, $0, msg1
	sd $t1, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

 ;    scanf("%s",STR);
	daddi $t1, $0, STR
	sd $t1, ind3($0)
	daddi r14, $0, p1s3
	syscall 3
	move $s1, r1

;	 printf("Inserisci un numero minore di %d\n",strlen(STR));
	daddi $t1, $0, msg2
	sd $t1, p1s5($0)
	sd $s1, val($0)
	daddi r14, $0, p1s5
	syscall 5

 ;    scanf("%d",&a);
	jal input_unsigned

  ;   if(a<strlen(STR))
	slt $t1, r1, $s1
	beq $t1, $0, incr    ; saltiamo a incr se la condizione a<strlen(STR) e' falsa

   ;   {val= elabora(STR,a);
	daddi $a0,$0, STR
	move  $a1, r1
	jal elabora

    ;   printf(" Val = %d \n",val); 
	sd r1, val($0)
	daddi $t1, $0, msg3
	sd $t1, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
; }
incr:	daddi $s0, $s0, 1 ; i++
	j for
 ;}
fine_for: syscall 0


;{ int s0,s1;


;int elabora(char *st, int num)
; $a0=st, $a1= num
elabora:  daddi $sp, $sp, -16
	     sd $s0, 0($sp)
	   sd $s1, 8($sp)
 
; s0=0;
	daddi $s0, $0, 0  ; s0=0
	daddi $s1, $0, 0 ; s1=0

 ; for(s1=0;s1<num;s1++)
forf:   slt $t0, $s1,  $a1
	beq $t0, $0, return

;	 s0=s0+st[s1]-48;
	;&st[s1]= st + s1 = $a0 + $s1
	dadd $t1, $a0, $s1
	lbu $t2, 0($t1)    ; $t2 = st[s1]
	daddi $t2, $t2, -48
	dadd $s0, $s0, $t2 ;  s0=s0+st[s1]-48;

	daddi $s1, $s1, 1   ; s1++
	j forf
 ; return s0;
return: move r1 , $s0

	     ld $s0, 0($sp)
	     ld $s1, 8($sp)
	    daddi $sp, $sp, 16
	 
	  jr $ra
	
;}
#include input_unsigned.s
