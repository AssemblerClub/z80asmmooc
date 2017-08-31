org #4000      ;; La generacion de codigo empieza en 4000
run start      ;; Ejecuta en start cuando compila

;;===========================================================
;; VARIABLES
;;===========================================================
pos:     dw #C390
b1:      dw #C380
b2:      dw #C3A6
b3:      dw #C37A
b4:      dw #C3AF
key:     dw #C371
door:    dw #C3BF

;;===========================================================
;; INICIO DEL PROGRAMA
;;===========================================================
start:
   ;;
   ;; ESTABLECER POSICIONES INICIALES
   ;;
   ld    hl, pos        ;; HL apunta a la variable pos
   ld  (hl), #C390      ;; Pos inicial del personaje
   ld    hl, b1         ;; HL apunta a la variable b1
   ld  (hl), #C380      ;; Posición del enemigo 1
   ld    hl, b2         ;; HL apunta a la variable b2
   ld  (hl), #C3A6      ;; Posición del enemigo 2
   ld    hl, b3         ;; HL apunta a la variable b3
   ld  (hl), #C37A      ;; Posición del enemigo 3
   ld    hl, b4         ;; HL apunta a la variable b4
   ld  (hl), #C3AF      ;; Posición del enemigo 4
   ld    hl, key        ;; HL apunta a la variable key
   ld  (hl), #C371      ;; Posición de la llave al inicio
   ld    hl, door       ;; HL apunta a la variable door
   ld  (hl), #C3BF      ;; Posición de la puerta al inicio

   ;;  
   ;; DIBUJAR RAILES Y BARRIL
   ;;
   call dibujar_railes  ;; Dibuja los Railes

   ;;
   ;; DIBUJAR BARRILES (Barril-Espacio-Barril-Espacio)
   ;;
   ld hl, (b1)          ;; Primer Barril
   call dibujar_barril  ;; Dibuja un barril
   ld hl, (b2)          ;; Segundo Barril
   call dibujar_barril  ;; Dibuja un barril
   ld hl, (b3)          ;; Tercer Barril
   call dibujar_barril  ;; Dibuja un barril
   ld hl, (b4)          ;; Cuarto Barril
   call dibujar_barril  ;; Dibuja un barril
   ld hl, (key)         ;; Llave
   call dibujar_llave   ;; Dibuja una llave
   ld hl, (door)        ;; Llave
   call dibujar_puerta  ;; Dibuja una puerta

   ;;
   ;; DIBUJAR PERSONAJE
   ;;
   ld hl, (pos)                     ;; HL Apunta a la posición del personaje
   call dibujar_personaje_derecha   ;; Dibujamos el personaje
   
   ;;
   ;; MOVER PERSONAJE (Al pulsar teclas)
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
      call  mover_a_la_derecha   ;; Mueve a la derecha la vagoneta
      jr    comprueba_R          ;; Impide más movimientos en el mismo ciclo

     comprueba_O:
      ld    a, 34          ;; A = 34, código de la tecla "O"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr z, comprueba_Z    ;; Flag Z activo, no se ha pulsado la tecla. Siguiente comprobación

      ;; Se ha pulsado O. Mover a la izquierda
      call mover_a_la_izquierda
      jr    comprueba_R          ;; Impide más movimientos en el mismo ciclo

      ;; Comprobar pulsación de tecla "Z"
     comprueba_Z:
      ld    a, 71          ;; A = 71, código de la tecla "Z"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr z, comprueba_X    ;; Flag Z activo, no se ha pulsado la tecla. Siguiente comprobación

      ;; Se ha pulsado Z. Patada a la izquierda.
      call  patada_a_la_izquierda   ;; Dar patada a la izquierda
      jr    comprueba_R             ;; Impide más movimientos en el mismo ciclo

      ;; Comprobar pulsación de tecla "Z"
     comprueba_X:
      ld    a, 63          ;; A = 63, código de la tecla "X"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr z, comprueba_R    ;; Flag Z activo, no se ha pulsado la tecla. Siguiente comprobación

      ;; Se ha pulsado X. Patada a la derecha.
      call  patada_a_la_derecha  ;; Dar patada a la derecha

     comprueba_R:
      ld    a, 50          ;; A = 50, código de la tecla "R"
      call #BB1E           ;; Comprobar si la tecla está pulsada
      jr nz, reiniciar     ;; Flag Z inactivo, se ha pulsado R. Reiniciar

      ;; Comprobar colisiones del personaje
      ld    hl, (pos)   ;; HL = posición del personaje (para hacer comprobaciones)
      ld     a, l       ;; A = parte baja de la posición del personaje
      ;; Primer enemigo
      ld    hl, (b1)    ;; HL = posición del primer enemigo
      cp     l          ;; ¿Es L=A? (Posición de b1 vs posición del personaje)
      jr     z, choque  ;; Si (Z activo), saltar a choque
      ;; Segundo enemigo
      ld    hl, (b2)    ;; HL = posición del segundo enemigo
      cp     l          ;; ¿Es L=A? (Posición de b2 vs posición del personaje)
      jr     z, choque  ;; Si (Z activo), saltar a choque
      ;; Tercer enemigo
      ld    hl, (b3)    ;; HL = posición del tercer enemigo
      cp     l          ;; ¿Es L=A? (Posición de b3 vs posición del personaje)
      jr     z, choque  ;; Si (Z activo), saltar a choque
      ;; Cuarto enemigo
      ld    hl, (b4)    ;; HL = posición del cuarto enemigo
      cp     l          ;; ¿Es L=A? (Posición de b4 vs posición del personaje)
      jr     z, choque  ;; Si (Z activo), saltar a choque
      
      ;; Llave
      ld    hl, (key)   ;; HL = posición de la llave
      cp     l          ;; ¿Es L=A? (Posición de key vs posición del personaje)
      jr    nz, nollave ;; NO (Z inactivo), saltar a no-llave

      ;; Has cogido la llave
      ld    hl, #C360   ;; HL = C360 (para eliminar la posición de la key)
      ld (key), hl      ;; Establecer nueva posición de la key

     nollave:

      ;; Puerta
      ld    hl, (door)  ;; HL = posición de la puerta
      cp     l          ;; ¿Es L=A? (Posición de puerta vs posición del personaje)
      jr    z, victoria ;; SI (Z inactivo), saltar a victoria
      
   jr bucle_animacion  ;; Continuar con la animación

   victoria:
      ;; Fin del juego. Todos los enemigos destruidos
      ;; Dibujar personaje en posición de victoria y terminar
      ld    hl, (pos)                   ;; HL apunta a posición del personaje
      call  dibujar_personaje_victoria  ;; Dibujar personaje
      jr    espera_R                    ;; Espera pulsación para reiniciar

   choque:
      ;; Hay choque. Animación de explosión.
      call  anima_explosion
   
      ;; Esperar pulsación de tecla R para reiniciar
      espera_R:
         ld    a, 50 ;; A = 50, código de la tecla "R"
         call #BB1E  ;; Comprobar si la tecla está pulsada
      jr z, espera_R ;; Flag Z activo, no se ha pulsado R. Esperar.

   reiniciar:
      ;; Borrar el personaje
      ld   hl, (pos)             ;; HL apunta a la posición del personaje
      call borrar_cuadrado_4x8   ;; Borramos el personaje

 jp start                   ;; Y volvemos al inicio del programa

