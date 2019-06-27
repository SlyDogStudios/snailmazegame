logo1:
	.byte $dc,$dd,$de,$df,$e0,$e1
logo2:
	.byte $e2,$e3,$e4,$e5,$e6,$e7
logo3:
	.byte $e8,$e9,$ea,$eb,$ec,$ed
logo4:
	.byte $ee,$ef,$f0,$f1,$f2,$f3
logo5:
	.byte $f4,$f5,$f6,$f7,$f8,$f9
logo6:
	.byte $fa,$fb,$fc,$fd,$fe,$ff

slydogstudios:
;	.byte "SLY DOG STUDIOS (2012)"
	.byte $80,$81,$82,$20,$83,$84,$85,$20,$80,$86,$87,$83,$88,$84,$80,$20,$8c,$89,$8a,$8b,$89,$8d

splash_table:
	.byte $00,$02,$04,$06,$08,$0a,$0c,$0e,$10,$12,$14,$16,$18,$1a,$1c,$1e

the_splash:
	lda #$22
	sta $2006
	lda #$c2
	sta $2006
	ldx #$00
:	lda logo1, x
	sta $2007
	inx
	cpx #$06
	bne :-
	lda #$22
	sta $2006
	lda #$e2
	sta $2006
	ldx #$00
:	lda logo2, x
	sta $2007
	inx
	cpx #$06
	bne :-
	lda #$23
	sta $2006
	lda #$02
	sta $2006
	ldx #$00
:	lda logo3, x
	sta $2007
	inx
	cpx #$06
	bne :-
	lda #$23
	sta $2006
	lda #$22
	sta $2006
	ldx #$00
:	lda logo4, x
	sta $2007
	inx
	cpx #$06
	bne :-
	lda #$23
	sta $2006
	lda #$42
	sta $2006
	ldx #$00
:	lda logo5, x
	sta $2007
	inx
	cpx #$06
	bne :-
	lda #$23
	sta $2006
	lda #$62
	sta $2006
	ldx #$00
:	lda logo6, x
	sta $2007
	inx
	cpx #$06
	bne :-

	lda #$23
	sta $2006
	lda #$69
	sta $2006
	ldx #$00
:	lda slydogstudios, x
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
