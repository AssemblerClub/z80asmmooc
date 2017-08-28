org #4000      ;; La generacion de codigo empieza en 4000
run #4000      ;; Ejecuta en 4000 cuando ensambla

ld hl, #C370   ;; HL Apunta a C370 (Fila 12 de pantalla)

;; Dibujar un vagon de una mina
;; Fila 1
ld (hl), #88   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #11   ;; Byte Derecho
ld    h, #CB   ;; Bajar a Fila 2

;; Fila 2
ld (hl), #F1   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #F8   ;; Byte Izquierdo
ld    h, #D3   ;; Bajar a Fila 3

;; Fila 3
ld (hl), #FE   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #F7   ;; Byte Derecho
ld    h, #DB   ;; Bajar a Fila 4

;; Fila 4
ld (hl), #FF   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #FF   ;; Byte Izquierdo
ld    h, #E3   ;; Bajar a Fila 5

;; Fila 5
ld (hl), #BB   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #DD   ;; Byte Derecho
ld    h, #EB   ;; Bajar a Fila 6

;; Fila 6
ld (hl), #8A   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #15   ;; Byte Izquierdo
ld    h, #F3   ;; Bajar a Fila 7

;; Fila 7
ld (hl), #4A   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #25   ;; Byte Derecho
ld    h, #FB   ;; Bajar a Fila 8

;; Fila 8
ld (hl), #02   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #04   ;; Byte Izquierdo

;; Bucle Infinito
jr $