	pha								; Save the registers
	txa								;
	pha								;
	tya								;
	pha								;
	inc nmi_num						; Increase every NMI

	lda #$00						; Do sprite transfer
	sta $2003						;
	lda #$02						;
	sta $4014						;

	lda do_message
	beq :++
		ldy message_offset
		lda message_bg_addy_hi
		sta $2006
		lda message_bg_addy_lo
		sta $2006
		lda (message_addy), y
		sta $2007
		iny
		sty message_offset
		cpy #224
		bne :+
			lda #$00
			sta do_message
			lda #$01
			sta message_present
:		inc message_bg_addy_lo
		bne :+
			inc message_bg_addy_hi
:	lda do_splash
	beq :++
		ldx splash_offset
		lda splash_table, x
		cmp splash_count
		bne :+
		lda #$21
		sta $2006
		lda sly_row1_addy
		sta $2006	
		lda sly_row1_tile
		sta $2007
		lda #$21
		sta $2006
		lda sly_row2_addy
		sta $2006
		lda sly_row2_tile
		sta $2007
		lda #$21
		sta $2006
		lda sly_row3_addy
		sta $2006
		lda sly_row3_tile
		sta $2007
		lda #$21
		sta $2006
		lda sly_row4_addy
		sta $2006
		lda sly_row4_tile
		sta $2007
		inc splash_offset
		inc sly_row1_tile
		inc sly_row1_addy
		inc sly_row2_tile
		inc sly_row2_addy
		inc sly_row3_tile
		inc sly_row3_addy
		inc sly_row4_tile
		inc sly_row4_addy
		cmp #$cf
		bne :+
			lda #$00
			sta do_splash
:		inc splash_count		
:
	lda reg2000_save				; Refresh the palette every frame,
	and #%11111011					;  but change $2000 to increase by
	sta reg2000_save				;  1 instead of 32 first.
	sta $2000						;
	lda #$3f						;
	sta $2006						;
	ldx #$00						;
	stx $2006						;
:	lda pal_address,x				;
	sta $2007						;
	inx								;
	cpx #$20						;
	bne :-							;
	lda reg2000_save				; Make sure to change $2000 to increase
	ora #%00000100					;  the PPU by 32 again.
	sta reg2000_save				;
	sta $2000						;

	lda game_beaten					; Only run this when the game gets beaten.
	beq @tile_layer					;  It prints out CONGRATULATIONS!, which
		lda reg2000_save			;  can be found at the end of this file.
		and #%11111011				;  Once again, be sure to switch to
		sta reg2000_save			;  increasing the PPU by 1 instead of 32.
		sta $2000					;
		lda #$21					;
		sta $2006					;
		lda #$68					;
		sta $2006					;
		ldx #$00					;
:		lda beat_game, x			;
		sta $2007					;
		inx							;
		cpx #$10					;
		bne :-						;
		lda reg2000_save			;
		ora #%00000100				;
		sta reg2000_save			;
		sta $2000					;

@tile_layer:
	lda lay_tiles
	bne :+
		jmp @no_tiles
:	lda nametable_select			; Decide which address needs to
	beq :+							;  be used to write to the background
		lda #$21					;
		sta $2006					;
		jmp :++						;
:	lda #$25						;
	sta $2006						;
:	ldy bg_addy_offset				; Use the offset to find what the lo
	lda bg_addy_lo, y				;  value for $2006 should be. bg_addy_lo
	sta $2006						;  can be found in maze_select.asm.
	ldy bg_addy_offset
	lda (line00), y
	sta $2007
	lda (line01), y
	sta $2007
	lda (line02), y
	sta $2007
	lda (line03), y
	sta $2007
	lda (line04), y
	sta $2007
	lda (line05), y
	sta $2007
	lda (line06), y
	sta $2007
	lda (line07), y
	sta $2007
	lda (line08), y
	sta $2007
	lda (line09), y
	sta $2007
	lda (line10), y
	sta $2007
	lda (line11), y
	sta $2007
	lda (line12), y
	sta $2007
	lda (line13), y
	sta $2007
	lda (line14), y
	sta $2007
	lda (line15), y
	sta $2007
	lda (line16), y
	sta $2007
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	sta $2005
	sta $2005
	iny
	sty bg_addy_offset
	cpy #$20
	beq :+
		jmp @no_tiles
:	lda nametable_select
	eor #%00000001
	sta nametable_select
	lda #$00
	sta lay_tiles
@no_tiles:
	lda no_sprite0					; Skip over if sprite0 is unnecessary. Just
	beq :+							;  stabilize the screen (common.asm) and
		jsr stabilize				;  jump to the end.
		jmp @done
:	jsr stabilize
	lda #%10011100
	sta $2000
	lda reg2001_save
	sta $2001
:	bit $2002
	bvs :-
:	bit $2002
	bvc :-
	lda hscroll
	sta $2005
	lda #$00
	sta $2005
	lda #%10011100
	ora nametable
	sta $2000
	sta reg2000_save
@done:
end_nmi:
	lda #$01						; strobe controller
	sta $4016						;
	lda #$00						;
	sta $4016						;
	lda control_pad					;
	sta control_old					;
	ldx #$08						;
:	lda $4016						;
	lsr A							;
	ror control_pad					;
	dex								;
	bne :-							;

	pla								; Restore the registers
	tay								;
	pla								;
	tax								;
	pla								;
	jsr music_play					; Run the music engine
									; After looking at this, it's weird to me
									;  that the music engine is running fine
									;  after the NMI.
irq:
	rti

; Print this to screen when the game is beaten after
;  getting through the 12th maze.
beat_game:
	.byte "CONGRATULATIONS!"
