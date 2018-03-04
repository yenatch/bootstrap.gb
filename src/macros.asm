put: macro
	ld a, \2
	ld \1, a
endm

ldx: macro
	rept _NARG
	ld \1, a
	shift
	endr
endm

farcall: macro
	rst FarCall
	db  bank(\1)
	dw  \1
endm

callback: macro
	ld a, bank(\1)
	ld hl, \1
	call Callback
endm

task: macro
	ld a, bank(\1)
	ld de, \1
	call CreateTask
endm

fill: macro
	ld hl, \1
	ld bc, \2
.loop\@
	ld [hl], \3
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop\@
endm


RGB: macro
	db (\1) + (\2) << 5 + (\3) << 10
endm


enum_start: macro
	if _NARG
__enum__ = \1
	else
__enum__ = 0
	endc
endm

enum: macro
	rept _NARG
\1 = __enum__
__enum__ = __enum__ + 1
	shift
	endr
endm
