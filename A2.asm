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

section .data
	array: db 10, 11, 12, 13, 14, 0, 0, 0, 0, 0, 0, 0, 0
	n: dq 5
	msg: db '1- non-overlapped transfer without string instructions', 10d, 13d
	     db	'2- overlapped transfer without string instructions', 10d, 13d
	     db '3- non-overlapped tranfer using string instructions', 10d, 13d
	     db '4- overlapped transfer using string instructions', 10d, 13d
	len: equ $- msg
	msg2: db 'Before Transfer: ', 10d, 13d
	len2: equ $- msg2
	msg3: db 'After Transfer: ', 10d, 13d
	len3: equ $- msg3

	nwline: db 10d, 13d
	space: db 20h
	colon: db 58

section .bss
	cnt: resb 2
	result: resb 2
	choice: resb 2

section .text
	global _start:
	_start:

		scall 1, 1, msg2, len2
		call display			; display the initial state of array
		
		scall 1, 1, msg, len
		scall 0, 0, choice, 2
		sub byte[choice], 30h
	
		cmp byte[choice], 1
		je case1
		cmp byte[choice], 2
		je case2
		cmp byte[choice], 3
		je case3
		cmp byte[choice], 4
		je case4
		exit

; -----------------------------------------------------------------------------
case1:
		mov rsi, array
		mov rdi, array
		add rdi, 5
		mov byte[cnt], 5
		xor rax, rax	
		
		call transfer
		call display
		
		exit

; ------------------------------------------------------------------------------------------
case2:
		
		mov rsi, array		
		mov rdi, array
		add rdi, 5
		mov byte[cnt], 5
		xor rax, rax

		call transfer

		mov rsi, array
		add rsi, 5
		mov rdi, array
		add rdi, 2			; here 2 is the index
		mov byte[cnt], 5
		xor rax, rax
		
		call transfer
		call display
		exit	
			
; ------------------------------------------------------------------------------------------
case3: 
		mov rsi, array
		mov rdi, array
		add rdi, 5
		xor rcx, rcx
		mov rcx, 5
		
		cld
		rep movsb
		
		call display
		exit

; -----------------------------------------------------------------------------------------
case4:
		mov rsi, array
		mov rdi, array
		add rdi, 5
		xor rcx, rcx
		mov rcx, 5
		
		cld
		rep movsb


		mov rsi, array
		add rsi, 5
		mov rdi, array
		add rdi, 2			; here 2 is the index
		xor rcx, rcx			
		mov rcx, 5
	
		cld 
		rep movsb
	
		call display
		exit
		
; ------------------------------------------------------------------------------------
HtoA:
		xor rax, rax
		xor rcx, rcx
	
		mov rcx, 16
		mov rdi, result
	
	up:
		rol rbx, 4
		mov al, bl
		and al, 0fh
		cmp al, 09h
		jbe skip
		add al, 07h
	skip:
		add al, 30h
		mov [rdi], al
		inc rdi
		loop up
		ret

; -------------------------------------------------------------------------
transfer:
			

	loop1:
		mov al, byte[rsi]
		mov byte[rdi], al
		add rsi, 1
		add rdi, 1		
		dec byte[cnt]
		jnz loop1
		ret


; -------------------------------------------------------------------------
display:
		mov rsi, array
		xor rbx, rbx
		mov byte[cnt], 10
				
	loop2:
		mov rbx, rsi
		call HtoA
		push rsi
		scall 1, 1, result, 16
		scall 1, 1, colon, 1
		scall 1, 1, space, 1
		pop rsi
		xor rbx, rbx
		mov bl, byte[rsi]
		call HtoA
		push rsi
		scall 1, 1, result, 16
		scall 1, 1, nwline, 1
		pop rsi	
		add rsi, 1
		dec byte[cnt]
		jnz loop2
		ret
		
; ----------------------------------------------------------------------------------------

; $nasm -f elf64 A2.asm
; $ld -o a2 A2.o
; $./a2
; Before Transfer: 
; 0000000000600374: 000000000000000A
; 0000000000600375: 000000000000000B
; 0000000000600376: 000000000000000C
; 0000000000600377: 000000000000000D
; 0000000000600378: 000000000000000E
; 0000000000600379: 0000000000000000
; 000000000060037A: 0000000000000000
; 000000000060037B: 0000000000000000
; 000000000060037C: 0000000000000000
; 000000000060037D: 0000000000000000
; 1- non-overlapped transfer without string instructions
; 2- overlapped transfer without string instructions
; 3- non-overlapped tranfer using string instructions
; 4- overlapped transfer using string instructions
; 1
; 0000000000600374: 000000000000000A
; 0000000000600375: 000000000000000B
; 0000000000600376: 000000000000000C
; 0000000000600377: 000000000000000D
; 0000000000600378: 000000000000000E
; 0000000000600379: 000000000000000A
; 000000000060037A: 000000000000000B
; 000000000060037B: 000000000000000C
; 000000000060037C: 000000000000000D
; 000000000060037D: 000000000000000E
; $./a2
; Before Transfer: 
; 0000000000600374: 000000000000000A
; 0000000000600375: 000000000000000B
; 0000000000600376: 000000000000000C
; 0000000000600377: 000000000000000D
; 0000000000600378: 000000000000000E
; 0000000000600379: 0000000000000000
; 000000000060037A: 0000000000000000
; 000000000060037B: 0000000000000000
; 000000000060037C: 0000000000000000
; 000000000060037D: 0000000000000000
; 1- non-overlapped transfer without string instructions
; 2- overlapped transfer without string instructions
; 3- non-overlapped tranfer using string instructions
; 4- overlapped transfer using string instructions
; 4
; 0000000000600374: 000000000000000A
; 0000000000600375: 000000000000000B
; 0000000000600376: 000000000000000A
; 0000000000600377: 000000000000000B
; 0000000000600378: 000000000000000C
; 0000000000600379: 000000000000000D
; 000000000060037A: 000000000000000E
; 000000000060037B: 000000000000000C
; 000000000060037C: 000000000000000D
; 000000000060037D: 000000000000000E
; $







