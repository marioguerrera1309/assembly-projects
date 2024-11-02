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
somma: .space 8 ; perchè gli elementi (word) occupano 8 byte
.code
daddi $s0, $0, 0 ; somma=0 somma-> $s0
daddi $s1, $0, 0 ; i=0 i->$s1
while: slti $t0, $s1, 5 ; $t0=1 se $s1<5 ovvero se i<5 , 0 altrimenti
	beq $t0, $0, fine
	; cod dentro il while
	; &vett[i]=vett+i*8
	; assegno ad un registro 8 e faccio prodotto fra due registri
	; oppure essendo 8=2^3 shifto tutto di 3 a sinistra
	dsll $t0, $s1, 3 ; $t0=i*8 shiftando
	daddi $t1, $t0, vett ; $t1=& vett[i]=vett+i*8
	ld $t2, 0($t1) ;$t2=vett[i]
	dadd $s0, $s0, $t2
	daddi $s1, $s1, 1 ;i++ 
	j while
fine: sd $s0, somma($0)
