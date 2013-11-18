TITLE Towers Of Hanoi

Include Irvine32.inc
.data

; title strings
titleFilename db 'TitleArt.txt',0
titleBufferSize = 1000
titleBuffer db titleBufferSize DUP(?)
titleContents db 'Towers Of Hanoi',0
titlePrompt db '[ Press Space to continue ]',0

; menu strings
menuLegend db 'A=Left, D=Right, Space=Select',0
menuOption1 db '3 Rings',0
menuOption2 db '5 Rings',0
menuOption3 db '7 Rings',0
menuColorArray db 4,2 DUP(15)

.code
main PROC

	call showTitle
	call clrscr
	call showMenu
	
	exit
main ENDP

; takes esi = offset arr
;		al = position
;		ah = type arr
; and sets esi = position
iterateToPosition PROC uses ecx
	cmp al,0
	jz endo
	mov ecx,0
	mov cl,al
	outter:
		push ecx
		mov ecx,0
		mov cl,ah
		inner:
			inc esi
			loop inner
		pop ecx
		loop outter
	endo:
	ret
iterateToPosition ENDP

; show the title, and wait
; for user to hit space
; to continue
;---------------------------
showTitle PROC uses edx eax
	mov edx,0
	mov dh,1
	mov dl,1
	call gotoxy
	mov edx,offset titleFilename
	call openinputfile
	cmp eax,INVALID_HANDLE_VALUE
	jz fallback
	mov edx,offset titleBuffer
	mov ecx,titleBufferSize
	call readfromfile
	call closefile
	mov edx,offset titleBuffer
	call writestring
	jmp prompt
	fallback:
	mov edx,offset titleContents
	call writestring
	prompt:
	mov edx,0
	mov dh,22
	mov dl,14
	call gotoxy
	mov edx,offset titlePrompt
	call writestring
	
	nope:
		mov eax,0
		call readchar
		cmp al,' '
		jnz nope
	ret
showTitle ENDP

; renders all the menu items
; 3 - 5 - 7
; and the legend
;
showMenuItems PROC uses edx
	mov edx,0
	call gotoxy
	mov edx,0
	mov al,15
	call settextcolor
	mov edx,offset menuLegend
	call writestring
	mov edx,0
	mov al,menuColorArray[0]
	call settextcolor
	mov edx,0
	mov dh,10
	mov dl,6
	call gotoxy
	mov edx,offset menuOption1
	call writestring
	mov edx,0
	mov al,menuColorArray[1]
	call settextcolor
	mov edx,0
	mov dh,12
	mov dl,10
	call gotoxy
	mov edx,offset menuOption2
	call writestring
	mov eax,0
	mov al,menuColorArray[2]
	call settextcolor
	mov edx,0
	mov dh,10
	mov dl,16
	call gotoxy
	mov edx,offset menuOption3
	call writestring
	ret
showMenuItems ENDP

; takes al = position for iteration
; sets menuItem[al].color = 15
menuColorReset PROC uses ecx
	mov ah,type menuColorArray
	mov esi,offset menuColorArray
	call iterateToPosition
	mov ecx,0
	mov cl,15
	mov [esi],cl		
	ret
menuColorReset ENDP

; takes al = position for iteration
; sets menuItem[al].color = 4
menuColorSet PROC uses ecx
	mov ah,type menuColorArray
	mov esi,offset menuColorArray
	call iterateToPosition
	mov ecx,0
	mov cl,4
	mov [esi],cl		
	ret
menuColorSet ENDP

showMenu PROC uses edx eax ebx ecx
	mov ebx,0 
	render:
		call clrscr
		call showMenuItems
		jmp nope
		to0:
			mov eax,0
			mov al,bl
			call menuColorReset
			mov ebx,0
			mov al,bl
			call menuColorSet
			jmp render
		to1:
			mov eax,0
			mov al,bl
			call menuColorReset
			mov ebx,1
			mov al,bl
			call menuColorSet
			jmp render
		to2:
			mov al,bl
			call menuColorReset
			mov ebx,2
			mov al,bl
			call menuColorSet
			jmp render
		left:
			cmp ebx,1
			jz to0
			cmp ebx,2
			jz to1
			jmp nope
		right:
			cmp ebx,0
			jz to1
			cmp ebx,1
			jz to2
			jmp nope
		select:
			mov eax,0
			mov al,bl
			call showGame
		nope:
			mov eax,0
			call readchar
			cmp al,' '
			jz select
			cmp al,'a'
			jz left
			cmp al,'d'
			jz right
			jmp nope
	ret
showMenu ENDP

; renders the game
; takes al = ringcount
showGame PROC
	call clrscr
	ret
showGame ENDP

END main
