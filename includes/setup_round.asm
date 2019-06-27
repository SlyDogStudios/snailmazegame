round_setup:
	ldx round_offset
	beq :+
		lda #<level_done_loop
		sta loop_pointer
		lda #>level_done_loop
		sta loop_pointer+1
		jmp :++
:	lda #<scroll_loop
	sta loop_pointer
	lda #>scroll_loop
	sta loop_pointer+1
:	lda round_tiles_lo_line00, x
	sta line00
	lda round_tiles_hi_line00, x
	sta line00+1
	lda round_tiles_lo_line01, x
	sta line01
	lda round_tiles_hi_line01, x
	sta line01+1
	lda round_tiles_lo_line02, x
	sta line02
	lda round_tiles_hi_line02, x
	sta line02+1
	lda round_tiles_lo_line03, x
	sta line03
	lda round_tiles_hi_line03, x
	sta line03+1
	lda round_tiles_lo_line04, x
	sta line04
	lda round_tiles_hi_line04, x
	sta line04+1
	lda round_tiles_lo_line05, x
	sta line05
	lda round_tiles_hi_line05, x
	sta line05+1
	lda round_tiles_lo_line06, x
	sta line06
	lda round_tiles_hi_line06, x
	sta line06+1
	lda round_tiles_lo_line07, x
	sta line07
	lda round_tiles_hi_line07, x
	sta line07+1
	lda round_tiles_lo_line08, x
	sta line08
	lda round_tiles_hi_line08, x
	sta line08+1
	lda round_tiles_lo_line09, x
	sta line09
	lda round_tiles_hi_line09, x
	sta line09+1
	lda round_tiles_lo_line10, x
	sta line10
	lda round_tiles_hi_line10, x
	sta line10+1
	lda round_tiles_lo_line11, x
	sta line11
	lda round_tiles_hi_line11, x
	sta line11+1
	lda round_tiles_lo_line12, x
	sta line12
	lda round_tiles_hi_line12, x
	sta line12+1
	lda round_tiles_lo_line13, x
	sta line13
	lda round_tiles_hi_line13, x
	sta line13+1
	lda round_tiles_lo_line14, x
	sta line14
	lda round_tiles_hi_line14, x
	sta line14+1
	lda round_tiles_lo_line15, x
	sta line15
	lda round_tiles_hi_line15, x
	sta line15+1
	lda round_tiles_lo_line16, x
	sta line16
	lda round_tiles_hi_line16, x
	sta line16+1
	lda maze_addy_pos_lo, x
	sta maze_addy_pos
	lda maze_addy_pos_hi, x
	sta maze_addy_pos+1
	lda maze_addy_sprites_y_lo, x
	sta maze_addy_sprites_y
	lda maze_addy_sprites_y_hi, x
	sta maze_addy_sprites_y+1
	lda maze_addy_sprites_x_lo, x
	sta maze_addy_sprites_x
	lda maze_addy_sprites_x_hi, x
	sta maze_addy_sprites_x+1
	ldy #$00
:	lda (maze_addy_pos), y
	sta snail_y_pos, y
	iny
	cpy #$04
	bne :-
	ldy #$00
:	lda (maze_addy_sprites_y), y
	sta head_sprite_y, y
	lda (maze_addy_sprites_x), y
	sta head_sprite_x, y
	iny
	cpy #$09
	bne :-
	ldy #$00
	sty bg_addy_offset
	iny
	sty lay_tiles
	lda #$3c
	sta one_second

	jsr nmi_wait
