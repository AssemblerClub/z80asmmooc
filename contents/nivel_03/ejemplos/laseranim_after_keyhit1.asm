org #4000
run start

.start
   ld   a, 47
   call #BB1E
   jr  z, start

   ld   c, 80
   ld  hl, #C000
   .rep
      ld (hl), #FF
      inc hl
      call wait
      dec c
   jr nz, rep

   ld   c, 80
   ld  hl, #C000
   .rep2
      ld (hl), #00
      inc hl
      call wait
      dec c
   jr nz, rep2
   
   jr start

.wait
   ld b, 3
   .wloop
      halt
   djnz wloop

   ret