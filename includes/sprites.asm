; Initial sprite definitions to start the game. They
;  get brought in by the routine load_sprites (see below)
;  and that is called towards the end of reset (reset.asm).
sprite_definitions:
	.byte $3e,$14,$02,$d7 ; sprite0
	.byte $ff,$15,$02,$ff ; snail_head
	.byte $ff,$0b,$00,$ff ; snail
	.byte $ff,$06,$01,$ff ; goal_flag1
	.byte $ff,$07,$01,$ff ; goal_flag2
	.byte $ff,$08,$01,$ff ; goal_flag3
	.byte $ff,$09,$01,$ff ; goal_flag4
	.byte $ff,$0a,$01,$ff ; goal_flag5
	.byte $ff,$53,$03,$ff ; start_s
	.byte $ff,$47,$03,$ff ; goal_g
	.byte $ff,$20,$03,$a8 ; round_first
	.byte $ff,$31,$03,$b0 ; round_second
	.byte $ff,$36,$03,$e8 ; time_first
	.byte $ff,$30,$03,$f0 ; time_second
	.byte $ff,$d6,$03,$68 ; T
	.byte $ff,$d7,$03,$70 ; I
	.byte $ff,$d8,$03,$78 ; M
	.byte $ff,$d9,$03,$80 ; E
	.byte $ff,$13,$03,$88 ; 
	.byte $ff,$da,$03,$90 ; U
	.byte $ff,$db,$03,$98 ; P

; Routine to pull sprites into sprite RAM
;  located in the $200 page.
load_sprites:
	ldx #$00						; Pull in bytes for sprites and their
:	lda sprite_definitions, x		; attributes which are stored in the
	sta sprite0, x					; 'sprite_definitions' table. Use X as an index
	inx								; to load and store each byte, which
	cpx #$54						; get stored starting in $200, where
	bne :-							; 'sprite0' is located at.
	rts

maze_addy_sprites_y_lo:
	.byte <maze1_sprites_y,<maze2_sprites_y,<maze3_sprites_y,<maze4_sprites_y,<maze5_sprites_y,<maze6_sprites_y
	.byte <maze7_sprites_y,<maze8_sprites_y,<maze9_sprites_y,<maze10_sprites_y,<maze11_sprites_y,<maze12_sprites_y
maze_addy_sprites_y_hi:
	.byte >maze1_sprites_y,>maze2_sprites_y,>maze3_sprites_y,>maze4_sprites_y,>maze5_sprites_y,>maze6_sprites_y
	.byte >maze7_sprites_y,>maze8_sprites_y,>maze9_sprites_y,>maze10_sprites_y,>maze11_sprites_y,>maze12_sprites_y
maze_addy_sprites_x_lo:
	.byte <maze1_sprites_x,<maze2_sprites_x,<maze3_sprites_x,<maze4_sprites_x,<maze5_sprites_x,<maze6_sprites_x
	.byte <maze7_sprites_x,<maze8_sprites_x,<maze9_sprites_x,<maze10_sprites_x,<maze11_sprites_x,<maze12_sprites_x
maze_addy_sprites_x_hi:
	.byte >maze1_sprites_x,>maze2_sprites_x,>maze3_sprites_x,>maze4_sprites_x,>maze5_sprites_x,>maze6_sprites_x
	.byte >maze7_sprites_x,>maze8_sprites_x,>maze9_sprites_x,>maze10_sprites_x,>maze11_sprites_x,>maze12_sprites_x
maze_addy_pos_lo:
	.byte <maze1_pos,<maze2_pos,<maze3_pos,<maze4_pos,<maze5_pos,<maze6_pos
	.byte <maze7_pos,<maze8_pos,<maze9_pos,<maze10_pos,<maze11_pos,<maze12_pos
maze_addy_pos_hi:
	.byte >maze1_pos,>maze2_pos,>maze3_pos,>maze4_pos,>maze5_pos,>maze6_pos
	.byte >maze7_pos,>maze8_pos,>maze9_pos,>maze10_pos,>maze11_pos,>maze12_pos

