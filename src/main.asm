include "constants.asm"


section "Main", rom0

Main::

; There should be some code here. In the meantime, loop forever.
; Disable interrupts and halt to conserve battery.

	di
.done
	halt
	jr .done
