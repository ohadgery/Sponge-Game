IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
	Welcome db 10, 10, 10, 10, 10, 10, '      Welcome To SpongeBob Gaming!', 10, 10, '     Help SpongeBob Dodge Planktons' , 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, '	 Press Any Key To Start', 10, 10, '$'
	RandomNumber dw ?
	Generate dw 1
	Coordinates dw 320
	Life db 3
	Shield db 0
	KeepUdress dw ?
	Speed dw 30
	SpeedUp dw 0
	Point db 8 dup (30h)
	Score db 13, '           Your Score: $'
	EndGame db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, '		Game Over!', 10, 10, '	Press Any Key To Restart', 10, 10, '$'
CODESEG
; --------------------------
; Your proc here
; --------------------------
	proc Restart
	mov [Generate], 1
	mov [Coordinates], 320
	mov [Life], 3
	mov [Shield], 0
	mov [Speed], 32
	mov [SpeedUp], 0
	mov [Point], 30h
	mov [Point+1], 30h
	mov [Point+2], 30h
	mov [Point+3], 30h
	mov [Point+4], 30h
	mov [Point+5], 30h
	mov [Point+6], 30h
	mov [Point+7], 30h
	mov dx, 88
	ret
	endp Restart
	proc WelcomeScreen
	mov dx, offset Welcome
	mov ah, 9h
	int 21h
	mov cx, 110
	mov dx, 100
	call PaintSpongeBob
	mov cx, 180 
	mov dx, 95
	call PaintPlankton
	mov cx, 240 
	mov dx, 125
	call PaintPlankton
	mov cx, 295
	mov dx, 180
Frame1:
	call PaintKrabbyPatty
	sub cx, 40
	cmp cx, 0
	jg Frame1
	mov cx, 295
	mov dx, 10
Frame2:
	call PaintKrabbyPatty
	sub cx, 40
	cmp cx, 0
	jg Frame2
	mov cx, 295
	mov dx, 135
Frame3:
	call PaintKrabbyPatty
	sub dx, 40
	cmp dx, 40
	jg Frame3
	mov cx, 15
	mov dx, 135
Frame4:
	call PaintKrabbyPatty
	sub dx, 40
	cmp dx, 40
	jg Frame4
	mov ah, 8h
	int 21h
	ret
	endp WelcomeScreen
	proc EnterMove
	call EnterKey
	cmp al, 0
	je NoInput
	cmp dx, 14
	je MoveDown
	cmp al, 'w'
    jne MoveDown
	call ClearBelowSponeBob
	sub dx, 12
	ret
MoveDown:
    cmp dx, 186
	je NoInput
	cmp al, 's'
    jne NoInput
	call ClearAboveSponeBob
	inc dx
	ret
NoInput:
	sub dx, 11
	ret
	endp EnterMove
	proc EnterKey
    mov ah, 0Bh
    int 21h
    cmp al, 0
    je NoKey
    mov ah, 08h
    int 21h
    ret
NoKey:
    xor al, al
    ret
	endp EnterKey
	proc ClearScreen
	push ax
	xor al, al
	mov cx, 320
ClearLine:
	mov dx, 200
ClearPixal:
	call Paint
	dec dx
	cmp dx, 0ffffh
	jne ClearPixal
	loop ClearLine
	call Paint
	pop ax
	ret
	endp ClearScreen
	proc Diley
	cmp [Speed], 7
	jb KeepSpeed
	cmp [SpeedUp], 500
	jb KeepSpeed
	dec [Speed]
	mov [SpeedUp], 0
KeepSpeed:
	push cx
	mov cx, 0ffffh
FirstDiley:
	push cx
	mov cx, [Speed]
SecondDiley:
	loop SecondDiley
	pop cx
	loop FirstDiley
	pop cx
	inc [SpeedUp]
	cmp [Point], '9'
	je NoAdd
	cmp [Point+1], '9'
	jne NoAdd1
	mov [Point+1], '0'
	inc [Point]
NoAdd1:
	cmp [Point+2], '9'
	jne NoAdd2
	mov [Point+2], '0'
	inc [Point+1]
NoAdd2:
	cmp [Point+3], '9'
	jne NoAdd3
	mov [Point+3], '0'
	inc [Point+2]
NoAdd3:
	cmp [Point+4], '9'
	jne NoAdd4
	mov [Point+4], '0'
	inc [Point+3]
