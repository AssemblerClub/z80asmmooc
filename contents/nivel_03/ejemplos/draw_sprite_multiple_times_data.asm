org #8000
run start

.nsp
db #06
.sprites
dw #C000, #C010, #C018, #C024, #C036, #C044

.start
  ld ix, sprites
  ld  a, (nsp)

  .drawloop
     ld   l, (ix+0)
     ld   h, (ix+1)
     call drawSprite
     inc ix
     inc ix
     dec  a
  jr nz, drawloop

  .inf jr inf

.drawSprite
  ld de, #800
  ld  b, 8
  .repdr
    ld (hl), #FF
    inc hl
    ld (hl), #FF
    dec hl    
    add hl, de
  djnz repdr
ret