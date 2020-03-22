section .data
	msg: db 'Hello World!', 10d, 13d
	len: equ $- msg

section .text
	global _start:
	_start:
	
		mov rax, 1		  ; system call for write
		mov rdi, 1		  ; stdout file
		mov rsi, msg		; reference of 'Hello World!'
		mov rdx, len		; size of msg
		syscall			    ; interrupt call
		
		mov rax, 60		  ; sys_exit
		xor rdi, rdi		; exit_success
		syscall			    ; interrupt
