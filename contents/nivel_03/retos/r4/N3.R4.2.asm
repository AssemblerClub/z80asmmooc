org #4000      ;; La generacion de codigo empieza en 4000
run start      ;; Ejecuta en start cuando compila

;;===========================================================
;; VARIABLES
;;===========================================================
pos: dw #C370

;;===========================================================
;; INICIO DEL PROGRAMA
;;===========================================================
start:
   ;;
   ;; DIBUJAR RAILES Y BARRIL
   ;;
   call dibujar_railes  ;; Dibuja los Railes

   reinicio:
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
   ld hl, (pos)            ;; HL Apunta a la posición de la vagoneta
   call dibujar_vagoneta   ;; Dibujamos la vagoneta
   
   ;;
   ;; MOVER VAGONETA (Cada vez que se pulse P)
   ;;
   bucle_animacion:
      ;; Esperar 6 HALTs para asegurar 50 fps
      ld    c, 6           ;; C=6 (Queremos esperar 6 HALTS)
      call  espera_halt    ;; Esperar los 6 HALTS

      ;; Comprobar pulsación de tecla "P"
      ld    a, 27          ;; A = 27, código de la tecla "P"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr z, comprueba_O    ;; Flag Z activo, no se ha pulsado la tecla. Siguiente comprobación

      ;; Se ha pulsado P. Mover a la derecha
      call mover_a_la_derecha 

      comprueba_O:
      ld    a, 34          ;; A = 34, código de la tecla "O"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr z, comprueba_R    ;; Flag Z activo, no se ha pulsado la tecla. Siguiente comprobación

      ;; Se ha pulsado O. Mover a la izquierda
      call mover_a_la_izquierda

      comprueba_R:
      ld    a, 50          ;; A = 50, código de la tecla "R"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr nz, reiniciar     ;; Flag Z inactivo, se ha pulsado R. Reiniciar

   jr bucle_animacion  ;; Continuar con la animación

   reiniciar:
   ;; Borrar la vagoneta
   ld   hl, (pos)             ;; HL apunta a la posición de la vagoneta
   call borrar_cuadrado_4x8   ;; Borramos la parte izquierda de la misma
   inc  hl                    ;; +1 byte hacia la derecha
   call borrar_cuadrado_4x8   ;; Borramos la parte derecha
   ld   hl, #C370             ;; Y la reposicionamos al inicio
   ld (pos), hl               ;; Actualizando la variable

   jr start                   ;; Y volvemos al inicio del programa

;;============================================================
;; Mueve la vagoneta 1 byte a la derecha en la pantalla
;; ENTRADAS
;; MODIFICA
;;    HL
;;============================================================
mover_a_la_derecha:
   ld    hl, (pos)            ;; Leer posición actual de la vagoneta de su variable
   call  borrar_cuadrado_4x8  ;; Borrar la parte izquierda de la vagoneta
   inc   hl                   ;; Siguiente posición de pantalla a la derecha
   ld  (pos), hl              ;; Actualizar valor de la variable en memoria

   call  dibujar_vagoneta     ;; Dibujar la vagoneta en su nueva posición

   ret

;;============================================================
;; Mueve la vagoneta 1 byte a la izquierda en la pantalla
;; ENTRADAS
;; MODIFICA
;;    HL
;;============================================================
mover_a_la_izquierda:
   ld    hl, (pos)            ;; Leer posición actual de la vagoneta de su variable
   inc   hl                   ;; Siguiente posición en la memoria (derecha de la vagoneta)
   call  borrar_cuadrado_4x8  ;; Borrar la parte derecha de la vagoneta
   dec   hl                   ;; | Dos posiciones más atrás es donde debe estar 
   dec   hl                   ;; | ahora la vagoneta
   ld  (pos), hl              ;; Actualizar valor de la variable en memoria

   call  dibujar_vagoneta     ;; Dibujar la vagoneta en su nueva posición

   ret

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

;;============================================================
;; Dibuja una animación completa de una explosión en 8x8
;; píxeles en la posición indicada en HL. HL debe estar
;; en la fila 13 de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde animar la explosión
;; MODIFICA
;;    HL, B
;;============================================================
anima_explosion:
   ;; 1er fotograma + espera
   call dibujar_fot1_explosion
   ld   c, #12
   call espera_halt

   ;; 2o fotograma + espera
   call dibujar_fot2_explosion
   ld   c, #12
   call espera_halt

   ;; 3er fotograma + espera
   call dibujar_fot3_explosion
   ld   c, #12
   call espera_halt
   
   ;; Borrar el último fotograma de la explosión
   call  borrar_cuadrado_4x8  ;; Borrar la primera parte de la explosión
   inc   hl                   ;; +1 (Apuntar a la segunda parte de la explosión)
   call  borrar_cuadrado_4x8  ;; Borrar la segunda parte de la explosión
   ld   c, #12
   call espera_halt

   ret

