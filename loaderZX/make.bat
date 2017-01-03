rem Preparar datos que va a usar el juego. Necesita fondo.png y fondo.atr
rem Genera fondo.rcs
Png2Rcs fondo.png fondo.rcs -a fondo.atr

rem Ensamblar el juego. Necesita además music.bin, fuente6x8.bin y fondo.rcs
rem Genera game.bin
sjasmplus game.asm

rem Comprime juego. Salida game.bin.zx7b
zx7b game.bin game.bin.zx7b

rem Calcula la longitud del juego comprimido y sin comprimir en define.asm
echo.> define.asm
call :getfilesize game.bin rawsize
call :getfilesize game.bin.zx7b compsize

rem Filtro RCS de la pantalla de carga. Necesita loadscr.png, genera loadscr.rcs
Png2Rcs loadscr.png loadscr.rcs

rem Comprime pantalla de carga. Al filtrar se comprime mejor
zx7b loadscr.rcs loadscr.rcs.zx7b

rem Monta todo en loader.asm. El cargador contiene la pantalla, con lo que
rem solo se necesita un bloque para el juego
sjasmplus loader.asm
GenTape game.tap                ^
  basic "Mi Juego" 0 loader.bin ^
   data game.bin.zx7b
goto :eof

:getfilesize
echo  define  %2  %~z1 >> define.asm
goto :eof
