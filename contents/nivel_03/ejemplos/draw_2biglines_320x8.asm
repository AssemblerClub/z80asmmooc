org #4000      ;; La generacion de codigo empieza en 4000
run #4000      ;; Ejecuta en 4000 cuando ensambla

ld  a, #FF     ;; A = 4 pixeles de color rojo
ld  b, 80      ;; La pantalla son 80 bytes de ancho

ld hl, #C320   ;; HL Apunta a C320 (Fila 11 de pantalla)

;; Dibujar cuadrado de 4x8
bucle:
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
 ld    h, #C3   ;; Bajar a Fila 8

inc hl          ;; HL apunta a la siguiente posicion a la derecha
dec b           ;; Queda un byte menos por dibujar
jr  nz, bucle   ;; Repetir si aun quedan bytes por dibujar (b != 0)

ld  b, #40      ;; Lo que queda de C3C0 hasta C400
ld hl, #C3C0    ;; HL Apunta a C3C0 (Fila 13 de pantalla)

;; Dibujar cuadrado de 4x8
bucle2:
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
 ld    h, #C3   ;; Bajar a Fila 8

inc hl           ;; HL apunta a la siguiente posicion a la derecha
dec b            ;; Queda un byte menos por dibujar
jr  nz, bucle2   ;; Repetir si aun quedan bytes por dibujar (b != 0)

ld  b, #10      ;; Lo que queda de C400 hasta C410
ld hl, #C400    ;; HL Apunta a C400 (Mitad de la fila 13)

;; Dibujar cuadrado de 4x8
bucle3:
 ld (hl), a     ;; Fila 1
 ld    h, #CC   ;; Bajar a Fila 2
 ld (hl), a     ;; Fila 2
 ld    h, #D4   ;; Bajar a Fila 3
 ld (hl), a     ;; Fila 3
 ld    h, #DC   ;; Bajar a Fila 4
 ld (hl), a     ;; Fila 4
 ld    h, #E4   ;; Bajar a Fila 5
 ld (hl), a     ;; Fila 5
 ld    h, #EC   ;; Bajar a Fila 6
 ld (hl), a     ;; Fila 6
 ld    h, #F4   ;; Bajar a Fila 7
 ld (hl), a     ;; Fila 7
 ld    h, #FC   ;; Bajar a Fila 8
 ld (hl), a     ;; Fila 8
 ld    h, #C4   ;; Bajar a Fila 8

inc hl           ;; HL apunta a la siguiente posicion a la derecha
dec b            ;; Queda un byte menos por dibujar
jr  nz, bucle3   ;; Repetir si aun quedan bytes por dibujar (b != 0)

;; Bucle Infinito
jr $