org #4000
run start

.start
   call drawCharacter

   ;; Check Key 1
   .waitKeypress
      ld   a, 47
      call #BB1E
   jr  z, waitKeypress

   call shot

   jr waitKeypress

.shot
   ld   hl, #E802
   
   .loopshot   
      ;; Draw and move
      ld  (hl), #FF
      call wait
      ld  (hl), #00
      inc  hl
   
      ;; Check end
      ld     a, l
      cp   #50
   jr    nz, loopshot

   ret

.drawCharacter
   ld   hl, #C000
   ld (hl), #33
   inc  hl
   ld (hl), #00
   
   ld    h, #C8
   ld (hl), #88
   dec  hl
   ld (hl), #77
   
   ld    h, #D0
   ld (hl), #70
   inc  hl
   ld (hl), #80
   
   ld    h, #D8
   ld (hl), #0C
   dec  hl
   ld (hl), #E6
   
   ld    h, #E0
   ld (hl), #45
   inc  hl
   ld (hl), #08

   ld    h, #E8
   ld (hl), #EE
   dec  hl
   ld (hl), #13

   ld    h, #F0
   ld (hl), #12
   inc  hl
   ld (hl), #48

   ld    h, #F8
   ld (hl), #00
   dec  hl
   ld (hl), #11

   ret

.wait
   ld b, 3
   .wloop
      halt
   djnz wloop

   ret