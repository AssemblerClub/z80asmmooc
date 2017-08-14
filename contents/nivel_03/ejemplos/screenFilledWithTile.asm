org &8000
run start

.scrpos
dw &C000

.start

  ld  a, 25
  .nexty
    ld  b, 40
    .nextx
      ld hl, (scrpos)
      call drawtile
      ld hl, (scrpos)
      inc hl
      inc hl
      ld (scrpos), hl
    djnz nextx
  dec a
  jr nz, nexty
  
.inf
  jr inf
  
.drawtile
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
