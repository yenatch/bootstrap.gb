section "hl", rom0
__hl__::
	jp hl

section "de", rom0
__de__::
	push de
	ret

section "bc", rom0
__bc__::
	push bc
	ret
