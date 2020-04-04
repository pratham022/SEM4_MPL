%macro scall 4								; macro for system calls
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro

%macro exit 0								; macro for exit system call
	mov rax, 60
	xor rdi, rdi
	syscall
%endmacro

section .data
	msg1: db 'File opened successfully', 10d, 13d
	len1: equ $- msg1
	msg2: db 'Error in opening file', 10d, 13d
	len2: equ $- msg2
	msg3: db 'Ascending order: ', 10d, 13d
	len3: equ $- msg3

	nwline: db 10d, 13d
	fname: db 'pqr.txt'


section .bss
	fd: resb 16
	buffer: resb 20					; used to temporarily store contents of file while read mode
	buffer_copy: resb 20
	cnt1: resb 16
	cnt2: resb 16
	cnt3: resb 16
	cnt4: resb 16

;----------------------------------------------------------------------------------------------------------------------------
section .text
	global _start:
	_start:

		scall 2, fname, 2, 0777		; file opening
		mov [fd], rax			; mov file descriptor from rax into variable fd
		cmp rax, 0			; if file descriptor is below zero, exit
		jb terminate
		scall 1, 1, msg1, len1		; file opened successfully

;----------------------------------------------------------------------------------------------------------------------------
		scall 0, [fd], buffer, 20	; read file
		mov [cnt1], rax			; after reading the file, rax will contain number of characters in the file...put this value in  			
		mov [cnt3], rax			; cnt1 and cnt3
		xor rdx, rdx

		scall 1, [fd], msg3, len3
;------------------------------------------------------------------------------
		outer:					; bubble sort logic
			mov rsi, buffer
			mov rdi, buffer
			inc rdi
			sub qword[cnt1], 1
			je stop
			mov rdx, qword[cnt1]
			mov qword[cnt2], rdx

		inner:
			mov al, byte[rsi]
			mov bl, byte[rdi]
			cmp bl, al
			jb swap
			jmp no_swap

		swap:
			mov byte[rsi], bl
			mov byte[rdi], al

		no_swap:
			inc rsi
			inc rdi
			dec qword[cnt2]
			cmp qword[cnt2], 0	
			ja inner
			jmp outer
stop:
			scall 1, [fd], buffer, 20

;--------------------------------------------------------------------------------------------------------------

			exit

terminate:
		scall 1, 1, msg2, len2
		exit



; $cd A7
; $nasm -f elf64 A7.asm
; $ld -o a7 A7.o
; $./a7
; File opened successfully
; $




