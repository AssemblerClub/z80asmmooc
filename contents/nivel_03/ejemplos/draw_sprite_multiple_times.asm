org #8000
run start

.start
  ld  a, #FF
  ld hl, #C000
  call drawSprite

  ld  a, #FF
  ld hl, #C010
  call drawSprite

  ld  a, #FF
  ld hl, #C018
  call drawSprite

  ld  a, #FF
  ld hl, #C024
  call drawSprite

  ld  a, #FF
  ld hl, #C036
  call drawSprite

  ld  a, #FF
  ld hl, #C044
  call drawSprite

  .inf jr inf

.drawSprite
  ld de, #800
  ld  b, 8
  .repdr
    ld (hl), a
    inc hl
    ld (hl), a
    dec hl    
    add hl, de
  djnz repdr
ret