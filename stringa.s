;printf("Inserisci una stringa");
;scanf("%s", stringa);
.data
mess: .asciiz "Inserisci una stringa"
arg_printf: .space 8
descriptor: .word 0 ;stdin
ind: .space 8
dim: .word 16
buffer: .space 16
.code
;printf
daddi $t0, r0, mess
sd $t0, arg_printf(r0)
daddi r14, r0, arg_printf
syscall 5
;scanf
daddi $t0, r0, buffer
sd $t0, ind(r0)
daddi r14, r0, descriptor
syscall 3

syscall 0
