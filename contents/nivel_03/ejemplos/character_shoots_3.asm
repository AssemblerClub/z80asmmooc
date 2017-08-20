org #4000
run start

.start
   ;; Draw Character and enemies
   ld   l, #00
   call drawCharacter
   ld   l, #0B
   call drawEnemy
   ld   l, #11
   call drawEnemy
   ld   l, #16
   call drawEnemy
   ld   l, #1F
   call drawEnemy
   ld   l, #2A
   call drawEnemy
   ld   l, #2D
   call drawEnemy
   ld   l, #33
   call drawEnemy
   ld   l, #3A
   call drawEnemy
   ld   l, #40
   call drawEnemy
   ld   l, #44
   call drawEnemy

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
      ;; Check collision
      ld    a, (hl)
      cp   #0
      jr   nz, collision
   
      ;; Draw and move
      ld  (hl), #FF
      ld     b, 3
      call wait
      ld  (hl), #00
      inc  hl
   
      ;; Check end
      ld     a, l
      cp   #50
   jr    nz, loopshot

   ret

   .collision

   ld    h, #D8
   ld (hl), #66
   ld    h, #E0
   ld (hl), #66
   ld   b, 6
   call wait

   ld    h, #D0
   ld (hl), #00
   inc  hl
   ld (hl), #00
   
   ld    h, #D8
   ld (hl), #00
   dec  hl
   ld (hl), #60
   
   ld    h, #E0
   ld (hl), #60
   inc  hl
   ld (hl), #00

   ld    h, #E8
   ld (hl), #00
   dec  hl
   ld (hl), #00
   ld   b, 6
   call wait

   ld    h, #C8
   ld (hl), #00
   inc  hl
   ld (hl), #00
   
   ld    h, #F0
   ld (hl), #00
   dec  hl
   ld (hl), #00
   
   ld    h, #D0
   ld (hl), #90
   ld    h, #D8
   ld (hl), #60
   ld    h, #E0
   ld (hl), #60
   ld    h, #E8
   ld (hl), #90
   ld    b, 6
   call wait

   ld    h, #C0
   ld (hl), #00
   inc  hl
   ld (hl), #00
   
   ld    h, #F8
   ld (hl), #00
   dec  hl
   ld (hl), #00
   
   ld    h, #D0
   ld (hl), #99
   ld    h, #E8
   ld (hl), #99
   ld    b, 6
   call wait

   ld    h, #D8
   ld (hl), #00
   ld    h, #E0
   ld (hl), #00
   ld    b, 6
   call wait

   ld    h, #D0
   ld (hl), #00
   ld    h, #E8
   ld (hl), #00
   ld    b, 6
   call wait

   ret

.drawCharacter
   ld    h, #C0
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

.drawEnemy
   ld    h, #C0
   ld (hl), #11
   inc  hl
   ld (hl), #CC
   
   ld    h, #C8
   ld (hl), #EA
   dec  hl
   ld (hl), #22
   
   ld    h, #D0
   ld (hl), #33
   inc  hl
   ld (hl), #EE
   
   ld    h, #D8
   ld (hl), #66
   dec  hl
   ld (hl), #03
   
   ld    h, #E0
   ld (hl), #01
   inc  hl
   ld (hl), #6E

   ld    h, #E8
   ld (hl), #C0
   dec  hl
   ld (hl), #77

   ld    h, #F0
   ld (hl), #12
   inc  hl
   ld (hl), #48

   ld    h, #F8
   ld (hl), #44
   dec  hl
   ld (hl), #11

   ret

.wait
   .wloop
      halt
   djnz wloop

   ret