;;============================================================
;; Dibuja el primer fotograma de una explosión de 8x8 píxeles
;; en la posición actual de HL. HL debe estar en la fila 13
;; de caracteres de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el fotograma
;; MODIFICA
;;============================================================
dibujar_fot1_explosion:
   ;; Fila 1
   ld (hl), #80   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #10   ;; Byte Derecho
   ld    h, #CB   ;; Bajar a Fila 2
   ;; Fila 2
   ld (hl), #E2   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #74   ;; Byte Izquierdo
   ld    h, #D3   ;; Bajar a Fila 3
   ;; Fila 3
   ld (hl), #72   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #E4   ;; Byte Derecho
   ld    h, #DB   ;; Bajar a Fila 4
   ;; Fila 4
   ld (hl), #E8   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #71   ;; Byte Izquierdo
   ld    h, #E3   ;; Bajar a Fila 5
   ;; Fila 5
   ld (hl), #71   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #E8   ;; Byte Derecho
   ld    h, #EB   ;; Bajar a Fila 6
   ;; Fila 6
   ld (hl), #E4   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #72   ;; Byte Izquierdo
   ld    h, #F3   ;; Bajar a Fila 7
   ;; Fila 7
   ld (hl), #74   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #E2   ;; Byte Derecho
   ld    h, #FB   ;; Bajar a Fila 8
   ;; Fila 8
   ld (hl), #10   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #80   ;; Byte Izquierdo
   ld    h, #C3   ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja el segundo fotograma de una explosión de 8x8 píxeles
;; en la posición actual de HL. HL debe estar en la fila 13
;; de caracteres de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el fotograma
;; MODIFICA
;;============================================================
dibujar_fot2_explosion:
   ;; Fila 1
   ld (hl), #F8   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #F1   ;; Byte Derecho
   ld    h, #CB   ;; Bajar a Fila 2
   ;; Fila 2
   ld (hl), #FA   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #F5   ;; Byte Izquierdo
   ld    h, #D3   ;; Bajar a Fila 3
   ;; Fila 3
   ld (hl), #D1   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #B8   ;; Byte Derecho
   ld    h, #DB   ;; Bajar a Fila 4
   ;; Fila 4
   ld (hl), #76   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #E6   ;; Byte Izquierdo
   ld    h, #E3   ;; Bajar a Fila 5
   ;; Fila 5
   ld (hl), #E6   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #76   ;; Byte Derecho
   ld    h, #EB   ;; Bajar a Fila 6
   ;; Fila 6
   ld (hl), #B8   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #D1   ;; Byte Izquierdo
   ld    h, #F3   ;; Bajar a Fila 7
   ;; Fila 7
   ld (hl), #F5   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #FA   ;; Byte Derecho
   ld    h, #FB   ;; Bajar a Fila 8
   ;; Fila 8
   ld (hl), #F1   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #F8   ;; Byte Izquierdo
   ld    h, #C3   ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja el tercer fotograma de una explosión de 8x8 píxeles
;; en la posición actual de HL. HL debe estar en la fila 13
;; de caracteres de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el fotograma
;; MODIFICA
;;============================================================
dibujar_fot3_explosion:
   ;; Fila 1
   ld (hl), #77   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #EE   ;; Byte Derecho
   ld    h, #CB   ;; Bajar a Fila 2
   ;; Fila 2
   ld (hl), #55   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #AA   ;; Byte Izquierdo
   ld    h, #D3   ;; Bajar a Fila 3
   ;; Fila 3
   ld (hl), #CC   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #33   ;; Byte Derecho
   ld    h, #DB   ;; Bajar a Fila 4
   ;; Fila 4
   ld (hl), #11   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #88   ;; Byte Izquierdo
   ld    h, #E3   ;; Bajar a Fila 5
   ;; Fila 5
   ld (hl), #88   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #11   ;; Byte Derecho
   ld    h, #EB   ;; Bajar a Fila 6
   ;; Fila 6
   ld (hl), #33   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #CC   ;; Byte Izquierdo
   ld    h, #F3   ;; Bajar a Fila 7
   ;; Fila 7
   ld (hl), #AA   ;; Byte Izquierdo
   inc  hl        ;; +1
   ld (hl), #55   ;; Byte Derecho
   ld    h, #FB   ;; Bajar a Fila 8
   ;; Fila 8
   ld (hl), #EE   ;; Byte Derecho
   dec  hl        ;; -1
   ld (hl), #77   ;; Byte Izquierdo
   ld    h, #C3   ;; Volver a Fila 1

   ret
