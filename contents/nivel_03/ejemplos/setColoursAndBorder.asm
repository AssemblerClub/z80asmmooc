org #4000
run start

SRC_SET_COLOUR equ #BC32
SRC_SET_BORDER equ #BC38

.start
  ld    a, 0
  ld   bc, #0101 
  call SRC_SET_COLOUR

  ld    a, 1
  ld   bc, #1818
  call SRC_SET_COLOUR

  ld    a, 2
  ld   bc, #1A1A
  call SRC_SET_COLOUR

  ld    a, 3
  ld   bc, #0606
  call SRC_SET_COLOUR

  ld   bc, #0101
  call SRC_SET_BORDER

  .inf
     jr inf