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
	array: dd 102.59, 198.21, 100.67
	cnt: dd 3
	hundred: dq 100
	msg1: db 'Mean is: '
	len1: equ $- msg1
	msg2: db 'Variance is: '
	len2: equ $- msg2
	msg3: db 'Standard deviation: '
	len3: equ $- msg3
		
	nwline: db 10d, 13d
	point: db '.'


section .bss
	mean: resd 1
	variance: resd 1
	sd: resd 1
	res_buff: rest 1	
	disp_buff: resb 2

section .text
	global _start:
	_start:

		mov rsi, array
		xor rcx, rcx
		mov rcx, 3
		fldz
	
	up:
		fadd dword[rsi]
		add rsi, 4
		loop up
	
		fidiv dword[cnt]
		fst dword[mean]
		
		scall 1, 1, msg1, len1
		call display
		scall 1, 1, nwline, 1

		xor rcx, rcx
		mov rcx, 3
		mov rbx, array
		mov rsi, 0
		fldz				; load 0 onto TOS
	
	up1:
		fld dword[array+rsi*4]		; load the number onto TOS...previously loaded 0 now would be ST1
		fsub dword[mean]		; ST0 - mean
		fmul st0			; ST0 = STO*STO
		fadd				; ST1 = ST0 + ST1
		inc rsi
		loop up1
	
		fidiv dword[cnt]
		fst dword[variance]
		scall 1, 1, msg2, len2
		call display
		scall 1, 1, nwline, 1

		fld dword[variance]
		fsqrt
		fst dword[sd]
		scall 1, 1, msg3, len3
		call display
		scall 1, 1, nwline, 1
		exit


; ---------------------------------------------------------------------------
display:
	
		fimul dword[hundred]
		fbstp tword[res_buff]
		mov rsi, res_buff
		add rsi, 9
		xor rcx, rcx	
		mov rcx, 9
	
	up2:
		push rcx
		push rsi
		mov bl, [rsi]
		call HtoA
		
		scall 1, 1, disp_buff, 2
	
		pop rsi
		dec rsi
		pop rcx
		loop up2
	
		push rsi
		scall 1, 1, point, 1
		pop rsi
		mov bl, [rsi]
		call HtoA
		scall 1, 1, disp_buff, 2
		ret




HtoA:
		mov rdi, disp_buff
		mov rcx, 2
	
	back:
		rol bl, 4
		mov dl, bl
		and dl, 0fh
		cmp dl, 09h
		jbe skip
		add dl, 07h
	
	skip:
		add dl, 30h
		mov [rdi], dl
		inc rdi
		loop back
		ret

; -----------------------------------------------------------------------

; $nasm -f elf64 A12.asm
; $ld -o a12 A12.o
; $./a12
; Mean is: 000000000000000133.82
; Variance is: 000000000000002073.44
; Standard deviation: 000000000000000045.54
; $
	


	
	
	
	

	
