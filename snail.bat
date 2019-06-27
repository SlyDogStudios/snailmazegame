ca65 snail.asm
ld65 -C snail.cfg -o snail.prg snail.o
copy /b snail.hdr+snail.prg+graphics\snail.chr+graphics\snail.chr "Snail Maze Game.nes"
pause
