;int elabora(char *s, int d)
;{ int i,t,c;
;	if(d<2) return -1;
;		t=0;
;	for(i=0;i<d-1;i++)
;		if(s[i]==s[i+1])
;			t++;
;	return t;
;}

;main() {
;char STR[32];
;char *a0;
;int i,a1,ris;
;  for(i=0;i<3; i++)
;   do {
;	printf("%d) Inserisci una stringa con almeno 2 caratteri \n",i);
;	scanf("%s",STR);
;	a1=strlen(STR);
;	a0=STR;
;	ris=elabora(a0,a1);
;	printf(" Valore= %d \n",ris);
; }while(ris<0);
;}
.data
p1sys3: .byte 0
indsys3: .space 8
dim3: .byte 32

STR: .space 32

msg1: .asciiz "%d) Inserisci una stringa con almeno 2 caratteri \n"
msg2: .asciiz " Valore= %d \n"

p1sys5: .space 8
p2sys5: .space 8


.code

;  for(i=0;i<3; i++)
	daddi $s5, $0, 0 ; $s5 -> i =0
for:    slti $t5, $s5, 3  ; $t5 !=0 se $s5 < 3 ovvero se i <3
	beq $t5, $0, fine
;   do { printf("%d) Inserisci una stringa con almeno 2 caratteri \n",i);
do: 	sd $s5, p2sys5($0)

	daddi $t1, $0, msg1
	sd $t1, p1sys5($0)
	daddi r14, $0, p1sys5
	syscall 5

;	scanf("%s",STR);
	daddi $t1, $0, STR
	sd $t1, indsys3($0)
	daddi r14, $0, p1sys3
	syscall 3

;	a1=strlen(STR);
	dadd $a1, $0, r1
;	a0=STR;
	daddi $a0, $0, STR
;	ris=elabora(a0,a1);
	jal elabora
	dadd $s1, $0, r1  ; $s1 -> ris
;	printf(" Valore= %d \n",ris);
	sd $s1, p2sys5($0)

	daddi $t1, $0, msg2
	sd $t1, p1sys5($0)
	daddi r14, $0, p1sys5
	syscall 5
	
; }while(ris<0);
	slti $t1, $s1, 0  ; $t1 !=0 se ris <0
	bne $t1, $0, do

incr_i: 	daddi $s5, $s5, 1  ; i++
		j for	
fine: syscall 0

;int elabora(char *s, int d)
; s -> $a0, d -> $a1
elabora:  daddi $sp, $sp, -16
	      sd $s1, 0($sp)
	      sd $s2, 8($sp)
; $s1 -> t
;$s2 -> i
	
;	if(d<2) return -1;
	slti $t1, $a1, 2
;	se la condizione d<2 e' falsa ovvero se $t1==0  salto alla sequenza del ciclo for
; sel la condizione d<2 e0  vera poniamo $s1 = -1 e saltiamo a retun
	beq $t1, $0, stringa_valida 
	daddi $s1, $0, -1
	j return
	
stringa_valida:    daddi $s1, $0, 0  ; t=0
;	for(i=0;i<d-1;i++)
	daddi $s2, $0, 0 ; i=0
	daddi $a1, $a1, -1   ; $a1 = d-1
for_f:	slt $t1, $s2, $a1
	beq $t1, $0, return
;		if(s[i]==s[i+1])
	; &s[i] = s + i = $a0 + $s2
	dadd $t1, $a0, $s2   ; $t1 = &s[i]
	; leggiamo s[i]
	lbu $t2, 0($t1)   ; $t2 = s[i]

;          &s[i+1]  = s + 1 +1  = & s[i] +1 
;	leggiamo s[i+1] 
	lbu $t3, 1($t1)
 ; se s[i]!=s[i+1]  eseguiamo solo incremento della variabile i
	bne $t2, $t3, incr_i_f
; se s[i]==s[i+1] non facciamo il salto ed eseguiamo sia t++ sia i++
	daddi $s1, $s1, 1 ;			t++;

incr_i_f:  daddi $s2, $s2, 1  ; i++
	j for_f	

;	return t;
return:       dadd r1, $0, $s1

	     ld $s1, 0($sp)
	     ld $s2, 8($sp)	
 	    daddi $sp, $sp, 16

	     jr $ra
;}