;;============================================================
;; Comprueba si donde apunta HL hay situado algún enemigo y
;; en caso de haberlo lo destruye.
;; ENTRADAS
;;    HL: Posición a comprobar
;; MODIFICA
;;    HL, A, C
;;============================================================
destruccion_de_enemigos:
   ;; Check enemigo 1
   ld    a, (b1)  ;; A = parte baja posición enemigo 1
   cp    l        ;; ¿A=L?
   jr   nz, nob1  ;; Z inactivo, No se golpea a enemigo 1

   ;; Enemigo 1 golpeado
   call  anima_disolucion  ;; Elimina al enemigo y muestra explosión
   ld    a, #60            ;; A = 60h (Nueva posición del enemigo)
   ld  (b1), a             ;; Actualizar la posición del enemigo a 60h. 
                           ;; 60h está fuera del raíl, así no podemos colisionar ya.

  nob1:
   ;; Check enemigo 2
   ld    a, (b2)  ;; A = parte baja posición enemigo 2
   cp    l        ;; ¿A=L?
   jr   nz, nob2  ;; Z inactivo, No se golpea a enemigo 2

   ;; Enemigo 2 golpeado
   call  anima_disolucion  ;; Elimina al enemigo y muestra explosión
   ld    a, #60            ;; A = 60h (Nueva posición del enemigo)
   ld  (b2), a             ;; Actualizar la posición del enemigo a 60h. 
                           ;; 60h está fuera del raíl, así no podemos colisionar ya.

  nob2:
   ;; Check enemigo 3
   ld    a, (b3)  ;; A = parte baja posición enemigo 3
   cp    l        ;; ¿A=L?
   jr   nz, nob3  ;; Z inactivo, No se golpea a enemigo 3

   ;; Enemigo 2 golpeado
   call  anima_disolucion  ;; Elimina al enemigo y muestra explosión
   ld    a, #60            ;; A = 60h (Nueva posición del enemigo)
   ld  (b3), a             ;; Actualizar la posición del enemigo a 60h. 
                           ;; 60h está fuera del raíl, así no podemos colisionar ya.

  nob3:
   ;; Check enemigo 2
   ld    a, (b4)  ;; A = parte baja posición enemigo 4
   cp    l        ;; ¿A=L?
   jr   nz, nob4  ;; Z inactivo, No se golpea a enemigo 4

   ;; Enemigo 2 golpeado
   call  anima_disolucion  ;; Elimina al enemigo y muestra explosión
   ld    a, #60            ;; A = 60h (Nueva posición del enemigo)
   ld  (b4), a             ;; Actualizar la posición del enemigo a 60h. 
                           ;; 60h está fuera del raíl, así no podemos colisionar ya.

  nob4:
   ret

