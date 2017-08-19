org #4000
run start

.map
dw box1, box1, box1, box2, box2, box2, box1, box1, box1, #0000

.box1
db #FF
db #F0
db #F0
db #FF

.box2
db #0F
db #FF
db #FF
db #0F

.cont
db 0

.scr_p
dw #C0A0

.start
   ld  bc, box1
   ld  hl, #C000
   call drawTile

   ld  bc, box2
   ld  hl, #C002
   call drawTile

   call drawMap

   .inf
      jr inf

.drawMap
   ld   hl, map

   .drawm_loop
      ld    c, (hl)
      inc  hl
      ld    a, (hl)
      cp   #0
      jr    z, draw_end
      ld    b, a
      inc  hl
      push hl
      ld   hl, (scr_p)
      call drawTile
      ld   hl, (scr_p)
      inc  hl
      ld   (scr_p), hl
      pop  hl
   jr drawm_loop

   .draw_end
   ret

.drawTile
   ld   a, 4
   ld  de, #800

   .drawloop
      ld (cont), a  
      ld    a, (bc)
      ld (hl), a 
      inc  bc
      add  hl, de
      ld    a, (cont)
      dec   a
   jr nz, drawloop

   ret