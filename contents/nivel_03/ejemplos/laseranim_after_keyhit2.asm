org #4000
run start

.start
   ld   a, 47
   call #BB1E
   jr  z, start

   ld  a, #FF
   call anim
   ld  a, #00
   call anim
   
   jr start

.anim
   ld   c, 80
   ld  hl, #C000
   .rep
      ld (hl), a
      inc hl
      call wait
      dec c
   jr nz, rep

   ret

.wait
   ld b, 3
   .wloop
      halt
   djnz wloop

   ret