;;============================================================
;; El personaje realiza una patada a la derecha y destruye
;; objetos si es que allí hubiera alguno.
;; ENTRADAS
;; MODIFICA
;;    HL, C
;;============================================================
patada_a_la_derecha:
   ;; Dibujar patada a la derecha en la posición del personaje
   ld    hl, (pos)                     ;; HL = posición personaje
   call  dibujar_personaje_pat_derecha ;; Dibujar patada derecha

   ;; Esperar un tiempo para que se vea
   ld     c, 150                       ;; 150 HALTS = 0.5s
   call  espera_halt                   ;; Esperar

   ;; Redibujar personaje normal
   call  dibujar_personaje_derecha

   ;; Situar HL en la posición a comprobar 
   ;; y comprobar si destruimos algún enemigo
   inc   hl                      ;; HL apunta a la derecha del personaje
   call  destruccion_de_enemigos ;; Comprobar y destruir enemigo en su caso

   ret

;;============================================================
;; El personaje realiza una patada a la izquierda y destruye
;; objetos si es que allí hubiera alguno.
;; ENTRADAS
;; MODIFICA
;;    HL, C
;;============================================================
patada_a_la_izquierda:
   ;; Dibujar patada a la derecha en la posición del personaje
   ld    hl, (pos)                       ;; HL = posición personaje
   call  dibujar_personaje_pat_izquierda ;; Dibujar patada izquierda

   ;; Esperar un tiempo para que se vea
   ld     c, 150                       ;; 150 HALTS = 0.5s
   call  espera_halt                   ;; Esperar

   ;; Redibujar personaje normal
   call  dibujar_personaje_izquierda    

   ;; Situar HL en la posición a comprobar 
   ;; y comprobar si destruimos algún enemigo
   dec   hl                      ;; HL apunta a la derecha del personaje
   call  destruccion_de_enemigos ;; Comprobar y destruir enemigo en su caso

   ret

