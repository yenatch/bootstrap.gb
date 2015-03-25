BUTTONS = $10
D_PAD   = $20
DONE    = $30


section "joypad", rom0

Joypad::
	put [rJOYP], D_PAD
	rept 2
	ld a, [rJOYP]
	endr

	cpl
	and %1111
	swap a

	ld b, a

	put [rJOYP], BUTTONS
	rept 6
	ld a, [rJOYP]
	endr

	cpl
	and %1111
	or b

	ld b, a

	put [rJOYP], DONE

	ld a, [wJoy]
	ld [wJoyLast], a
	ld e, a
	xor b
	ld d, a

;	ld a, d
	and e
	ld [wJoyReleased], a

	ld a, d
	and b
	ld [wJoyPressed], a

	ld a, b
	ld [wJoy], a

	ret


section "joypad wram", wram0

wJoy::         db
wJoyLast::     db
wJoyPressed::  db
wJoyReleased:: db
