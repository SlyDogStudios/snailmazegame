
gameplay_controls:
	lda no_control					; Check if player is already moving
	beq :+							;  and if so, skip directional buttons.
		jmp @no_right
:	lda control_pad					; Test for Up press
	and #up_punch
	beq @no_up
		jsr find_tile_on			; (scroll down to see this routine)

		lda snail_y_pos				; Decrement the Y pos of the player
		sec							;  to set up for the routine coming
		sbc #$01					;  up. This is to find the tile that
		tax							;  is directly above the player.
		jsr find_tile_off			; (scroll down to see this routine)
		ldy snail_x_pos				; Since we're not moving left or right,
		lda (tile_find_third), y	;  leave the X pos alone, and store
		sta tile_off				;  the tile found for testing

		lda tile_on					; Use the tile the player is on as
		tax							;  an offset, and test the "up bit"
		lda test_on, x				;  (bit 0) to see if it's possible
		and #%00000001				;  for the snail to move up out of
		bne @closed_up				;  the tile he is on.
			lda tile_off			; Use the tile above the player as
			tax						;  an offset, and test the "up bit"
			lda test_off, x			;  (bit 0) to see if it's possible
			and #%00000001			;  for the snail to move up INTO
			bne @closed_up			;  the tile above him.
				lda #$11			; If both conditions pass, then
				sta snail+1			;  initialize moving up with the
				lda #$1b			;  appropriate starting sprites,
				sta snail_head+1	;  set the switch to "1" that tells
				lda #$01			;  the program the snail is going
				sta move_snail		;  to be moving up (see snail_move
				lda #$09			;  below), set the animation count
				sta snail_count		;  to 9 (see animate_snail below),
				lda #$01			;  and turn off the directional
				sta no_control		;  buttons.
									; Note: It might not be necessary
									;  to initialize the sprites of the
									;  snail. It's possible that the
									;  animation routine below
									;  (animate_snail) would handle it
									;  just fine. However, I am putting
									;  in comments after the fact, and
									;  as such just noticed this. No harm,
									;  no foul.
@closed_up:
		;jmp @no_right
@no_up:
	lda control_pad					; Test for Down press
	and #down_punch
	beq @no_down
		jsr find_tile_on			; (scroll down to see this routine)

		lda snail_y_pos				; Since we pushed Down, we need to
		clc							;  increment the Y pos and NOT save
		adc #$01					;  it back to the Y pos. It is used
		tax							;  only to get a proper offset.
		jsr find_tile_off			; (scroll down to see this routine)
		ldy snail_x_pos				; There is no change in the X pos,
		lda (tile_find_third), y	;  so it is used as the offset.
		sta tile_off				;

		lda tile_on					; Use the tile the player is on as
		tax                         ;  an offset, and test the "down bit"
		lda test_on, x              ;  (bit 1) to see if it's possible
		and #%00000010              ;  for the snail to move down out of
		bne @closed_down            ;  the tile he is on.
			lda tile_off            ; Use the tile below the player as
			tax                     ;  an offset, and test the "down bit"
			lda test_off, x         ;  (bit 1) to see if it's possible
			and #%00000010          ;  for the snail to move down INTO
			bne @closed_down        ;  the tile below him.
				lda #$0f
				sta snail+1
				lda #$19
				sta snail_head+1
				lda #$02
				sta move_snail
				lda #$09
				sta snail_count
				lda #$01
				sta no_control

@closed_down:
		;jmp @no_right
@no_down:
	lda control_pad					; Test for Left press
	and #left_punch
	beq @no_left
		jsr find_tile_on			; (scroll down to see this routine)

		lda snail_y_pos
		tax
		jsr find_tile_off			; (scroll down to see this routine)
		lda snail_x_pos
		sec
		sbc #$01
		tay
		lda (tile_find_third), y
		sta tile_off

		lda tile_on					; Use the tile the player is on as
		tax                         ;  an offset, and test the "left bit"
		lda test_on, x              ;  (bit 2) to see if it's possible
		and #%00000100              ;  for the snail to move leftward out of
		bne @closed_left            ;  the tile he is on.
			lda tile_off            ; Use the tile left of the player as
			tax                     ;  an offset, and test the "left bit"
			lda test_off, x         ;  (bit 2) to see if it's possible
			and #%00000100          ;  for the snail to move leftward INTO
			bne @closed_left        ;  the tile left him.
				lda #$0d
				sta snail+1
				lda #$17
				sta snail_head+1
				lda #$03
				sta move_snail
				lda #$09
				sta snail_count
				lda #$01
				sta no_control

@closed_left:
		;jmp @no_right
@no_left:
	lda control_pad					; Test for Right press
	and #right_punch
	beq @no_right
		jsr find_tile_on			; (scroll down to see this routine)

		lda snail_y_pos
		tax
		jsr find_tile_off			; (scroll down to see this routine)
		lda snail_x_pos
		clc
		adc #$01
		tay
		lda (tile_find_third), y
		sta tile_off

		lda tile_on					; Use the tile the player is on as
		tax                         ;  an offset, and test the "right bit"
		lda test_on, x              ;  (bit 3) to see if it's possible
		and #%00001000              ;  for the snail to move rightward out of
		bne @closed_right           ;  the tile he is on.
			lda tile_off            ; Use the tile right of the player as
			tax                     ;  an offset, and test the "right bit"
			lda test_off, x         ;  (bit 3) to see if it's possible
			and #%00001000          ;  for the snail to move rightward INTO
			bne @closed_right       ;  the tile to the right of him.
				lda #$0b
				sta snail+1
				lda #$15
				sta snail_head+1
				lda #$04
				sta move_snail
				lda #$09
				sta snail_count
				lda #$01
				sta no_control

@closed_right:
@no_right:
;	lda control_pad					; Uncomment this section to allow the
;	eor control_old					;  Select button to be used to skip
;	and control_pad					;  levels during gameplay_loop
;	and #select_punch				;  (game_loops.asm). All it does is
;	beq @no_select					;  make the x and y positions of
;		lda #$01					;  the snail and the goal match up,
;		sta snail_y_pos				;  which effectively ends the round.
;		sta snail_x_pos				;  The routine test_maze_done handles
;		sta goal_y_pos				;  that (sprites.asm).
;		sta goal_x_pos				;
@no_select:
	rts

; Here are the tiles defined for whether or not the
;  player can move from or onto them.
; 	bit 3 = right, bit 2 = left, bit 1 = down, bit 0 = up
test_on:	; dummy,  tile 01,  tile 02,  tile 03,  tile 04,  tile 05
	.byte %00000000,%00001111,%00000000,%00000010,%00001000,%00001010
test_off:
	.byte %00000000,%00001111,%00000000,%00000001,%00000100,%00000101

; This routine finds the background tile that
;  the player is on.
find_tile_on:
	ldx snail_y_pos					; Use the Y pos as an offset
	lda find_tile_first_lo, x		; Use the offset to find which row
	sta tile_find_first				;  the player is on and load
	lda find_tile_first_hi, x		;  the hi and lo addresses into
	sta tile_find_first+1			;  a single addy (tile_find_third).
	lda find_tile_second_lo, x		;  Once we figure out what row we are
	sta tile_find_second			;  on, then we need to use the round
	lda find_tile_second_hi, x		;  that we are in to find the proper
	sta tile_find_second+1			;  row being used to lookup the tile
	ldy round_offset				;  we are on. Refer to (maze_select.asm)
	lda (tile_find_first), y		;  to see how the tables are set up
	sta tile_find_third				;  to find this data with this routine.
	lda (tile_find_second), y		;
	sta tile_find_third+1			;
	ldy snail_x_pos					; Use the player X pos as
	lda (tile_find_third), y		;  the offset to actually find the
	sta tile_on						;  proper tile and store it for testing
	rts								;

; Used to find the tile that the player is trying
;  to move into.
find_tile_off:
	lda find_tile_first_lo, x		; This is exactly like find_tile_on,
	sta tile_find_first				;  except that the Y pos and X pos
	lda find_tile_first_hi, x		;  of the player must be manipulated
	sta tile_find_first+1			;  before and after the routine,
	lda find_tile_second_lo, x		;  respectively. This is done in the
	sta tile_find_second			;  control routine, and how it is
	lda find_tile_second_hi, x		;  handled depends on the direction
	sta tile_find_second+1			;  pressed.
	ldy round_offset				;
	lda (tile_find_first), y		;
	sta tile_find_third				;
	lda (tile_find_second), y		;
	sta tile_find_third+1			;
	rts								;

snail_move:
	ldx snail_count
	lda move_snail
	bne :+
		jmp @end
:	dex
	stx snail_count
	bne :+
		jsr shift_pos		; See the routine below
		lda #$00
		sta move_snail
		sta no_control
		jmp @end
:	lda move_snail
	cmp #$01
	bne :+
		lda snail
		sec
		sbc #$01
		sta snail
		sta snail_head
		jmp @end
:	lda move_snail
	cmp #$02
	bne :+
		lda snail
		clc
		adc #$01
		sta snail
		sta snail_head
		jmp @end
:	lda move_snail
	cmp #$03
	bne :+
		lda snail+3
		sec
		sbc #$01
		sta snail+3
		sta snail_head+3
		jmp @end
:	lda snail+3
	clc
	adc #$01
	sta snail+3
	sta snail_head+3
@end:
	rts

; Routine that only shifts the Y or X pos of the snail
;  every frame according to which direction it needs
;  to go (move_snail 1=up 2=down 3=left and right is
;  the default)
shift_pos:
	lda move_snail
	cmp #$01				; Test for Up shift
	bne :+
		lda snail_y_pos
		sec
		sbc #$01
		sta snail_y_pos
		jmp @done
:	cmp #$02				; Test for Down shift
	bne :+
		lda snail_y_pos
		clc
		adc #$01
		sta snail_y_pos
		jmp @done
:	cmp #$03				; Test for Left shift
	bne :+
		lda snail_x_pos
		sec
		sbc #$01
		sta snail_x_pos
		jmp @done
:	lda snail_x_pos			; Do Right shift
	clc
	adc #$01
	sta snail_x_pos
@done:
	rts

animate_snail:
	ldx snail_count
	lda move_snail
	beq @no_animate
	cmp #$01
	bne :+
		lda snail_anim_table_up, x
		sta snail+1
		lda snail_anim_table_up2, x
		sta snail_head+1
		jmp @no_animate
:	cmp #$02
	bne :+
		lda snail_anim_table_down, x
		sta snail+1
		lda snail_anim_table_down2, x
		sta snail_head+1
		jmp @no_animate
:	cmp #$03
	bne :+
		lda snail_anim_table_left, x
		sta snail+1
		lda snail_anim_table_left2, x
		sta snail_head+1
		jmp @no_animate
:	lda snail_anim_table_right, x
	sta snail+1
	lda snail_anim_table_right2, x
	sta snail_head+1
@no_animate:
	rts

snail_anim_table_up:
	.byte $11,$11,$11,$11,$11,$12,$12,$12,$12
snail_anim_table_up2:
	.byte $1b,$1b,$1b,$1b,$1b,$1c,$1c,$1c,$1c
snail_anim_table_down:
	.byte $0f,$0f,$0f,$0f,$0f,$10,$10,$10,$10
snail_anim_table_down2:
	.byte $19,$19,$19,$19,$19,$1a,$1a,$1a,$1a
snail_anim_table_left:
	.byte $0d,$0d,$0d,$0d,$0d,$0e,$0e,$0e,$0e
snail_anim_table_left2:
	.byte $17,$17,$17,$17,$17,$18,$18,$18,$18
snail_anim_table_right:
	.byte $0b,$0b,$0b,$0b,$0b,$0c,$0c,$0c,$0c
snail_anim_table_right2:
	.byte $15,$15,$15,$15,$15,$16,$16,$16,$16
