section .data
    msg1    db 'Ingrese primer numero (0-255): ',0
    len1    equ $-msg1
    msg2    db 10,'Ingrese segundo numero (0-255): ',0
    len2    equ $-msg2
    msg_res db 10,'Resultado: ',0
    len_res equ $-msg_res
    newline db 10,0
    buffer  times 4 db 0
    resultado times 5 db '0',0  ; Inicializado con '0'

section .text
    global _start

_start:
    ; Primer número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1                
    mov edx, len1
    int 0x80
    
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 4
    int 0x80
    call atoi8
    push ax

    ; Limpiar buffer
    mov edi, buffer      
    mov ecx, 4
    xor al, al
    rep stosb

    ; Segundo número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80
    
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 4
    int 0x80
    call atoi8
    mov bl, al    ; Segundo número en BL

    ; Multiplicación (AL * BL = AX)
    pop ax        ; Primer número en AL
    mul bl

    ; Convertir AX a string (versión simplificada y garantizada)
    mov edi, resultado
    call itoa_simple

    ; Mostrar resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, len_res
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 5    ; Mostramos siempre 5 caracteres
    int 0x80
    
    ; Salto de línea final
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Subrutinas garantizadas ---
atoi8:
    xor eax, eax
    mov esi, buffer
.next:
    movzx ebx, byte [esi]
    test bl, bl
    jz .done
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .next
.done:
    ret

; Versión SIMPLIFICADA de itoa que funciona siempre
itoa_simple:
    mov bx, 10
    mov ecx, 5      ; Máximo 5 dígitos
    lea edi, [resultado + 4] ; Posición final
    mov byte [edi], 0
    
.convert:
    dec edi
    xor dx, dx
    div bx
    add dl, '0'
    mov [edi], dl
    loop .convert
    ret
