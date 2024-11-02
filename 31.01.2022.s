;int processa(char *st, int d) 
;{ int i; 
     
  ;  for(i=0;i<d;i++) 
    ;   if(st[i]>=58) 
; break; 
 
  ; return i; 
;} 
 
;main() { 
  ;char STRNG[16]; 
  ;int i,val,num;      
                
 ; for(i=0;i<3;i++) { 
  ; do{   printf("Indica quanti caratteri (numeri) vuoi inserire (>=3))\n"); 
   ;      scanf("%d",&num); 
  ; }while(num<3); 
  ; printf("Inserisci la stringa con %d numeri\n",num); 
  ; scanf("%s",STRNG); 
  ; val=processa(STRNG,num);         
   ;printf("Valore= %d \n",val);  
  ;}   
; }
.data
stringa: .space 16

par: .word 0
ind: .space 8
num_byte: .word 16

m1: .asciiz "Indica quanti caratteri (numeri) vuoi inserire (>=3))\n"
m2: .asciiz "Inserisci la stringa con %d numeri\n"
m3: .asciiz "Valore= %d \n"
p1s5: .space 8
val: .space 8

.code
;for(i=0;i<3;i++)
daddi $s0, $0, 0 ; i=0
for: 	slti $t0, $s0, 3
	beq $t0, $0, fine
	; do {    
	do: 
		; printf("Indica quanti caratteri (numeri) vuoi inserire (>=3))\n");
		daddi $t0, $0, m1
		sd $t0, p1s5($0)
		daddi r14, $0, p1s5
		syscall 5
		; scanf("%d",&num);
		jal input_unsigned
		dadd $a1, $0, r1 
		; }while(num<3);
		slti $t0, $a1, 3
		bne  $t0, $0, do
	; printf("Inserisci la stringa con %d numeri\n",num); 
  	sd $a1, val($0)
	daddi $t0, $0, m2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	; scanf("%s",STRNG);
	daddi $a0, $0, stringa
	sd $a0, ind($0)
	daddi r14, $0, par
	syscall 3
	; val=processa(STRNG,num);         
   	jal processa
	; printf("Valore= %d \n",val);  
	sd r1, val($0)
	daddi $t0, $0, m3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5
	daddi $s0, $s0, 1
	j for
fine: syscall 0
processa:	; int processa(char *st, int d)
	daddi $sp, $sp, -8
	sd $s1, 0($sp) ; i
	; for(i=0;i<d;i++)
	daddi $s1, $0, 0 ; i=0
	for_f:	slt $t0, $s1, $a1
		beq $t0, $0, return
		; if(st[i]>=58) 
		dadd $t0, $a0, $s1
		lbu $t1, 0($t0)
		slti $t0, $t1, 58
		beq $t0, $0, return
		; break; 
		daddi $s1, $s1, 1
		j for_f
return: 	dadd r1, $0, $s1
	ld $s1, 0($sp)
	daddi $sp, $sp, 8
	jr $ra
.include input_unsigned.s
