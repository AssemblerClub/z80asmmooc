org &8000
run start

.dib
db 01, 10, 02, 10, 01, 05, 02, 05, 01, 05, 02, 05, &FF
.pos
dw dib
.scrpos
dw &C000

.start

  .next
  ld hl, (pos)
  ld  a, (hl)
  ld  c, a
  inc hl
  ld  b, (hl)
  inc hl
  ld (pos), hl
  ld hl, (scrpos)

  .draw
  dec a
  jr nz, no1
  .draw1
    call drawtile1
    call nextScrPos
  djnz draw1
  jr   next

  .no1
  dec a
  jr nz, inf
  .draw2
    call drawtile2
    call nextScrPos
  djnz draw2
  jr   next  
  
.inf
  jr inf

.nextScrPos
  ld hl, (scrpos)
  inc hl
  inc hl
  ld (scrpos),hl
ret
  
.drawtile1
  ld   de, &800
  ld (hl), &FF
  inc hl
  ld (hl), &FF
  add hl, de
  ld (hl), &F0
  dec hl    
  ld (hl), &F0
  add hl, de
  ld (hl), &F0
  inc hl    
  ld (hl), &F0
  add hl, de
  ld (hl), &F0
  dec hl    
  ld (hl), &F0
  add hl, de
  ld (hl), &F0
  inc hl    
  ld (hl), &F0
  add hl, de
  ld (hl), &F0
  dec hl    
  ld (hl), &F0
  add hl, de
  ld (hl), &F0
  inc hl    
  ld (hl), &F0
  add hl, de
  ld (hl), &FF
  dec hl    
  ld (hl), &FF
ret

.drawtile2
  ld   de, &800
  ld (hl), &FF
  inc hl
  ld (hl), &FF
  add hl, de
  ld (hl), &0F
  dec hl    
  ld (hl), &0F
  add hl, de
  ld (hl), &0F
  inc hl    
  ld (hl), &0F
  add hl, de
  ld (hl), &0F
  dec hl    
  ld (hl), &0F
  add hl, de
  ld (hl), &0F
  inc hl    
  ld (hl), &0F
  add hl, de
  ld (hl), &0F
  dec hl    
  ld (hl), &0F
  add hl, de
  ld (hl), &0F
  inc hl    
  ld (hl), &0F
  add hl, de
  ld (hl), &FF
  dec hl    
  ld (hl), &FF
ret
