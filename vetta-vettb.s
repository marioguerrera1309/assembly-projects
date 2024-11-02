.data
vetta: .word 1, 2, 3 ;ogni numero sono 8 byte
vettb: .space 24 ;3*8 bytes
.code
la $t1, vetta
ld $t0, 0($t1) ; $t0=vetta[0]=1
ld $t2, 8($t1)
ld $t3, 16($t1)
la $t1, vettb
sd $t3, 0($t1)
sd $t2, 8($t1)
sd $t0, 16($t1)