;;============================================================
;; Mueve al personaje 1 byte a la derecha en la pantalla
;; ENTRADAS
;; MODIFICA
;;    HL, A
;;============================================================
mover_a_la_derecha:
   ;; Comprobar si tenemos la llave
   ld    hl, (key)            ;; HL=Posición actual de la llave
   ld     a, l                ;; A=L Posición de la llave para comprobar
   cp   #60                   ;; ¿A=L=#60? Posición en caso de haberla cogido
   jr     z, puede_mover      ;; Sí iguales (Z activo) saltar a puede mover hacia puerta

   ;; Impedir movimiento hacia puerta sin llave
   ld    hl, (door)           ;; Leer posición actual de la puerta
   ld     a, l                ;; A=L Para comprobar si el personaje está ahí
   dec    a                   ;; Tenemos que mirar la posición anterior
   ld    hl, (pos)            ;; Leer posición actual del personaje de su variable
   cp     l                   ;; ¿A = L? ¿Personaje = Door - 1?
   jr     z, nomoverd         ;; Son iguales, luego no moverse a la derecha

puede_mover:
   ;; Moverse y dibujar el personaje
   ld    hl, (pos)            ;; HL=Posición del personaje
   call  borrar_cuadrado_4x8  ;; Borrarlo de la pantalla
   inc   hl                   ;; Apuntar 1 byte más a la derecha
   ld  (pos), hl              ;; Actualizar valor de la variable en memoria

   call  dibujar_personaje_derecha  ;; Dibujar al personaje en su nueva posición

nomoverd:
   ret

;;============================================================
;; Mueve al personaje 1 byte a la izquierda en la pantalla
;; ENTRADAS
;; MODIFICA
;;    HL
;;============================================================
mover_a_la_izquierda:
   ld    hl, (pos)            ;; Leer posición actual del personaje de su variable

   ;; Impedir movimiento límite izquierdo
   ld     a, l                ;; A=L Para comprobar si está al límite
   cp   #70                   ;; ¿A=L=#70?
   jr     z, nomoveri         ;; Son iguales, luego no moverse a la izquierda

   ;; Moverse y dibujar el personaje
   call  borrar_cuadrado_4x8  ;; Borrar el personaje
   dec   hl                   ;; Apuntar 1 byte más a la izquierda
   ld  (pos), hl              ;; Actualizar valor de la variable en memoria

   call  dibujar_personaje_izquierda  ;; Dibujar al personaje en su nueva posición