NoAdd4:
	cmp [Point+5], '9'
	jne NoAdd5
	mov [Point+5], '0'
	inc [Point+4]
NoAdd5:
	cmp [Point+6], '9'
	jne NoAdd6
	mov [Point+6], '0'
	inc [Point+5]
NoAdd6:
	cmp [Point+7], '9'
	jne NoAdd7
	mov [Point+7], '0'
	inc [Point+6]
	jmp NoAdd
NoAdd7:
	inc [Point+7]
NoAdd:
	mov dx, offset Score
	mov ah, 9h
	int 21h
	mov dx, offset Point
	mov ah, 9h
    int 21h
	ret
	endp Diley
	proc CheckImpact
	cmp cx, 89
	jb CheckBehindSponeBob
	ret
CheckBehindSponeBob:
	cmp cx, 52
	ja CheckBelowSponeBob
	ret
CheckBelowSponeBob:
	add dx, 25
	cmp dx, [RandomNumber]
	jg CheckAboveSponeBob
	sub dx, 25
	ret
CheckAboveSponeBob:
	sub dx, 35
	cmp dx, [RandomNumber]
	jg NoImpact
	dec [Life]
	call Sound
	mov [Shield], 100
	push cx
	push dx
	xor al, al
	mov cx, 12
	cmp [Life], 2
	jb DeleteSecondHeart1
	add cx, 18
	jmp DeleteAllHeart1
DeleteSecondHeart1:
	cmp [Life], 1
	jb DeleteThirdHeart1
	add cx, 38
	jmp DeleteAllHeart1
DeleteThirdHeart1:
	add cx, 58
DeleteAllHeart1:
	mov dx, 190
DeleteHeart:
	call Paint
	dec dx
	cmp dx, 179
	jne DeleteHeart
	cmp [Life], 2
	jb DeleteSecondHeart2
	sub cx, 18
	jmp DeleteAllHeart2
DeleteSecondHeart2:
	cmp [Life], 1
	jb DeleteThirdHeart2
	sub cx, 38
	jmp DeleteAllHeart2
DeleteThirdHeart2:
	sub cx, 58
DeleteAllHeart2:
	loop DeleteAllHeart1
	pop dx
	pop cx
NoImpact:
	add dx, 10
	ret
	endp CheckImpact
	proc Sound
	in al, 61h
	or al, 00000011b
	out 61h, al
	mov al, 0B6h
	out 43h, al
	mov ax, 2394h
	out 42h, al
	mov al, ah
	out 42h, al
	push cx
	mov cx, 0ffffh
FirstSound:
	push cx
	mov cx, 9fh
SecondSound:
	loop SecondSound
	pop cx
	loop FirstSound
	pop cx
	in al, 61h
	and al, 11111100b
	out 61h, al
	ret
	endp Sound
	proc MainScreen
	cmp [Shield], 0
	jne SkipFirstCheck
	cmp [RandomNumber], 10
	ja SkipFirstCheck
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 50
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 10
	call CheckImpact
	sub [RandomNumber], 180
SkipFirstCheck:
	cmp [Shield], 0
	ja SkipThirdCheck
	call CheckImpact
	cmp [RandomNumber], 120
	jb SkipSecondCheck
	sub [RandomNumber], 100
	call CheckImpact
	add [RandomNumber], 100
	jmp SkipThirdCheck
SkipSecondCheck:
	cmp [RandomNumber], 100
	jb SkipThirdCheck
	sub [RandomNumber], 10
	call CheckImpact
	add [RandomNumber], 20
	call CheckImpact
	sub [RandomNumber], 10
SkipThirdCheck:
	cmp [Shield], 0
	je KeepShield
	dec [Shield]
KeepShield:
	push ax
	push dx
	dec [Generate]
	jnz SkipRandomNumber
	mov [Generate], 320
	mov ax, 40h
	mov es, ax
	mov ax, [es:6Ch]
	and ax, 0000000011111111b
	cmp al, 200
	jb GoodRandom
	shr ax, 1
GoodRandom:
	mov [RandomNumber], ax
SkipRandomNumber:
	mov cx, [Generate]
	dec [Coordinates]
	call PaintObject
	mov dx, [RandomNumber]
	cmp [RandomNumber], 10
	ja SkipFirstPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 50
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	add dx, 10
	call PaintPlankton
	sub dx, 180
