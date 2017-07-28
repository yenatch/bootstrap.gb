include "constants.asm"


section "Main", rom0

START_TILE = 0
X = 5
Y = 7
HEIGHT = 4
WIDTH = 10

Main::
	call .Setup
.loop
	call WaitVBlank
	jr .loop

.Setup:
	ld bc, .Graphics
	ld de, vChars2
	ld a, WIDTH * HEIGHT
	call QueueGfx

	callback .DrawTilemap

	call .SetPalette
	ret

.DrawTilemap:
	ld hl, vBGMap0 + BG_WIDTH * Y + X
	ld a, START_TILE
	ld b, HEIGHT
	ld c, WIDTH
	jp DrawTilemapRect

.SetPalette:
	ld a, %11100100 ; quaternary: 3210
	ld [rOBP0], a
	ld [rOBP1], a
	ld [rBGP], a
	ret

.Graphics:
	INCBIN "gfx/hello_world.2bpp"
