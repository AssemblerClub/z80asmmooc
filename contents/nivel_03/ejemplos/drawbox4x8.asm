org #4000      ;; La generacion de codigo empieza en 4000
run #4000      ;; Ejecuta en 4000 cuando ensambla

ld hl, #C320   ;; HL Apunta a C320 (Fila 11 de pantalla)
ld  a, #FF     ;; A = 4 pixeles de color rojo

;; Dibujar cuadrado de 4x8
ld (hl), a     ;; Fila 1
ld    h, #CB   ;; Bajar a Fila 2
ld (hl), a     ;; Fila 2
ld    h, #D3   ;; Bajar a Fila 3
ld (hl), a     ;; Fila 3
ld    h, #DB   ;; Bajar a Fila 4
ld (hl), a     ;; Fila 4
ld    h, #E3   ;; Bajar a Fila 5
ld (hl), a     ;; Fila 5
ld    h, #EB   ;; Bajar a Fila 6
ld (hl), a     ;; Fila 6
ld    h, #F3   ;; Bajar a Fila 7
ld (hl), a     ;; Fila 7
ld    h, #FB   ;; Bajar a Fila 8
ld (hl), a     ;; Fila 8

;; Bucle Infinito
jr $