SkipFirstPlankton:
	call PaintPlankton
	cmp [RandomNumber], 120
	jb SkipSecondPlankton
	sub dx, 100
	call PaintPlankton
	add dx, 100
	jmp SkipThirdPlankton
SkipSecondPlankton:
	cmp [RandomNumber], 100
	jb SkipThirdPlankton
	sub dx, 10
	call PaintPlankton
	add dx, 20
	call PaintPlankton
	sub dx, 10
SkipThirdPlankton:
	call Diley
	pop dx
	pop ax
	ret
	endp MainScreen
	proc Paint
	push bx
	xor bl, bl
	mov ah,0ch
    int 10h
	pop bx
	ret
	endp Paint
	proc ClearBelowSponeBob
	push ax
	push cx
	mov cx, 89
	xor al, al
	call Paint
	dec cx
	call Paint
	dec cx
	add dx, 2
	call Paint
	add dx, 11
	mov cx, 24
ClearLineBelow:
    add cx, 62
	call Paint
	sub cx, 62
	loop ClearLineBelow
	mov cx, 62
	sub dx, 11
	call Paint
	sub dx, 2
	dec cx
	call Paint
	dec cx
	call Paint
	pop cx
	pop ax
	ret
	endp ClearBelowSponeBob
	proc ClearAboveSponeBob
	push ax
	push cx
	mov cx, 89
	xor al, al
	sub dx, 11
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	sub dx, 3
	call Paint
	dec cx
	inc dx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	dec dx
	call Paint
	dec cx
	call Paint
	dec cx
	inc dx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	dec dx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	inc dx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	dec dx
	call Paint
	dec cx
	inc dx
	call Paint
	dec cx
	call Paint
	dec cx
	add dx, 2
	call Paint
	dec cx
	call Paint
	dec cx
	call Paint
	dec cx
	pop cx
	pop ax
	ret
	endp ClearAboveSponeBob
	proc PaintSpongeBob
	push ax
	mov al, 11
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 1
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 11
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 11
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 11
	mov al, 1
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 8
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 8
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	mov al, 6
	sub dx, 15
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	mov al, 6
	sub dx, 26
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	mov al, 14
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
    inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 27
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al ,al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	mov al, 15
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	dec al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 26
	mov al, 6
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 6
	inc cx
	sub dx, 27
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 45
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 14
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 24
	mov al, 1
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 8
	inc dx
	call Paint
	xor al, al
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 8
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 13
	mov al, 1
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 11
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc cx
	sub dx, 11
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	mov al, 1
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	inc dx
	call Paint
	pop ax
	ret
	endp PaintSpongeBob
	proc PaintObject
	push cx
	mov cx, [Coordinates]
	mov dx, 25
	call PaintStar
	add cx, 80
	call PaintKrabbyPatty
	add cx, 80
	call PaintStar
	sub cx, 100
	mov dx, 75
	call PaintStar
	add cx, 200
	call PaintStar
	sub cx, 100
	mov dx, 125
	call PaintStar
	add cx, 120
	call PaintEarth
	sub cx, 240
	mov dx, 175
	call PaintStar
	add cx, 100
	call PaintStar
	sub cx, 140
	push dx
	cmp [Life], 3
	jb SecondHeart
	mov cx, 20
	mov dx, 180
	call PaintHeart
SecondHeart:
	cmp [Life], 2
	jb ThirdHeart
	mov cx, 40
	mov dx, 180
	call PaintHeart
ThirdHeart:
	cmp [Life], 1
	jb NoHeart
	mov cx, 60
	mov dx, 180
	call PaintHeart
NoHeart:
	pop dx
	pop cx
	ret
	endp PaintObject
	proc PaintPlankton
	push ax
	mov al, 191
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 2
	call Paint
	mov al, 191
	dec cx
	call Paint
	inc dx
	inc cx
	call Paint
	mov al, 2
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 9
	mov al, 120
	call Paint
	inc cx
	mov al, 2
	call Paint
	xor al, al
	inc cx
	call Paint
	mov al, 44
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 2
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 120
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 10
	mov al, 120
	call Paint
	mov al, 2
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	mov al, 44
	inc cx
	call Paint
	mov al, 4
	inc cx
	call Paint
	mov al, 44
	inc cx
	call Paint
	mov al, 2
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 120
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 10
	mov al, 120
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	mov al, 44
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 2
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 120
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 10
	mov al, 191
	call Paint
	mov al, 120
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 10
	mov al, 191
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	mov al, 191
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	sub cx, 2
	sub dx, 8
	push cx
	push dx
	xor al, al
	mov cx, 10
