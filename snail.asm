; This is the main hub file for the Snail Maze Game. All files
;  are included or incbin'd here.
.include "includes\constants.asm"
.include "music\music_declarations.asm"

.segment "ZEROPAGE"
.include "includes\zp.asm"

.segment "CODE"
.include "includes\reset.asm"

.include "includes\setup_round.asm"

loop:
	jmp (loop_pointer)
end_loop:
	lda reset_game				; Check to see if the game needs reset
	beq @not_done				;  which happens when you either lose the
		lda #$00				;  game (lose_loop) or beat the game
		jsr music_loadsong		;  (win_loop) [both loops in game_loops.asm]
		lda #$ff				; Shut the music off, then load a with
		tax						;  #$ff to store the sprites off-screen.
		inx						;  (all of this small routine is to prevent
:		sta snail_head, x		;  the screen from looking like crap before
		inx						;  jumping to the actual beginning reset
		inx						;  (reset.asm).
		inx						;
		inx						;
		cpx #84					;
		bne :-					;
		ldx #$00				; Change all colors of the palette to black
		lda #$0f				;  (#$0f)
:		sta pal_address, x		;
		inx						;
		cpx #$20				;
		bne :-					;
		jsr nmi_wait			; Wait for NMI so all graphic changes made
		jmp reset				;  will take place, then go to reset (reset.asm)
@not_done:
	jmp loop

nmi:
.include "includes\nmi.asm"

title:
.incbin "graphics\title.nam"
palette:
.incbin "graphics\snail_palette.pal"
.include "includes\mazes.asm"
.include "includes\maze_select.asm"
.include "includes\splash.asm"
.include "includes\controls.asm"
.include "includes\sprites.asm"
.include "includes\game_loops.asm"
.include "includes\common.asm"
.include "includes\timer.asm"
.include "music\music_engine.asm"
.include "music\music_data.asm"

.segment "VECTORS"
	.addr nmi
	.addr reset
	.addr irq
