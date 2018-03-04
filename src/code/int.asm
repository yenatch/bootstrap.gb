; Hardware interrupts

section "vblank int", rom0 [$40]
	jp VBlank

section "hblank int", rom0 [$48]
	reti

section "timer int",  rom0 [$50]
	reti

section "serial int", rom0 [$58]
	reti

section "joypad int", rom0 [$60]
	reti



section "vblank", rom0

VBlank:
	push af
	push bc
	push de
	push hl

	call LoadGfxQueue
	call nc, RunCallbacks

	call RunTasks

	put [wVBlank], 1

	pop hl
	pop de
	pop bc
	pop af
	reti


section "vblank wait", rom0

WaitVBlank::
	xor a
	ld [wVBlank], a
.wait
	halt
	ld a, [wVBlank]
	and a
	jr z, .wait
	ret


section "vblank wram", wram0

wVBlank:: db


INCLUDE "code/video/queue.asm"
INCLUDE "code/video/callback.asm"
