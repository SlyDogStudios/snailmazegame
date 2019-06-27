
stabilize:
	lda #$00
	sta $2006
	sta $2006
	sta $2005
	sta $2005
	rts
nmi_wait:
	lda nmi_num						; Wait for an NMI to happen before running
:	cmp nmi_num						; the main loop again
	beq :-							;
	rts
vblank_wait:						; I think we all know what this is!
:	bit $2002
	bpl :-
	rts
PPU_off:
	lda #$00
	sta $2000
	sta reg2000_save
	sta $2001
	sta reg2001_save
	rts
PPU_with_sprites:
	lda #%10011100
	sta $2000
	sta reg2000_save
	lda #%00011010
	sta $2001
	sta reg2001_save
	rts
PPU_no_sprites:
	lda #%10001100
	sta $2000
	sta reg2000_save
	lda #%00001010
	sta $2001
	sta reg2001_save
	rts
