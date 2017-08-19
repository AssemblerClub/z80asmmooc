org &8000
run start

.pos
dw &C000

.start
  ld  a, &FF
  ld hl, (pos)
  call a_box

  .mainloop
    ld   a, 34
    call &BB1E
    jr   z, noko

    ld  de, -1
    call move

    .noko
    ld   a, 27
    call &BB1E
    jr   z, nokp

    ld  de, 1
    call move

    .nokp
    ld   a, 66
    call &BB1E
  jr  z, mainloop

  jp   0

.move
  push de

  ld  a, &00
  ld hl, (pos)
  call a_box

  pop de
  ld hl, (pos)
  add hl, de
  ld (pos), hl

  ld  a, &FF
  call a_box

  ld b, 6
  .wait
    halt
  djnz wait

ret  

.a_box
  ld de, &800
  ld  b, 8
  .repdr
    ld (hl), a
    inc hl
    ld (hl), a
    dec hl    
    add hl, de
  djnz repdr
ret