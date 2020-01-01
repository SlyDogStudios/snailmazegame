
robertlbryant:
;	.byte "ROBERT L BRYANT (2012)"
	.byte $8f,$84,$d3,$d5,$8f,$86,$20,$81,$20,$d3,$8f,$82,$8e,$7f,$86,$20,$8c,$89,$8a,$8b,$89,$8d

splash_table:
	.byte $00,$02,$04,$06,$08,$0a,$0c,$0e,$10,$12,$14,$16,$18,$1a,$1c,$1e

the_splash:
	lda #$23
	sta $2006
	lda #$45
	sta $2006
	ldx #$00
:	lda robertlbryant, x
	sta $2007
	inx
	cpx #$16
	bne :-

	lda #$23
	sta $2006
	lda #$da
	sta $2006
	lda #$ff
	sta $2007
	sta $2007
	sta $2007
	sta $2007

	lda #$23
	sta $2006
	lda #$e8
	sta $2006
	lda #$aa
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
;	lda #$23
;	sta $2006
;	lda #$f0
;	sta $2006
	lda #$aa
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007

	lda #$90
	sta sly_row1_tile
	lda #$a0
	sta sly_row2_tile
	lda #$b0
	sta sly_row3_tile
	lda #$c0
	sta sly_row4_tile
	lda #$88
	sta sly_row1_addy
	lda #$a8
	sta sly_row2_addy
	lda #$c8
	sta sly_row3_addy
	lda #$e8
	sta sly_row4_addy
	rts

message:
	.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte $20,$20,"SPECIAL THANKS TO MISTY,",$20,$20,$20,$20,$20,$20
	.byte $20,$20,"JEREMIAH, LIAM, AND GAVIN",$20,$20,$20,$20,$20
	.byte $20,$20,"BRYANT.",$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte $20,$20,"YOU ARE LOVED VERY MUCH.",$20,$20,$20,$20,$20,$20,$20,$20
	.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,"-ROB",$20,$20
