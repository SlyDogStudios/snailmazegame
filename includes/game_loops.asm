; The order of the loops:
;  scroll_loop -> round_start_loop -> gameplay_loop -> end_level_loop ->
;  round_setup (not really a loop, but needs to be done) -> level_done_loop...
;  Then that repeats. win_loop and lose_loop are used when beating
;  the game and losing the game, respectively.

level_done_loop:
	lda bg_addy_offset				; Let the screen load in NMI (nmi.asm)
	cmp #$20						;  before doing anything else
	bne :++							;
		lda #<scroll_loop			; Load the next loop to be used, which
		sta loop_pointer			;  is scroll_loop.
		lda #>scroll_loop			;
		sta loop_pointer+1			;
		lda round_second+1			; Increment the round, but test if the
		cmp #$39					;  ones place is already at 9 ascii. If
		bne :+						;  it is, then load #$2f in the sprite
			lda #$2f				;  so it will increment to #$30 (zero ascii)
			sta round_second+1		;  after this. Set the tens place to 1.
			lda #$31				;  There are only 12 levels, so no other
			sta round_first +1		;  incrementing will ever be necessary.
:		lda round_second+1			; Here it actually increments the round.
		clc							;
		adc #$01					;
		sta round_second+1			;
		jsr add_time				; (see this routine in timer.asm)
:	jsr nmi_wait					;
	jmp end_loop					;

scroll_loop:
	lda hscroll						; Add one to the horizontal scroll value
	clc								;  so that during the next frame in NMI
	adc #$01						;  it will move over a pixel.
	sta hscroll						; If it wraps around to zero, then we are
	beq :+							;  done with this loop.
		jsr nmi_wait
		jmp end_loop
:	lda nametable					; Flip bit 0 here and store it back in
	eor #$01						;  nametable for use in the sprite0 hit
	sta nametable					;  during the next NMI (nmi.asm).
	jsr nmi_wait
	lda #<round_start_loop			; Prep for round_start_loop to be the
	sta loop_pointer				;  next loop.
	lda #>round_start_loop			;
	sta loop_pointer+1				;
	jmp end_loop

round_start_loop:
	ldx #$00
	ldy #$00
:	lda head_sprite_y, x
	sta snail_head, y
	lda head_sprite_x, x
	sta snail_head+3, y
	iny
	iny
	iny
	iny
	inx
	cpx #$09
	bne :-
	lda #$0b
	sta snail+1
	lda #$15
	sta snail_head+1
	lda #$ff
	sta goal_g
	lda #<gameplay_loop
	sta loop_pointer
	lda #>gameplay_loop
	sta loop_pointer+1
		lda #$01
		jsr music_loadsong
	jmp end_loop

gameplay_loop:
	jsr snail_move					; (controls.asm)
	jsr animate_snail				; (controls.asm)
	jsr gameplay_controls			; (controls.asm)
	jsr test_maze_done				; (sprites.asm)
	jsr clock						; (timer.asm)
	jsr nmi_wait
	jmp end_loop

win_loop:
	lda one_second					; This loop is just a delay to allow
	sec                             ;  the music to play out before setting
	sbc #$01						;  the reset flag (reset_game) to allow
	sta one_second					;  for a reset to happen (snail.asm).
	bne @end						;
		lda #$3c					;
		sta one_second				;
		lda big_seconds				;
		sec							;
		sbc #$01					;
		sta big_seconds				;
		bne @end					;
			lda #$01				;
			sta reset_game			;
@end:
	jsr nmi_wait
	jmp end_loop

end_level_loop:
	lda one_second					; This loop is just a delay to allow
	sec								;  the music to play out.
	sbc #$01						;
	sta one_second					;
	bne @end						;
		lda #$3c					;
		sta one_second				;
		lda big_seconds				;
		sec							;
		sbc #$01					;
		sta big_seconds				;
		cmp #$01					; With a second left, hide the sprites.
		bne @test_zero				;
			lda #$ff				;
			sta snail_head			;
			sta snail				;
			sta goal_flag1			;
			sta goal_flag2			;
			sta goal_flag3			;
			sta goal_flag4			;
			sta goal_flag5			;
			sta start_s				;
			sta goal_g				;
			jmp @end				;
@test_zero:
	lda big_seconds
	bne @end
		lda round_offset			; If round_offset is at 12 (#$0c),
		cmp #$0c					;  then we need to set up for the
		bne :+						;  game ending.
			lda #$01				; Set latch for printing CONGRATULATIONS
			sta game_beaten			;  in the next NMI.
			lda #<win_loop			; Set loop_pointer to go to win_loop
			sta loop_pointer		;  after the next NMI.
			lda #>win_loop			;
			sta loop_pointer+1		;
			lda #$03				; Load the ending music.
			jsr music_loadsong		;
			lda #$3c				; Set up for a long delay at the end
			sta one_second			;  of the game.
			lda #$0a				;
			sta big_seconds			;
			jmp @end
:		lda #<round_setup			; Make it so round_setup is the next
		sta loop_pointer			;  point we jump to at the end of this
		lda #>round_setup			;  loop.
		sta loop_pointer+1			;
@end:
	jsr nmi_wait
	jmp end_loop

lose_loop:
	jsr animate_that_smeg			; (see the routine below)
	lda #$57						; The following sprites already had
	sta letter_t					;  the X axis properly aligned in
	sta letter_i					;  sprites.asm, so we only need to
	sta letter_m					;  give them a Y value to bring them
	sta letter_e					;  on-screen for their proper placement.
	sta letter_blank				;
	sta letter_u					;
	sta letter_p					;
	lda one_second					; Just another delay. I probably could've
	sec								;  just made this a separate routine.
	sbc #$01						;  Hindsight, and all that jazz.
	sta one_second					;
	bne @end						;
		lda #$3c					;
		sta one_second				;
		lda big_seconds				;
		sec							;
		sbc #$01					;
		sta big_seconds				;
		bne @end
			lda #$01				; Set the reset latch.
			sta reset_game			;
@end:
	jsr nmi_wait
	jmp end_loop

; Used for the routine animate_that_smeg, just below.
;  It's yellow, then white, yellow, then white, yellow... etc.
pal_animation1:
	.byte $27,$30

; There is only one place in the game that needs a palette
;  animation, and that is when you lose the game. As such,
;  I have hard-coded certain values instead of using extra
;  RAM.
animate_that_smeg:
	dec anim_ticker					; anim_ticker was set to #$0a towards
	bne :++							;  the beginning of the program.
		lda #$0a					;  When it is zero, reset it to the
		sta anim_ticker				;  same value (it's a delay).
		ldx anim_offset				; If anim_offset is 1, then set it
		cpx #$01					;  back to zero. This is used to find
		bne :+						;  the proper value in pal_animation1.
			ldx #$00				;
			stx anim_offset			;
			jmp @next
:		inx
		stx anim_offset
		jmp @next
:	ldx anim_offset					; Put the data in the proper palette
	lda pal_animation1, x			;  using the value in anim_offset
	sta pal_address+31				;
@next:
	rts