ClearAllPlankton:
	mov dx, 200
ClearPlankton:
	call Paint
	dec dx
	cmp dx, 0ffffh
	jne ClearPlankton
	dec cx
	cmp cx, 0ffffh
	jne ClearAllPlankton
	call Paint
	pop dx
	pop cx
	pop ax
	ret
	endp PaintPlankton
	proc PaintKrabbyPatty
	push ax
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 9
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 11
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 12
	mov al, 42
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	mov al, 66
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 12
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 13
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 14
	mov al, 6
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 14
	mov al, 2
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 13
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 2
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 2
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	mov al, 2
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 42
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	sub cx, 12
	mov al, 42
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	sub dx, 9
	sub cx, 10
	pop ax
	ret
	endp PaintKrabbyPatty
	proc PaintEarth
	push ax
	mov al, 53
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 7
	mov al, 54
	call Paint
	mov al ,53
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 10
	mov al, 54
	call Paint
	dec al
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 11
	mov al, 54
	call Paint
	dec al
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 12
	mov al, 54
	call Paint
	dec al
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	mov al, 53
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 13
	mov al, 54
	call Paint
	dec al
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 53
	inc cx
	call Paint
	inc al
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 13
	mov al, 54
	call Paint
	dec al
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 13
	mov al, 54
	call Paint
	inc cx
	call Paint
	dec al
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 13
	mov al, 46
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 12
	mov al, 46
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 11
	mov al, 46
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 10
	mov al, 46
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 46
	inc cx
	call Paint
	inc cx
	call Paint
	mov al, 54
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	inc dx
	sub cx, 7
	mov al, 54
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	xor al, al
	inc cx
	call Paint
	sub dx, 12
	sub cx, 5
	pop ax
	ret
	endp PaintEarth
	proc PaintHeart
	push ax
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	add cx, 4
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 9
	mov al, 40
	call Paint
	inc cx
	mov al, 15
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 40
	call Paint
	inc cx
	call Paint
	add cx, 2
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 10
	mov al, 40
	call Paint
	inc cx
	mov al, 15
	call Paint
	inc cx
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 10
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 10
	mov al, 40
	call Paint
	inc cx
	mov al, 15
	call Paint
	inc cx
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 9
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 7
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 5
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	sub cx, 3
	mov al, 40
	call Paint
	inc cx
	call Paint
	inc cx
	mov al, 4
	call Paint
	inc dx
	dec cx
	call Paint
	pop ax
	ret
	endp PaintHeart
	proc PaintStar
	push ax
	mov al, 15
	call Paint
	xor al, al
	inc cx
	call Paint
	mov al, 15
	sub cx, 2
	inc dx
	call Paint
	inc cx
	call Paint
	inc cx
	call Paint
	inc cx
	xor al, al
	call Paint
	inc dx
	dec cx
	call Paint
	dec cx
	mov al, 15
	call Paint
	sub dx, 2
	pop ax
	ret
	endp PaintStar
	proc EndScreen
	call ClearScreen
	mov dx, offset Score
	mov ah, 9h
	int 21h
	mov dx, offset Point
	mov ah, 9h
    int 21h
	mov dx, offset EndGame
	mov ah, 9h
    int 21h
	mov cx, 0ffffh
ThirdDiley:
	push cx
	mov cx, 0fffh
FourthDiley:
	loop FourthDiley
	pop cx
	loop ThirdDiley
	mov ah, 8h
	int 21h
	ret
	endp EndScreen
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	mov ax, 13h
	int 10h
	call WelcomeScreen
NewGame:
	call ClearScreen
	call Restart
MoveSpongeBob:
    call MainScreen
	push cx
	mov cx, 60
	call PaintSpongeBob
	pop cx
	call EnterMove
	cmp al, 1bh
	je exit
	cmp [Life], 0
	je GameOver
	jmp MoveSpongeBob
GameOver:
	call EndScreen
	cmp al, 1bh
	je exit
	jmp NewGame
exit:
	mov ax, 4c00h
	int 21h
END start