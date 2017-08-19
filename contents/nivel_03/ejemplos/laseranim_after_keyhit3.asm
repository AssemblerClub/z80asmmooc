org #4000
run start

.start
   ;; Check Key 1
   ld   a, 64
   call #BB1E
   jr  z, nextkey_2

   ;; Key 1 pressed
   ld   a, #FF
   ld  hl, #C000
   call lasershot
   jr   start
   
   .nextkey_2
   ;; Check Key 2
   ld   a, 65
   call #BB1E
   jr  z, nextkey_3

   ;; Key 2 pressed
   ld   a, #F0
   ld  hl, #C0A0
   call lasershot
   jr   start

   .nextkey_3
   ;; Check Key 3
   ld   a, 57
   call #BB1E
   jr  z, start

   ;; Key 3 pressed
   ld   a, #0F
   ld  hl, #C140
   call lasershot
   jr start

.temphl  dw #0000

.lasershot
   ld (temphl), hl
   call anim
   
   ld hl, (temphl)
   ld  a, #00
   call anim

   ret

.anim
   ld  c, #50

   .rep
      ld (hl), a
      inc hl
      call wait
      dec c
   jr nz, rep

   ret

.wait
   ld b, 2
   .wloop
      halt
   djnz wloop

   ret