org #4000      ;; La generacion de codigo empieza en 4000

ld a, #FF      ;; A = 11111111 (4 pixeles color 3)
ld (#C000), a  ;; Poner en C000 los 4 pixeles rojos

jr $	         ;; Bucle Infinito