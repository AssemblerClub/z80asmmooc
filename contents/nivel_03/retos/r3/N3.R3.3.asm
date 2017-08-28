org #4000      ;; La generacion de codigo empieza en 4000
run #4000      ;; Ejecuta en 4000 cuando ensambla
   ;;
   ;; DIBUJAR RAILES
   ;;
   call dibujar_railes  ;; Dibuja los Railes

   ;;
   ;; DIBUJAR BARRILES (Barril-Espacio-Barril-Espacio)
   ;;
   ld hl, #C39A               ;; Primer Barril en C39A
   ld  b, 19                  ;; 19 grupos Barril-Espacio
   bucle_barriles:
      call dibujar_barril     ;; Dibuja un barril
      inc  hl                 ;; | Siguiente posición de pantalla
      inc  hl                 ;; |  Dejando un espacio en blanco
      dec  b                  ;; Un barril menos por dibujar
   jr nz, bucle_barriles      ;; Si quedan barriles (B!=0), continuar dibujándolos

   ;;
   ;; DIBUJAR VAGONETA
   ;;
   reinicio:
   ld hl, #C370            ;; HL Apunta a C370 (Fila 12 de pantalla)
   call dibujar_vagoneta   ;; Dibujamos la vagoneta
   
   ;;
   ;; ESPERAR UN TIEMPO ANTES DE EMPEZAR
   ;;
   ld  c, #FF              ;; C = 255
   call espera_halt        ;; Esperar 255/300s (casi 1 segundo)

   ;;
   ;; MOVER VAGONETA (Dependiendo de lo que valga A)
   ;;
   ld hl, #C370   ;; HL Apunta a C370 (Fila 12 de pantalla)
   ld  b, #28     ;; 40 bytes hasta el centro de la pantalla

   bucle_animacion:
      ;; Borrar rastro de la vagoneta
      call borrar_cuadrado_4x8

      ;; Apuntar 1 byte más a la derecha para mover la vagoneta
      inc  hl        ;; +1 byte hacia la derecha

      call dibujar_vagoneta   ;; Dibuja la Vagoneta

      ;; Esperar hasta el siguiente fotograma
      ld    c, #06      ;; C = número de halts a esperar
      call espera_halt  ;; Esperamos tantos HALT como sea necesario

      ;; Comprobar si se ha pulsado el espacio
      ;; Y terminar la animación, en su caso
      ;; OJO! BB1E Modifica A, HL y C
      ex   de, hl          ;; Salvar HL en DE
      ld    a, 47          ;; A=47, código de la tecla Espacio
      call #BB1E           ;; Comprobar si la tecla Espacio está pulsada
      jr nz, espera_tecla2 ;; Si el Flag Z no está activo, la tecla está
                           ;; pulsada, por tanto salir.
      ex   de, hl          ;; Recuperar HL de DE

      dec b                ;; Una repetición menos de la animación
   jr nz, bucle_animacion  ;; Si aún quedan frames de la animación, repetir

   ;; La animación ha terminado
   ex   de, hl      ;; Salvar HL en DE

   ;;
   ;; ESPERAR PULSACIÓN DE TECLA
   ;;
   espera_tecla2:
      ld    a, 50      ;; A=50, código de la tecla R
      call #BB1E       ;; Comprobar si la tecla R está pulsada
   jr z, espera_tecla2 ;; Si el Flag Z está activo, no se ha pulsado la tecla. Esperar.

   ;; 
   ;; BORRAR VAGONETA 
   ;;
   ex    de, hl               ;; Recuperar HL de DE (Posición de la Vagoneta)
   call  borrar_cuadrado_4x8  ;; Borrar la primera parte de la vagoneta
   inc   hl                   ;; +1 (Apuntar a la segunda parte de la vagoneta)
   call  borrar_cuadrado_4x8  ;; Borrar la segunda parte de la vagoneta

   ;; Comenzar de nuevo 
   jr reinicio

;;============================================================
;; Espera tantos HALT como diga el registro B
;; ENTRADAS
;;    C: Número de Ciclos HALT a Esperar
;; MODIFICA
;;    C
;;============================================================
espera_halt:
      halt             ;; Esperamos 1/300 de segundo
      dec c            ;; Descontamos una unidad de espera
   jr nz, espera_halt  ;; Si aún quedan unidades de espera, repetimos

   ret

;;============================================================
;; Borra (pinta del color del fondo) un cuadrado de 4x8
;; píxeles en la posición a la que apunta HL. HL debe estar
;; en la fila 88 de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el recuadro
;; MODIFICA
;;============================================================
borrar_cuadrado_4x8:
   ld (hl), #00   ;; Fila 1
   ld    h, #CB   ;; Bajar a Fila 2
   ld (hl), #00   ;; Fila 2
   ld    h, #D3   ;; Bajar a Fila 3
   ld (hl), #00   ;; Fila 3
   ld    h, #DB   ;; Bajar a Fila 4
   ld (hl), #00   ;; Fila 4
   ld    h, #E3   ;; Bajar a Fila 5
   ld (hl), #00   ;; Fila 5
   ld    h, #EB   ;; Bajar a Fila 6
   ld (hl), #00   ;; Fila 6
   ld    h, #F3   ;; Bajar a Fila 7
   ld (hl), #00   ;; Fila 7
   ld    h, #FB   ;; Bajar a Fila 8
   ld (hl), #00   ;; Fila 8
   ld    h, #C3   ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja una vagoneta de 8x8 píxeles en la posición 
;; actual a la que apunta HL. HL debe estar en la fila 88
;; de píxeles de pantalla (que empieza en C370)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar la vagoneta
;; MODIFICA
;;============================================================
dibujar_vagoneta:
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
   ld    h, #C3   ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja una fila de railes en la fila 13 de pantalla 
;; (que empieza en C3C0). 
;; ENTRADAS
;; MODIFICA
;;    HL, B
;;============================================================
dibujar_railes:
   ld hl, #C3C0         ;; HL Apunta a C3C0 (Fila 13 de pantalla)

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

   ret

;;============================================================
;; Dibuja un barril de 4x8 píxeles en la fila 13 de pantalla 
;; (que empieza en C3C0). 
;; ENTRADAS
;;    HL: Posición donde dibujar el barril
;; MODIFICA
;;    HL, B
;;============================================================
dibujar_barril:
   ld (hl), #99 ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #6F ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #9F ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #FF ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #6F ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #9F ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #F6 ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #60 ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret