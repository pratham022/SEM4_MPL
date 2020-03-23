%macro scall 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro

%macro exit 0
	mov rax, 60
	xor rdi, rdi
	syscall
%endmacro
;--------------------------------------------------------------------------------------------------------------------------
	global cspace, cnline, cchar
	global spaces, lines, character, occ
	extern cnt, buffer, cnt2, cnt3
;---------------------------------------------------------------------------------------------------------------------------
section .bss
	cspace: resb 2
	cnline: resb 2
	cchar: resb 2
;---------------------------------------------------------------------------------------------------------------------------
section .text
	global _main:
	_main:

;----------------------------------------------------------------------------------------------------------------------------
spaces:

		mov byte[cspace], 0		
		mov rsi, buffer
		xor rbx, rbx

loop1:
		mov bl, [rsi]
		cmp bl, 20h
		je next
		inc rsi
		dec qword[cnt]
		jnz loop1
		jmp stop
next:
		inc byte[cspace]
		inc rsi
		dec qword[cnt]
		jnz loop1	
stop:
		add byte[cspace], 30h
		ret
;----------------------------------------------------------------------------------------------------------------------------
lines:
		mov byte[cnline], 0
		mov rsi, buffer
		xor rbx, rbx
loop2:
		mov bl, [rsi]
		cmp bl, 0Ah
		je next2
		inc rsi
		dec qword[cnt2]
		jnz loop2
		jmp stop2
next2:
		inc byte[cnline]
		inc rsi
		dec qword[cnt2]
		jnz loop2
stop2:
		add byte[cnline], 30h
		ret

;--------------------------------------------------------------------------------------------------------------------
character:
		mov byte[cchar], 0
		mov rsi, buffer
loop3:
		mov al, [rsi]
		cmp al, bl			; bl contains the character..so compare al with bl
		je next3
		inc rsi
		dec qword[cnt3]
		jnz loop3
		jmp stop3
next3:
		inc byte[cchar]
		inc rsi
		dec qword[cnt3]
		jnz loop3
stop3:
		add byte[cchar], 30h
		ret






