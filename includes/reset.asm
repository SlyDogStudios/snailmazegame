reset:
	jsr vblank_wait
	jsr vblank_wait
	sei
	ldx #$00
	stx $4015
	ldx #$40
	stx $4017
	ldx #$ff
	txs
	inx
	stx $2000
	stx reg2000_save
	stx $2001
	stx reg2000_save

	jsr vblank_wait

	txa

:	sta $000,x
	sta $100,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne :-
	lda #$01
	sta no_sprite0
splash:
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #$00
:	sta $2007
	sta $2007
	sta $2007
	sta $2007
	dex
	bne :-
	lda #$24
	sta $2006
	lda #$00
	sta $2006
	ldx #$00
:	sta $2007
	sta $2007
	sta $2007
	sta $2007
	dex
	bne :-

	ldx #$00
:	lda palette,x
	sta pal_address,x
	inx
	cpx #$20
	bne :-

	jsr the_splash
	jsr vblank_wait
	jsr vblank_wait
	jsr stabilize
	jsr PPU_no_sprites
	lda #$3c
	sta one_second
:	lda one_second
	sec
	sbc #$01
	sta one_second
	jsr nmi_wait
	lda one_second
	bne :-
	sta splash_offset
	lda #$01
	sta do_splash
	lda #$04
	jsr music_loadsong
	lda #$3c
	sta one_second
	lda #$05
	sta big_seconds
splash_loop:
	lda one_second
	sec
	sbc #$01
	sta one_second
	bne :+
		lda #$3c
		sta one_second
		lda big_seconds
		sec
		sbc #$01
		sta big_seconds
		cmp #$04
		bne :+
			lda #$18
			sta pal_address+9
			lda #$10
			sta pal_address+10
			lda #$30
			sta pal_address+11
:		lda big_seconds
		bne :+
			jmp done_splash

:	jsr nmi_wait
	jmp splash_loop

done_splash:
	jsr nmi_wait
	jsr PPU_off
	ldy #$00
	ldx #$04
	lda #<title
	sta $c0
	lda #>title
	sta $c1
	lda #$20
	sta $2006
	lda #$00
	sta $2006
:	lda ($c0),y
	sta $2007
	iny
	bne :-
	inc $c1
	dex
	bne :-

	jsr load_sprites				; (sprites.asm)
	lda #$00
	sta no_sprite0
	jsr vblank_wait
	jsr vblank_wait
	jsr stabilize
	jsr PPU_with_sprites

	ldx #$00
	stx anim_offset
	lda #$0a
	sta anim_ticker

loop_title:
	lda do_message
	beq :+
		jmp @done_controls
:	lda control_pad
	and #$10
	beq @no_press
		lda control_pad
		and #$01
		beq @no_press
			lda control_pad
			and #$02
			beq @no_press
				jmp done_title
@no_press:
	lda message_present
	bne @done_controls
	lda control_pad
	eor control_old
	and control_pad
	and #select_punch
	beq @done_controls
		lda #<message
		sta message_addy
		lda #>message
		sta message_addy+1
		lda #$22
		sta message_bg_addy_hi
		lda #$80
		sta message_bg_addy_lo
		lda #$00
		sta message_offset
		lda #$01
		sta do_message
@done_controls:
	jsr nmi_wait
	jmp loop_title
done_title:
	lda #$3f						; Since these sprites already had
	sta round_first					;  the X value defined, they only
	sta round_second				;  need a Y value to be brought 
	sta time_first					;  onto the screen.
	sta time_second
