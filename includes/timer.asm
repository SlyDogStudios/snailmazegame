; Routine to run the clock during gameplay_loop (game_loops.asm)
clock:
	lda one_second				; Decrement the counter one_second every frame
	sec							;  which starts out as #$3c (60)
	sbc #$01
	sta one_second
	cmp #$1e					; Compare the one_second counter to 30, which is half
	bne :+						;  the time of a second (60 frames==1 second)
		lda #$ff				; If it is at 30 ticks on the one_second counter
		sta goal_flag1			;  put the Goal Flag sprites and the Start sprite
		sta goal_flag2			;  off-screen...
		sta goal_flag3
		sta goal_flag4
		sta goal_flag5
		sta start_s
		lda goal_sprite_y		; Use what is stored in RAM from the end of the routine
		sta goal_g				;  round_setup (setup_round.asm) to put the 
		jmp @done				;  Goal sprite on-screen, then jump to finish up
:	lda one_second
	beq :+
		jmp @done
:	lda flag1_sprite_y			; When one_second hits zero, use RAM from
	sta goal_flag1				;  the end of the routine round_setup(setup_round.asm)
	lda flag2_sprite_y			;  and bring the Goal Flag sprites and 
	sta goal_flag2				;  the Start flag on-screen...
	lda flag3_sprite_y			;
	sta goal_flag3				;
	lda flag4_sprite_y			;
	sta goal_flag4				;
	lda flag5_sprite_y			;
	sta goal_flag5				;
	lda start_sprite_y			;
	sta start_s					;
	lda #$ff					; ... and store the Goal sprite off-screen
	sta goal_g					;

	lda time_second+1			; Check if the sprite time_second+1 has
	cmp #$30					;  a zero tile in it (#$30 ascii). 
	beq :+						;
		lda time_second+1		; If not, just decrement the sprite to 
		sec						;  the next ascii number down and jump
		sbc #$01				;  down to refill the counter one_second 
		sta time_second+1		;  to #$3c (60).
		jmp @restore_counter	;
:	lda #$39					; If it did have a zero tile in it, instead
	sta time_second+1			;  of decrementing, we put a #$39 tile (9)
	lda time_first+1			; If the tens place has a blank tile in it
	cmp #$20					;  (#$20), then jump to restore the counter
	bne :+						;  one_second.
		jmp @restore_counter	;
:	sec							; Since we wrapped a 0 to 9 in time_second+1
	sbc #$01					;  we need to decrement the tens place by
	sta time_first+1			;  one. Then we compare to find out if the 
	cmp #$30					;  tens place has a value of zero. If it
	bne @restore_counter		;  does, then we need to put a blank tile
		lda #$20				;  instead of leaving an ugly zero hanging
		sta time_first+1		;  out on the screen.
@restore_counter:
	lda #$3c					; Here's where the counter one_second is
	sta one_second				;  restored to 60, to make for a full second
@done:
	lda time_first+1			; Check if the tens place of the clock
	cmp #$20					;  is a blank tile. If not, rts. If so,
	bne :+						;  then test if the ones place of the
		lda time_second+1		;  clock is a zero tile (#$30 ascii).
		cmp #$30				;  If not, branch and rts.
		bne :+					;
			lda #$3c			; If time is all out, then set up the
			sta one_second		;  next loop to be used, lose_loop
			lda #$04			;  (game_loops.asm) and get the seconds
			sta big_seconds		;  ready for a time delay.
			lda #<lose_loop
			sta loop_pointer
			lda #>lose_loop
			sta loop_pointer+1
:	rts

; Routine to add time to the timer at the end of each round
;  during level_done_loop (game_loops.asm)
add_time:
	lda time_first+1
	cmp #$20
	bne :+
		lda #$30
		sta time_first+1
:	ldx round_offset
	lda time_second_increase, x
	sta temp
@time_second_add:
	lda temp
	beq @time_first_add
		lda time_second+1
		clc
		adc #$01
		sta time_second+1
		cmp #$3a
		bne :+
			lda #$30
			sta time_second+1
			lda time_first+1
			clc
			adc #$01
			sta time_first+1
:		lda temp
		sec
		sbc #$01
		sta temp
		jmp @time_second_add
@time_first_add:
	lda time_first_increase, x
	sta temp
:	lda time_first+1
	clc
	adc #$01
	sta time_first+1
	cmp #$3a
	bcc :+
		lda #$39
		sta time_first+1
		sta time_second+1
:	lda temp
	sec
	sbc #$01
	sta temp
	bne :--
	rts

time_first_increase:
	.byte $00,$03,$03,$02,$03,$03,$03,$03,$03,$03,$01,$01
time_second_increase:
	.byte $00,$00,$05,$05,$05,$05,$00,$05,$05,$05,$00,$05
