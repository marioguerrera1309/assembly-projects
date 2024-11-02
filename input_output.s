.data
buffer: .space 8
par: .space 8
ind: .space 8
num_byte: .word 4
x: .space 8
mess: .asciiz "Il valore inserito e'  %d"
arg_printf: .space 8
num: .space 8
.code
sd r0, par(r0)
sd r0, x(r0)
daddi $t0, r0, buffer
sd $t0, ind(r0)
daddi r14, r0, par
syscall 3
daddi $t1, $0, buffer ; metto l' indirizzo di buffer in $t1 ($t1=&buffer)
ld $t2, 0($t1) ; prendo il valore di $t1 ($t2=*[$t1])
daddi $t4, r0, 48 ; metto 48 in $t4
sub $t3, $t2, $t4 ; tolgo 48 a $t4 per ottenere il numero
sd $t3, x(r0) ; salvo in x
; printf
daddi $t0, r0, mess ; $t0=&[mess]
sd $t0, arg_printf(r0) ; arg_printf=$t0
daddi $t0, r0, x
ld $t1, 0($t0)
sd $t1, num(r0)
daddi r14, r0, arg_printf
syscall 5
syscall 0
