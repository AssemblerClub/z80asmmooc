;;===================================================================================
;; EJEMPLO
;;
;;    Pintar de colores los 4 primeros píxeles de la pantalla
;;
;;
;; CÓDIGO MAQUINA
;;
;;  4000 - 3E 88 32 00 C0 18 FE
;;
;;
;;
;; ### EJERCICIO 1:
;;
;;    1 - Abrir Winape
;;    2 - [F7] Abrir el depurador, analizador de memoria
;;    3 - Ampliar la zona de volcado de memoria
;;    4 - Buscar la dirección &4000 
;;    5 - Escribir código máquina en la dirección 4000
;;    6 - Modificar el registro PC=4000
;;    7 - Cerrar depurador y observar ejecución
;;
;; Resultado: Se pinta de rojo el primer píxel de la pantalla
;;
;;
;;
;; ### EJERCICIO 2:
;; 
;;    1 - [Ctrl + F9] Reiniciar el CPC
;;    2 - Repetir los pasos del ejercicio 1, pero modificar
;; el 2º byte (88) por (11)
;;    3 - Repetir pasos 1 y 2 para los valores (44) y (22)
;;
;;    * Observar que 88 es 10001000 en binario
;;    * Observar que 44 es 01000100 en binario
;;    * Observar que 22 es 00100010 en binario
;;    * Observar que 11 es 00010001 en binario
;;
;; Resultado: Se pintan de rojo los pixeles del 2º al 4º
;;
;;
;;
;; ### EJERCICIO 3:
;; 
;;    1 - Repetir los pasos del ejercicio 2 8 veces, para 
;; probar las 8 combinaciones de 1 bit a 1 y los otros 7 a cero.
;; (10000000, 01000000, 00100000, 00010000,....).
;;
;;    * Observar los valores binarios y hexadecimales
;;
;; Resultado: Los 4 primeros píxeles se pintan primero de color
;; cian, y luego de color amarillo.
;;
;;
;; RETO INICIAL
;;
;;    1. Pintar un píxel rojo
;;
;; RETOS BASE
;;
;;    2. Pintar el píxel rojo en las 4 primeras posiciones de pantalla
;;    3. Igual que el reto 1, pero en amarillo y cian
;;    4. Los 4 primeros píxeles a la vez de un mismo color
;;    5. Los 4 primeros píxeles uno de cada color 
;;       (fondo, amarillo, cian y rojo)
;;
;; RETOS PLUS
;;
;;    6. Amplía el programa para que pinte los 8 primeros píxeles
;;    7. Amplía el programa para que pinte los 16 primeros píxeles
;;       formando una bandera
;;
;; CREATIVIDAD
;;
;;    8. Pintar píxeles en distintas partes de la memoria de vídeo
;;    9. Intentar realizar dibujos pintando píxeles
;;
;;
;;
;; INTRODUCCIÓN AL NIVEL
;;
;;    * Objetivo: Pintar un sprite en código máquina
;;    * Aprender:
;;        - Funcionamiento interno del ordenador a nivel básico
;;        - Introducción a la programación en código máquina
;;        - ¿Por qué binario y hexadecimal?
;;        - Píxeles y memoria de vídeo
;;    * Recordar:
;;        - El objetivo es resolver los retos. 
;;        - Es posible de muchas formas, y no importa cómo se haga.
;;        - Aprender probando: experimentar, tanto si sale bien como mal.
;;
;;
;; EXPLICACIONES EN ESTE VÍDEO
;;
;;    * Abrir WinAPE, introducir código y ejecutar
;;
;; EXPLICACIONES EN OTROS VÍDEOS
;;
;;    * Depurar código paso a paso (instrucción por instrucción)
;;    * Entendiendo binario y hexadecimal
;;    * Ciclo de ejecución del procesador
;;    * Instrucciones LOAD (LD), registros y memoria
;;    * La instrucción de salto relativo JR
;;    * Números negativos: complemento a 2
;;    * La memoria de vídeo: Funcionamiento
;;    * La memoria de vídeo: Codificación de los píxeles (modo 1)
;;    * Direcciones de memoria: Little endian y Big Endian
;;
;;===================================================================================