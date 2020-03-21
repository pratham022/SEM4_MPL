section .data
    msg db 'Hello World!', 0xa
    len equ $- msg
    
section .text
    global _start:
    _start:
      
            mov edx, len    ; message length
            mov ecx, msg    ; reference of msg
            mov ebx, 1      ; file descriptor (stdout)
            mov eax, 4      ; sys_write call
            int 0x80        ; interrupt call
            
            mov eax, 1      ; sys_exit  call number
            int 0x80        ; call interrupt(kernel)
            
            ; "Hello World!" will be printed on screen
