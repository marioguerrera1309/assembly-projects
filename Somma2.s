;int vett[5]={4, 7, 2, 8, 5};
; indirizzo dell' elemento vett[i]: &vett[i]= vett+ i*dimensione_elemento;
; somma=0;
; i=0;
;while(i<5)
;{ somma= somma+vett[i]; 
;  i++;
; }
; se i<5 vera non facciamo salti perchè dobbiamo eseguire dopo il while
; se i<5 falsa saltiamo e verichiamo i<5 , mettiamo un etichetta al while e saltiamo all' etichetta
.data
vett: .word 4, 7, 2, 8, 5
somma: .space 8
.code
; $t0 somma
daddi $t0, r0, 0 ; somma=0
 ; $t1 i
daddi $t1, r0, 0 ; i=0
while: slti $t2, $t1, 5 ; $t2=0 se $t1<5, 1 altrimenti
	beq $t2, $0, fine
	; ramo vero
	; vett[i]=vett+(i*8)
	; $t3=8
	daddi $t3, $0, 8
	mult $t1, $t3
	mflo $t4 ; $t4=i*8
	daddi $t5, $t4, vett ; $t5=&[vett[i]+i*8] 
	ld $t6, 0($t5) ; $t6=*($t5)
	dadd $t0, $t0, $t6 ; somma=somma+$t6
	daddi $t1, $t1, 1 ; i++
	j while
fine: sd $t0, somma($0)