; Find out if the snail is on the same space as
;  the goal.
test_maze_done:
	lda snail_y_pos					; Test to see if the Y pos of the
	cmp goal_y_pos					;  snail and goal match up. If not,
	bne @not_done					;  branch out.
		lda snail_x_pos				; If the Y pos test matches, check
		cmp goal_x_pos				;  the X pos of each. If not, branch
		bne @not_done				;  out.
			lda round_offset		; When both tests pass, set up for
			clc						;  the end of level loop by increasing
			adc #$01				;  the round, changing the pointer for
			sta round_offset		;  the main loop to end_level_loop
			lda #<end_level_loop	;  (game_loops.asm), load some values
			sta loop_pointer		;  in one_second and big_seconds to
			lda #>end_level_loop	;  have a time delay in the next loop,
			sta loop_pointer+1		;  and load the jingle for beating
			lda #$3c				;  a round.
			sta one_second			;
			lda #$02				;
			sta big_seconds			;
			lda #$02				;
			jsr music_loadsong		;
@not_done:
	rts

; These values get stored into RAM and used to make
;  certain things happen (flashing flag, goal, and start point).
;  The snail is just brought it as to have its proper place
;  on the screen.
maze1_sprites_y:	; snail_head, snail, flag1, flag2, flag3, flag4, flag5, start, goal
	.byte $d7,$d7,$60,$68,$70,$78,$80,$d7,$7f
maze1_sprites_x:
	.byte $08,$08,$f0,$f0,$f0,$f0,$f0,$08,$f0
maze1_pos:	; snail Ypos, snail Xpos, goal Ypos, goal Xpos
	.byte $10,$01,$05,$1e

maze2_sprites_y:
	.byte $bf,$bf,$58,$60,$68,$70,$78,$bf,$77
maze2_sprites_x:
	.byte $08,$08,$f0,$f0,$f0,$f0,$f0,$08,$f0
maze2_pos:
	.byte $0d,$01,$04,$1e

maze3_sprites_y:
	.byte $a7,$a7,$b8,$c0,$c8,$d0,$d8,$a7,$d7
maze3_sprites_x:
	.byte $08,$08,$50,$50,$50,$50,$50,$08,$50
maze3_pos:
	.byte $0a,$01,$10,$0a

maze4_sprites_y:
	.byte $c7,$c7,$58,$60,$68,$70,$78,$c7,$77
maze4_sprites_x:
	.byte $08,$08,$38,$38,$38,$38,$38,$08,$38
maze4_pos:
	.byte $0e,$01,$04,$07

maze5_sprites_y:
	.byte $5f,$5f,$b0,$b8,$c0,$c8,$d0,$5f,$cf
maze5_sprites_x:
	.byte $08,$08,$f0,$f0,$f0,$f0,$f0,$08,$f0
maze5_pos:
	.byte $01,$01,$0f,$1e

maze6_sprites_y:
	.byte $cf,$cf,$80,$88,$90,$98,$a0,$cf,$9f
maze6_sprites_x:
	.byte $08,$08,$68,$68,$68,$68,$68,$08,$68
maze6_pos:
	.byte $0f,$01,$09,$0d

maze7_sprites_y:
	.byte $97,$97,$70,$78,$80,$88,$90,$97,$8f
maze7_sprites_x:
	.byte $08,$08,$78,$78,$78,$78,$78,$08,$78
maze7_pos:
	.byte $08,$01,$07,$0f

maze8_sprites_y:
	.byte $97,$97,$48,$50,$58,$60,$68,$97,$67
maze8_sprites_x:
	.byte $08,$08,$e0,$e0,$e0,$e0,$e0,$08,$e0
maze8_pos:
	.byte $08,$01,$02,$1c

maze9_sprites_y:
	.byte $77,$77,$b0,$b8,$c0,$c8,$d0,$77,$cf
maze9_sprites_x:
	.byte $08,$08,$e8,$e8,$e8,$e8,$e8,$08,$e8
maze9_pos:
	.byte $04,$01,$0f,$1d

maze10_sprites_y:
	.byte $5f,$5f,$40,$48,$50,$58,$60,$5f,$5f
maze10_sprites_x:
	.byte $08,$08,$e8,$e8,$e8,$e8,$e8,$08,$e8
maze10_pos:
	.byte $01,$01,$01,$1d

maze11_sprites_y:
	.byte $7f,$7f,$60,$68,$70,$78,$80,$7f,$7f
maze11_sprites_x:
	.byte $08,$08,$f0,$f0,$f0,$f0,$f0,$08,$f0
maze11_pos:
	.byte $05,$01,$05,$1e

maze12_sprites_y:
	.byte $5f,$5f,$88,$90,$98,$a0,$a8,$5f,$a7
maze12_sprites_x:
	.byte $08,$08,$c0,$c0,$c0,$c0,$c0,$08,$c0
maze12_pos:
	.byte $01,$01,$0a,$18
