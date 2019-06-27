; This relies on the ability of the assembler to read labels and put data bytes
; and all that other good stuff. No actual assembly is used here, just data.

;;;;;;;;;;;;;;;;;
;;  envelopes  ;;
;;;;;;;;;;;;;;;;;
;; 10 - Jump to position XX
;; FF - Stop envelope

; Each byte is just simply written to register 0 of whatever channel is using the
; envelope, after one of the useless bits being masked out so commands (yep, all
; two of them) could exist. Triangle channel completely ignores envelopes.
; It's *highly* recommended that the first envelope is a silent one.

envelopes:
 .addr	env_blank, env_lead1, env_nse_hat, env_nse_hat2, env_nse_snare, env_lead2,bass_drum1,blah
env_blank:
 .byte	$00,$FF
env_lead1:
 .byte	$0F,$0D,$0B,$09,$07,$05,$04,$04,$04,$04,$05,$05,$06,$06,$06,$06,$05,$05,$10,$06
env_nse_hat:
 .byte	$0F,$0C,$00,$FF
env_nse_hat2:
 .byte	$0F,$0B,$07,$03,$FF
env_nse_snare:
 .byte	$0F,$08,$0C,$06,$04,$03,$02,$02,$01,$01,$00,$FF
env_lead2:
 .byte	$8C,$8E,$8F,$8E,$8C,$8A,$89,$88,$87,$86,$85,$84,$FF
bass_drum1:
	.byte $0f,$10,$12,$16,$19,$1e,$22,$27,$30,$21,$20,$1a,$19,$16,$14,$10,$0f,$ff
blah:
	.byte $01,$ff

;;;;;;;;;;;;;;;;;;
;;  song table  ;;
;;;;;;;;;;;;;;;;;;
; This determines what song is assigned to what value when loading songs
songs:
	.addr silence, snail_play, snail_end, snail_beat, snail_splash

;;;;;;;;;;;;;
;;  songs  ;;
;;;;;;;;;;;;;
;; C8 XX - silent rest for XX cycles
;; C0 XX - do nothing (just extend the note for another XX cycles)
;; C1 XX - precut (cut the note XX cycles before it ends)
;; C2 XX - set envelope to XX
;; C3 YY XX ZZ - jump to YYXX, ZZ times
;; C4 YY XX - jump to YYXX
;; C5 XX - set detune to XX (01-7F up, 80-FF down, 00 none)
;; C6 XX - decrease envelope volume by XX
;; C7 XX - set pitch bend to XX (01-7F down, 80-FE up, 00 none)
;; C9 XX - set tempo-independent pitch bend (functions the same as C7)
;; FF - Track end (the track stops playing here)

; The first 4 words in the list are the pointer for square 1, square 2, tri, noise
; in that order, followed by a byte that defines the tempo. Lower values are
; slower, higher are faster, 00 is infinitely slow, making the song stop.
; If you don't use a particular channel for a song, just put $0000 as the pointer.
; All four channels can be used at once. It's *highly* recommended that you reserve
; one song in your playlist to be a silent song.

silence:
	.word $0000, $0000, $0000, $0000
	.byte $00
snail_play:
	.addr snail_play_sq1, snail_play_sq2, snail_play_tri, snail_play_nse
	.byte $80
snail_end:
	.addr snail_end_sq1, snail_end_sq2, snail_end_tri, snail_end_nse
	.byte $c0
snail_beat:
	.addr snail_beat_sq1, snail_beat_sq2, snail_beat_tri, snail_beat_nse
	.byte $c0
snail_splash:
	.addr snail_splash_sq1, snail_splash_sq2, snail_splash_tri, snail_splash_nse
	.byte $c0

