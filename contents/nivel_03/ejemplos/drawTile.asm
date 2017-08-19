org #4000
run start

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

   .inf
      jr inf

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