nomoveri:
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
;; Dibuja un personaje de 4x8 píxeles en la fila 13 de pantalla 
;; (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde dibujar el personaje
;; MODIFICA
;;============================================================
dibujar_personaje_victoria:
   ld (hl), #66 ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #9F ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #98 ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #9E ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #F0 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #42 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #24 ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #99 ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja un personaje de 4x8 píxeles en la fila 13 de pantalla 
;; (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde dibujar el personaje
;; MODIFICA
;;============================================================
dibujar_personaje_derecha:
   ld (hl), #EE ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #9F ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #8B ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #8F ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #AE ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #E0 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #4A ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #AA ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja un personaje de 4x8 píxeles en la fila 13 de pantalla 
;; (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde dibujar el personaje
;; MODIFICA
;;============================================================
dibujar_personaje_izquierda:
   ld (hl), #77 ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #9F ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #1D ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #1F ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #57 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #70 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #27 ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #55 ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret
;;============================================================
;; Dibuja un personaje de 4x8 píxeles dando una patada a la
;; derecha en la fila 13 de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde dibujar el personaje
;; MODIFICA
;;============================================================
dibujar_personaje_pat_derecha:
   ld (hl), #FF ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #8E ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #8B ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #E8 ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #04 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #D1 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #F7 ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #88 ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja un personaje de 4x8 píxeles dando una patada a la
;; izquierda en la fila 13 de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde dibujar el personaje
;; MODIFICA
;;============================================================
dibujar_personaje_pat_izquierda:
   ld (hl), #FF ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #17 ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #1D ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #71 ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #02 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #B8 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #FE ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #11 ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja una animación completa de una explosión en 8x8
;; píxeles en la posición indicada en HL. HL debe estar
;; en la fila 13 de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde animar la explosión
;; MODIFICA
;;    HL, C
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
;; Dibuja una animación completa de la disolución de un barril
;; en la posición actual de HL en la fila 13 de pantalla 
;; (que empieza en C3C0)
;; ENTRADAS
;;    HL: Posición donde animar la disolución
;; MODIFICA
;;    HL, C
;;============================================================
anima_disolucion:
   ;; 1er fotograma + espera
   call dibujar_fot1_disolucion
   ld   c, #12
   call espera_halt

   ;; 2o fotograma + espera
   call dibujar_fot2_disolucion
   ld   c, #12
   call espera_halt

   ;; 3er fotograma + espera
   call dibujar_fot3_disolucion
   ld   c, #12
   call espera_halt
   
   ;; Borrar el último fotograma de la explosión
   call  borrar_cuadrado_4x8  ;; Borrar la primera parte de la explosión
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


;;============================================================
;; Dibuja el primer fotograma de la disolución de un barril
;; en la posición actual de HL. HL debe estar en la fila 13
;; de caracteres de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el fotograma
;; MODIFICA
;;============================================================
dibujar_fot1_disolucion:
   ld (hl), #11 ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #00 ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #99 ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #BB ;; Fila 4
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
;; Dibuja el segundo fotograma de una disolución de un barril
;; en la posición actual de HL. HL debe estar en la fila 13
;; de caracteres de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el fotograma
;; MODIFICA
;;============================================================
dibujar_fot2_disolucion:
   ld (hl), #00 ;; Fila 1
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #88 ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #11 ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #4C ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #8A ;; Fila 6
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja el tercer fotograma de una disolución de un barril
;; en la posición actual de HL. HL debe estar en la fila 13
;; de caracteres de pantalla (que empieza en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar el fotograma
;; MODIFICA
;;============================================================
dibujar_fot3_disolucion:
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #00 ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #00 ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #00 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #00 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #54 ;; Fila 7
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja una llave en la posición actual de HL. HL debe 
;; estar en la fila 13 de caracteres de pantalla (que empieza 
;; en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar la llave
;; MODIFICA
;;============================================================
dibujar_llave:
   ld (hl), #60 ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #90 ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #60 ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #20 ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #20 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #60 ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #20 ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #E0 ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret

;;============================================================
;; Dibuja una puerta en la posición actual de HL. HL debe 
;; estar en la fila 13 de caracteres de pantalla (que empieza 
;; en C3C0)
;; ENTRADAS
;;    HL: Puntero a la posición donde dibujar la puerta
;; MODIFICA
;;============================================================
dibujar_puerta:
   ld (hl), #06 ;; Fila 1
   ld    h, #CB ;; Bajar a Fila 2
   ld (hl), #6F ;; Fila 2
   ld    h, #D3 ;; Bajar a Fila 3
   ld (hl), #FF ;; Fila 3
   ld    h, #DB ;; Bajar a Fila 4
   ld (hl), #FF ;; Fila 4
   ld    h, #E3 ;; Bajar a Fila 5
   ld (hl), #F3 ;; Fila 5
   ld    h, #EB ;; Bajar a Fila 6
   ld (hl), #FB ;; Fila 6
   ld    h, #F3 ;; Bajar a Fila 7
   ld (hl), #FF ;; Fila 7
   ld    h, #FB ;; Bajar a Fila 8
   ld (hl), #FF ;; Fila 8
   ld    h, #C3 ;; Volver a Fila 1

   ret
