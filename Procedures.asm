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

;---------------------------------------------------------------------------------------------------------------------
; Here we are going to accept a number from user, perform some arithmetic operations on it and the display the result
; The number given by the user is in ascii form..but machine processes data in hex form
; So, we first convert the ascii number into proper format(ascii_hex or hex) using the AsciiToHex procedure
; Now we can process this number
; Now to display back the number on console, we have to convert it back into ascii form
; So, we use HexToAscii procedure for display
; ---------------------------------------------------------------------------------------------------------------------

section .text
	msg1: db 'Enter a number', 10d, 13d
	len1: equ $- msg1
	msg2: db 'Output: '
	len2: equ $- msg2
	nwline: db 10d, 13d

section .bss
	num: resb 10
	ans: resb 10

section .text
	global _start:
	_start:
	
		scall 1, 1, msg1, len1		; display msg1
		scall 0, 0, num, 3		    ; accept the 2 digit number from user
	
		xor rax, rax
		xor rbx, rbx
		xor rcx, rcx			        ; clearing the registers

		mov rcx, 2			          ; as user gives 2 digit number, we put 2 in counter 
		mov rsi, num			        ; make rsi point to the base of num
		call AsciiToHex			      ; procedure call
		mov [num], rbx			      ; now um contains the equivalent hex number


		add byte[num], 5		      ; adding 5 to the number


		xor rax, rax
		xor rbx, rbx
		xor rcx, rcx			         ; clearing the registers

		mov rcx, 4			           ; we will display 4 digit output, so counter is initialsed to 4
		mov rbx, [num]			       ; move number into rbx
		mov rdi, ans			         ; make rdi point to the base address of ans variable
		call HexToAscii
		scall 1, 1, ans, 4		     ; result after addition is printed	(eg. 05 is input..then output will be ascii of 5+5=10 ie 000A)
		scall 1, 1, nwline, 1
		
		
	
		exit

zero:
		scall 1, 1, msg1, len1
		exit

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
 							
AsciiToHex:

	up:
		rol bx, 4
		mov al, [rsi]
		cmp al, 39h
		jbe skip
		sub al, 07h
	skip:
		sub al, 30h
		add bl, al
		inc rsi
		loop up
		ret
		
; this procedure takes each digit of the number one by  one.. performs necessary changes in it (either sub 30h or 37h) and then accumulates the result into rbx
;--------------------------------------------------------------------------------------------------------------------------------------------------------------

HexToAscii:
	
	up2:
		rol bx, 4			
		mov al, bl
		and al, 0fh
		cmp al, 09h
		jbe skip2
		add al, 07h
	skip2:
		add al, 30h
		mov [rdi], al
		inc rdi
		loop up2
		ret

; this procedure takes each digit stored in rbx one by one..performs necessary changes to it (either add 30h or 37h) and then stores that value byte by byte
; into ans variable. rdi is incremented each time to point to the next byte of ans variable

;----------------------------------------------------------------------------------------------------------------------------------------------------------------
; The input we give on console, each input is treated as 4 bits
; byte  =  8 bits = 1 byte
; word  = 16 bits = 2 bytes
; dword = 32 bits = 4 bytes
; qword = 64 bits = 8 bytes	
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------	

; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL$ nasm -f elf64 Procedures.asm
; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL$ ld -o a0 Procedures.o
; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL$ ./a0
; Enter a number
; 05
; 000A
; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL$ ./a0
; Enter a number
; 0A
; 000F
; prathamesh@prathamesh-Inspiron-3576:~/Documents/git_MPL$ 

		
