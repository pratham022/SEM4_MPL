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

%macro myprintf 1
	mov rdi, formatpf
	sub rsp, 8
	movsd xmm0, [%1]
	mov rax, 1
	call printf
	add rsp, 8
%endmacro

%macro myscanf 1
	mov rdi, formatsf	
	mov rax, 0
	sub rsp, 8
	mov rsi, rsp
	call scanf
	mov r8, qword[rsp]
	mov qword[%1], r8
	add rsp, 8
%endmacro


section .data
	msg1: db 'Enter a', 10d, 13d
	len1: equ $- msg1
	msg2: db 'Enter b', 10d, 13d
	len2: equ $- msg2
	msg3: db 'Enter c', 10d, 13d
	len3: equ $- msg3
	msg5: db 'Real Roots: ',10d, 13d
	len5: equ $- msg5
	msg6: db 'Imaginary Roots: ',10d, 13d
	len6: equ $- msg6

	formatpf: db '%lf', 10, 0
	formatsf: db '%lf', 0
	
	ff1: db '%lf +i %lf', 10, 0
	ff2: db '%lf -i %lf', 10, 0
	
	four: dq 4
	two: dq 2


section .bss
	a: resq 1
	b: resq 1
	c: resq 1
	b_sq: resq 1
	four_ac: resq 1
	two_a: resq 1
	delta: resq 1
	rdelta: resq 1
	root1: resq 1
	root2: resq 1
	alpha: resq 1
	beta: resq 1

section .text
	global main
	main:
	
		extern printf
		extern scanf
	
		scall 1, 1, msg1, len1
		myscanf a
		scall 1, 1, msg2, len2
		myscanf b
		scall 1, 1, msg3, len3
		myscanf c
	
		

		fld qword[b]
		fmul qword[b]
		fstp qword[b_sq]	; calculate b square
	
		fild qword[four]
		fmul qword[a]
		fmul qword[c]
		fstp qword[four_ac]	; calculate 4ac
	
		fild qword[two]
		fmul qword[a]
		fstp qword[two_a]	; calculate 2a

		fld qword[b_sq]
		fsub qword[four_ac]
		fstp qword[delta]	; find discriminant
	
		
	
					;cmp qword[delta], 0
					;jbe imaginary
		bt qword[delta], 63
		jc imaginary


real_roots:
		scall 1, 1, msg5, len5

		fld qword[delta]
		fsqrt 
		fstp qword[rdelta]	; find root of delta

		fldz 
		fsub qword[b]
		fadd qword[rdelta]
		fdiv qword[two_a]
		fstp qword[root1]
	
		fldz 
		fsub qword[b]
		fsub qword[rdelta]
		fdiv qword[two_a]
		fstp qword[root2]
		
		myprintf root1
		myprintf root2
		exit
	
	
imaginary:
		
		scall 1, 1, msg6, len6
		
		fldz
		fsub qword[delta]
		fsqrt 
		fstp qword[rdelta]	; find root of delta
	
		fldz 
		fsub qword[b]
		fdiv qword[two_a]
		fstp qword[alpha]
	
		fld qword[rdelta]
		fdiv qword[two_a]
		fstp qword[beta]
	
	
	
		mov rdi, ff1
		sub rsp, 8
		movsd xmm0, [alpha]
		movsd xmm1, [beta]
		mov rax, 2
		call printf
		add rsp, 8

		mov rdi, ff2
		sub rsp, 8
		movsd xmm0, [alpha]
		movsd xmm1, [beta]
		mov rax, 2
		call printf
		add rsp, 8
		exit

; ------------------------------------------------------------------------------------------------------------------

; $nasm -f elf64 A10.asm
; $gcc -no-pie -o a10 A10.o
; $./a10
; Enter a
; 1
; Enter b
; 1
; Enter c
; 1
; Imaginary Roots: 
; -0.500000 +i 0.866025
; -0.500000 -i 0.866025
; $./a10
; Enter a
; 1
; Enter b
; -5
; Enter c
; 6
; Real Roots: 
; 3.000000
; 2.000000
; $










