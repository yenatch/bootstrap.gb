NUM_TASKS EQU 8
TASK_LENGTH EQU 1 + 3 + 6

RSRESET
TASK_ON   RB 1
TASK_FUNC RB 3
TASK_DATA RB 6


section "task wram", wram0

wTasks:
	ds TASK_LENGTH * NUM_TASKS


section "task", rom0

CreateTask::
; Create a new task and set its function to a:de.
; Return its id in a and its address in hl.
; If there were no available tasks, return carry.
	push de
	ld d, a
	push de
	call ReserveTask
	pop de
	ld a, d
	pop de
	ret c
	; fallthrough

SetTaskFunc::
; Set the function of the task at hl to a:de.
	inc hl
	ld [hl], a
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	dec hl
	dec hl
	dec hl
	ret

ReserveTask::
; Reserve a new task.
; Return its id in a and its address in hl.
; If there are no available tasks, return carry.

	ld hl, wTasks
	ld de, TASK_LENGTH
	ld c, 0
.next:
	ld a, [hl]
	and a
	jr z, .found
	add hl, de
	inc c
	ld a, c
	cp NUM_TASKS
	jr c, .next

.failed:
	scf
	ret

.found:
	ld [hl], 1
	ld a, c
	ret

GetTask::
; Get task a.
	ld hl, wTasks
	ld de, TASK_LENGTH
	and a
	ret z

	ld c, a
.loop:
	add hl, de
	dec c
	jr nc, .loop
	ret

DestroyTask::
; Free task a.
	call GetTask
	ld [hl], 0
	ret

RunTasks::
; Call all the active tasks.
; Enter with a = taskId, hl = &task->data

	ld hl, wTasks
	ld de, TASK_LENGTH - 1
	ld c, 0
.loop:
	ld a, [hli]
	and a
	jr z, .next

	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	inc hl

	ld a, [hROMBank]
	push af
	ld a, b
	rst Bankswitch

	ld a, c
	push hl
	call __de__
	pop hl

	pop af
	rst Bankswitch

	ld de, TASK_LENGTH - 4

.next:
	add hl, de
	inc c
	ld a, c
	cp NUM_TASKS
	jr c, .loop

	ret
