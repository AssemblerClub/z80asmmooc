org #8000
run start

.pos dw #C000

.start
  ld  a, #FF
  ld hl, (pos)
  call a_box

  .mainloop
    ld   a, 27
    call #BB1E
    jr   z, mainloop
    
    ld  hl, (pos)
    ld   a, #00
    call a_box

    ld  hl, (pos)
    inc hl
    ld (pos), hl

    ld   a, #FF
    call a_box

    ld   b, 6
    .wait
      halt
    djnz wait
  jr mainloop

.a_box
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