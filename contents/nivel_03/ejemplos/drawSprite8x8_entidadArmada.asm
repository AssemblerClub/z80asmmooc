org #4000      ;; La generacion de codigo empieza en 4000
run #4000      ;; Ejecuta en 4000 cuando ensambla

ld hl, #C000   ;; HL Apunta a C000

;; Fila 1
ld (hl), #33   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #00   ;; Byte Derecho
ld    h, #C8   ;; Bajar a Fila 2

;; Fila 2
ld (hl), #88   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #77   ;; Byte Izquierdo
ld    h, #D0   ;; Bajar a Fila 3

;; Fila 3
ld (hl), #70   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #80   ;; Byte Derecho
ld    h, #D8   ;; Bajar a Fila 4

;; Fila 4
ld (hl), #0C   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #E6   ;; Byte Izquierdo
ld    h, #E0   ;; Bajar a Fila 5

;; Fila 5
ld (hl), #45   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #08   ;; Byte Derecho
ld    h, #E8   ;; Bajar a Fila 6

;; Fila 6
ld (hl), #EE   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #13   ;; Byte Izquierdo
ld    h, #F0   ;; Bajar a Fila 7

;; Fila 7
ld (hl), #12   ;; Byte Izquierdo
inc  hl        ;; +1
ld (hl), #48   ;; Byte Derecho
ld    h, #F8   ;; Bajar a Fila 8

;; Fila 8
ld (hl), #00   ;; Byte Derecho
dec  hl        ;; -1
ld (hl), #11   ;; Byte Izquierdo

;; Bucle Infinito
jr $