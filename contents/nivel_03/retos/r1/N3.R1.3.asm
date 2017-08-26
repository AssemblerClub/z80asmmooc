org #4000         ;; La generacion de codigo empieza en 4000
run #4000         ;; Ejecuta en 4000 cuando ensambla

   ld hl, #C3C0   ;; HL Apunta a C3C0 (Fila 13 de pantalla)

   ;; Dibujar Raíles desde C3C0 hasta C400
   ld    b, #40    ;; 64 bytes de C3C0 hasta C400
   bucle1:
      ld (hl), #5F ;; Fila 1
      ld    h, #CB ;; Bajar a Fila 2
      ld (hl), #40 ;; Fila 2
      ld    h, #D3 ;; Bajar a Fila 3
      ld (hl), #60 ;; Fila 3
      ld    h, #DB ;; Bajar a Fila 3
      ld (hl), #50 ;; Fila 4
      ld    h, #C3 ;; Volver a la Fila 1

      inc  hl      ;; Siguiente posición
      dec   b      ;; Una posición menos por hacer
   jr nz, bucle1   ;; Si no es la última, repetir

   ;; Dibujar Raíles desde C400 hasta C410
   ld    b, #10    ;; 16 bytes de C400 hasta C410
   bucle2:
      ld (hl), #5F ;; Fila 1
      ld    h, #CC ;; Bajar a Fila 2
      ld (hl), #40 ;; Fila 2
      ld    h, #D4 ;; Bajar a Fila 3
      ld (hl), #60 ;; Fila 3
      ld    h, #DC ;; Bajar a Fila 3
      ld (hl), #50 ;; Fila 4
      ld    h, #C4 ;; Volver a la Fila 1

      inc  hl      ;; Siguiente posición
      dec   b      ;; Una posición menos por hacer
   jr nz, bucle2   ;; Si no es la última, repetir

   ;; Bucle Infinito
   jr $