; Song data is just <note> <duration> for each note, or <command> <data>... for
; commands (see table above). For <note>, the higher nybble is the actual note
; (the scale begins with A, so 0x is A, 1x is A#, 2x is B, etc), and the lower
; nybble is the octave. The tracks are state machines, so whatever commands you
; apply (like envelope, detune, pitch bend, etc) will stick until you change them,
; or until a new song is loaded.

; *******************************************************
; Game play                                             *
; *******************************************************
snail_play_sq1:
	.byte $c2,$05
	.byte $c1,$04
	.byte $02,$08, $72,$08, $32,$08, $72,$08, $52,$08, $22,$08, $32,$08, $22,$08
	.byte $02,$08, $22,$08, $32,$08, $22,$08, $71,$08, $81,$08, $71,$08, $c8,$08
	.byte $02,$08, $72,$08, $32,$08, $72,$08, $52,$08, $22,$08, $32,$08, $22,$08
	.byte $32,$08, $22,$08, $02,$08, $a1,$08, $02,$08, $02,$08, $02,$08, $c8,$08
	.byte $c4,<snail_play_sq1,>snail_play_sq1
snail_play_sq2:
	.byte $c2,$05
	.byte $c1,$04
	.byte $01,$08, $02,$08, $01,$08, $02,$08, $51,$08, $52,$08, $71,$08, $72,$08
	.byte $01,$08, $72,$08, $01,$08, $02,$08, $80,$08, $21,$08, $80,$08, $71,$08
	.byte $01,$08, $02,$08, $01,$08, $02,$08, $51,$08, $52,$08, $71,$08, $72,$08
	.byte $01,$08, $72,$08, $01,$08, $71,$08, $01,$08, $02,$08, $01,$08, $c8,$08
	.byte $c4,<snail_play_sq2,>snail_play_sq2
snail_play_tri:
	.byte $c1,$04
	.byte $02,$08, $72,$08, $32,$08, $72,$08, $52,$08, $22,$08, $32,$08, $22,$08
	.byte $02,$08, $22,$08, $32,$08, $22,$08, $71,$08, $81,$08, $71,$08, $c8,$08
	.byte $02,$08, $72,$08, $32,$08, $72,$08, $52,$08, $22,$08, $32,$08, $22,$08
	.byte $32,$08, $22,$08, $02,$08, $a1,$08, $02,$08, $02,$08, $02,$08, $c8,$08
	.byte $c4,<snail_play_tri,>snail_play_tri
snail_play_nse:
	.byte $c2,$04
	.byte $00,$08, $0d,$08, $00,$04, $00,$04, $0d,$08
	.byte $c4,<snail_play_nse,>snail_play_nse

; *******************************************************
; End of level                                          *
; *******************************************************
snail_end_sq1:
	.byte $c2,$05
	.byte $32,$08, $22,$08, $32,$08, $72,$08, $32,$08, $72,$08, $03,$18
	.byte $ff
snail_end_sq2:
	.byte $c2,$05
	.byte $02,$08, $a1,$08, $02,$08, $32,$08, $02,$08, $32,$08, $82,$18
	.byte $ff
snail_end_tri:
	.byte $c1,$01
	.byte $03,$08, $03,$08, $03,$08, $72,$08, $72,$08, $72,$08, $33,$18
	.byte $ff
snail_end_nse:
	.byte $c2,$04
	.byte $0e,$08, $0e,$08, $0d,$08, $0e,$08, $0d,$08, $0e,$08, $00,$18
	.byte $ff

; *******************************************************
; Beat the game                                         *
; *******************************************************
snail_beat_sq1:
	.byte $c2,$05
	.byte $52,$08, $52,$08, $52,$08, $72,$20, $32,$18, $32,$18, $52,$18, $82,$30
	.byte $ff
snail_beat_sq2:
	.byte $c2,$05
	.byte $82,$08, $82,$08, $82,$08, $a2,$20, $72,$18, $72,$18, $82,$18, $03,$30
	.byte $ff
snail_beat_tri:
	.byte $c1,$01
	.byte $23,$08, $23,$08, $23,$08, $23,$20, $03,$18, $03,$18, $23,$18, $33,$30
	.byte $ff
snail_beat_nse:
	.byte $c2,$02
	.byte $0e,$08, $0e,$08, $0e,$08, $0d,$20, $0e,$18, $0e,$18, $0e,$18, $0d,$30
	.byte $ff

; *******************************************************
; Intro splash (might get used)                         *
; *******************************************************
; cheat sheet:
; A=0 #=1 B=2 C=3 #=4 D=5 #=6 E=7 F=8 #=9 G=a #=b
snail_splash_sq1: ; f  b b
	.byte $c2,$01
	.byte $c7,$f0,$80,$20,$c7,$00, $c8,$10, $c2,$05, $a1,$20, $a1,$28
	.byte $ff
snail_splash_sq2: ; loD hiD loD
	.byte $c2,$01
	.byte $c7,$f0,$50,$20,$c7,$00, $c8,$10, $c2,$05, $52,$20, $a0,$28
	.byte $ff
snail_splash_tri: ; hiC downtoG G
	.byte $c7,$f0,$30,$20,$c7,$00, $c8,$10, $c1,$01, $52,$20, $51,$28
	.byte $ff
snail_splash_nse: ; nada snare bass
	.byte $c2,$02, $0e,$20, $0e,$28
	.byte $ff

; Sound effects - Absolutely everything that applies for the music and songs
; applies here too, except sound effects have their own playlist and their
; own envelope table. Also, all sound effects play at tempo $100, which is
; impossible for music, since music tempo only goes up to $FF. When a sound
; effect is playing, it'll interrupt the corresponding channels of the music,
; and then when the sound effect is finished, the music channels it hogged will
; be audible again.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sound effect envelopes  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sfxenvelopes:
 .addr	sfxenv1
sfxenv1:
 .byte	$8F,$8D,$88,$8F,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86,$85,$84,$83,$82,$81,$80,$FF

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sound effect table  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
sounds:
	.addr sfx_silence
;;;;;;;;;;;;;;;;;;;;;
;;  sound effects  ;;
;;;;;;;;;;;;;;;;;;;;;
sfx_silence:
 .word	$0000, $0000, $0000, $0000

.byte "FINAL BUILD 03042012"