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
	msg1: db 'We are in protected mode', 10d, 13d
	len1: equ $- msg1

	msg2: db 'We are not in protected mode', 10d, 13d
	len2: equ $- msg2
	
	msg3: db 'GDTR contents: ', 10d, 13d
	len3: equ $- msg3

	msg4: db 'IDTR contents: ', 10d, 13d
	len4: equ $- msg4

	msg5: db 'LDTR contents: ', 10d, 13d
	len5: equ $- msg5

	msg6: db 'TR contents: ', 10d, 13d
	len6: equ $- msg6
	
	msg7: db 'Machine status word', 10d, 13d
	len7: equ $- msg7
	
	nwline: db 10d, 13d


section .bss

	msw: resw 1

	gdt: resd 1	
	     resw 1

	idt: resd 1
	     resw 1
	
	ldt: resw 1
	
	tr: resw 1

	result: resb 2
	


section .text
	global _start:
	_start:

		smsw[msw]
		sgdt[gdt]
		sidt[idt]
		sldt[ldt]
		str[tr]
	
		xor rax, rax
		mov rax, [msw]
		bt rax, 0
		jc go_ahead
		scall 1, 1, msg2, len2	
		scall 1, 1, nwline, 1
		exit


go_ahead:
		scall 1, 1, msg1, len1	
		scall 1, 1, nwline, 1
	
		; GDTR holds 32 bit base address and 16 bit limit...now each character on console represents 4 bits...thus to represent 32 bits, we will display
		; 32/4 = 8 digit number(representing address) and for 16 bit limit, we will represent 4 digit number(limit)
	
; -------------------------------------------------------------
; GDTR contents
		scall 1, 1, msg3, len3
		xor rbx, rbx
		mov bx, [gdt+4]
		call HtoA
		scall 1, 1, result, 4
		mov bx, [gdt+2]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1
		mov bx, [gdt]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1
; ----------------------------------------------------------------
; IDTR contents
		scall 1, 1, msg4, len4
		xor rbx, rbx
		mov bx, [idt+4]
		call HtoA
		scall 1, 1, result, 4
		mov bx, [idt+2]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1
		mov bx, [idt]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1
; -----------------------------------------------------------------
; LDTR contents
		scall 1, 1, msg5, len5
		xor rbx, rbx
		mov bx, [ldt]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1
; -----------------------------------------------------------------
; TR contents
		scall 1, 1, msg6, len6
		xor rbx, rbx
		mov bx, [tr]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1

; -----------------------------------------------------------------
; MSW
		scall 1, 1, msg7, len7
		xor rbx, rbx
		mov bx, [msw]
		call HtoA
		scall 1, 1, result, 4
		scall 1, 1, nwline, 1
		exit	
; ------------------------------------------------------------------

HtoA:
		xor rax, rax
		xor rcx, rcx
	
		mov rcx, 4
		mov rdi, result
	
	up:
		rol bx, 4
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
    
    ; ------------------------------------------------------------------
    Output:
    
; $nasm -f elf64 A6.asm
; $ld -o a6 A6.o
; $./a6
; We are in protected mode

; GDTR contents: 
; 00103000
; 007F
; IDTR contents: 
; 00000000
; 0FFF
; LDTR contents: 
; 0000
; TR contents: 
; 0040
; Machine status word
; 0033
; $

    
    
    
    
    
    
    
    
    
    
    
