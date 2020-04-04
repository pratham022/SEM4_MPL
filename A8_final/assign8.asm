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
	msg1: db 'COPY: ', 10d, 13d
	len1: equ $- msg1
	msg2: db 'DELETE: ', 10d, 13d
	len2: equ $- msg2	
	msg3: db 'TYPE: ', 10d, 13d
	len3: equ $- msg3

section .bss
	choice: resb 2
	fname1: resq 2
	fname2: resq 2
	fd: resq 2
	fd2: resq 2
	buffer: resb 200
	buff_len: resb 20
	cnt: resb 20

section .text:
	global _start:
	_start:

		pop rbx
		pop rbx
		pop rbx

		mov rsi, rbx
		cmp byte[rsi], 43h
		je copy
		cmp byte[rsi], 44h
		je delete_
		jmp type


copy:
		scall 1, 1, msg1, len1
		pop rbx
		mov qword[fname1], rbx	
		pop rbx
		mov qword[fname2], rbx
		
		scall 2, [fname1], 2, 0777	; file opening system call
		mov [fd], rax			; now fd contains a unique non-negative number called file descriptor used to point to the file
	
		scall 0, [fd], buffer, 200	; file reading sysem call
		mov [buff_len], rax		; now rax contains the number of characters in the file (approximate)
	
		mov rax, 3
		xor rdi, [fd]	
		syscall				; close 1st file
	
		scall 2, [fname2], 0102o, 0666o	; file opening syscall --> 0102o for read-write mode and create if not created;  0666o is permission set code
		mov [fd2], rax			; move the file descriptor of 2nd file into fd2
		
		scall 1, [fd2], buffer, 200	; write into file system call
		
		mov rax, 3
		mov rdi, [fd2]
		syscall				; close 2nd file
			
		exit


delete_:
		scall 1, 1, msg2, len2
		pop rbx				; pop file name into rbx
		mov qword[fname1], rbx		; move file name into fname1
		
		mov rax, 87		
		mov rdi, [fname1]
		syscall				; file deletion system call
		exit

type:
		scall 1, 1, msg3, len3
		pop rbx
		mov qword[fname1], rbx
		
		scall 2, [fname1], 2, 0777	; file opening system call
		mov [fd], rax			; now fd contains a unique non-negative number called file descriptor used to point to the file
		
		scall 0, [fd], buffer, 200	; file reading system call
		mov [buff_len], rax		; now rax contains the number of characters in the file (approximate)
	
		scall 1, 1, buffer, buff_len	; print the content of file onto the console

		mov rax, 3
		mov rdi, [fd]
		syscall				; file closing system call
		exit
		
		
		
; $nasm -f elf64 assign8.asm
; $ld -o a8 assign8.o
; $./a8 TYPE file1.txt
; TYPE: 
; Hello there
; This is file1.txt
; Byeeeeeeeeeee.
; -$./a8 COPY file1.txt file2.txt
; COPY: 
; $./a8 DELETE file1.txt
; DELETE: 
; $







		 
