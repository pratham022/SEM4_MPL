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

;----------------------------------------------------------------------------------------------------------------------------
	global cnt, buffer, cnt2, cnt3
	extern cspace, cnline, cchar
	extern spaces, lines, character, occ
;----------------------------------------------------------------------------------------------------------------------------
section .data
	msg1: db 'File opened successfully', 10d, 13d
	len1: equ $- msg1
	msg2: db 'Error in opening file', 10d, 13d
	len2: equ $- msg2
	msg: db 'Hello there', 10d, 13d
	len: equ $- msg
	msg3: db 'Number of spaces are:  '
	len3: equ $- msg3
	msg4: db 'Number of newlines are:  '
	len4: equ $- msg4
	msg5: db 'Enter a chracter: '
	len5: equ $- msg5
	msg6: db 'No. of occurrences of character: '
	len6: equ $- msg6

	nwline: db 10d, 13d
	fname: db 'myfile.txt'


section .bss
	fd: resb 16
	buffer: resb 20
	answer: resb 16
	buff_len: resb 17
	cnt: resb 16
	cnt2: resb 16
	cnt3: resb 16
	ch1: resb 2

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
		scall 0, [fd], buffer, 200	; read file
		mov [cnt], rax			; after reading, rax will contain number of characters in the file (or rax will contain size of buffer)
		mov [cnt2], rax			; move that value in respective counters for the procedures
		mov [cnt3], rax

;----------------------------------------------------------------------------------------------------------------------------
		call spaces			; procedure call
		scall 1, 1, msg3, len3		
		scall 1, 1, cspace, 1		; cspace will contain the space count
		scall 1, 1, nwline, 1
;----------------------------------------------------------------------------------------------------------------------------
		call lines			; procedure call
		scall 1, 1, msg4, len4		
		scall 1, 1, cnline, 1		; cline will contain newline count
		scall 1, 1, nwline, 1
			
		scall 1, 1, msg5, len5		
		scall 0, 0, ch1, 2		; accept the character from user
		xor rbx, rbx
		mov bl, byte[ch1]		; move that character into bl 
		call character			; procedure call
		scall 1, 1, msg6, len6
		scall 1, 1, cchar, 1
		scall 1, 1, nwline, 1
		
		exit

terminate:
		scall 1, 1, msg2, len2		; error in file opening
		exit	


;----------------------------------------------------------------------------------------------------------------------------

; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL/assign5_final$ ./p
; File opened successfully
; Number of spaces are:  7
; Number of newlines are:  2
; Enter a chracter: z
; No. of occurrences of character: 0
; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL/assign5_final$ ./p
; File opened successfully
; Number of spaces are:  7
; Number of newlines are:  2
; Enter a chracter: a
; No. of occurrences of character: 2
; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL/assign5_final$
