section .data
    msg1        db 'Ingrese dividendo (0-4294967295): ',0
    len1        equ $-msg1
    msg2        db 10,'Ingrese divisor (1-4294967295): ',0
    len2        equ $-msg2
    msg_res     db 10,'Resultado: Cociente = ',0
    len_res     equ $-msg_res
    msg_rem     db ', Residuo = ',0
    len_rem     equ $-msg_rem
    msg_error0  db 10,'Error: No se puede dividir por cero!',10,0
    len_error0  equ $-msg_error0
    newline     db 10,0
    buffer      times 12 db 0
    cociente    times 11 db ' '
    residuo     times 11 db ' '

section .text
    global _start

_start:
    ; Limpiar buffers
    mov edi, buffer
    mov ecx, 12
    xor al, al
    rep stosb

    ; Leer dividendo
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80
    
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 12
    int 0x80
    call atoi32
    push eax

    ; Leer divisor
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80
    
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 12
    int 0x80
    call atoi32
    mov ebx, eax

    ; Verificar división por cero
    test ebx, ebx
    jz error_division_cero

    ; Realizar división (EDX:EAX / EBX)
    pop eax
    xor edx, edx   ; ¡IMPORTANTE! Limpiar EDX antes de DIV
    div ebx        ; EAX = cociente, EDX = residuo

    ; Guardar residuo inmediatamente después de DIV
    push edx       ; Guardar residuo en pila

    ; Convertir cociente
    mov edi, cociente
    call itoa32

    ; Recuperar y convertir residuo
    pop eax        ; Obtener residuo de la pila
    mov edi, residuo
    call itoa32

    ; Mostrar resultados
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, len_res
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, cociente
    mov edx, 10
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_rem
    mov edx, len_rem
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, residuo
    mov edx, 10
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

error_division_cero:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_error0
    mov edx, len_error0
    int 0x80
    mov eax, 1
    mov ebx, 1
    int 0x80

atoi32:
    xor eax, eax
    xor ebx, ebx
    mov esi, buffer
.convert:
    mov bl, [esi]
    test bl, bl
    jz .done
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done:
    ret

itoa32:
    mov ebx, 10
    xor ecx, ecx
    mov esi, edi
    add esi, 9      ; Última posición
    mov byte [esi+1], 0
.loop:
    xor edx, edx
    div ebx
    add dl, '0'   
    dec esi
    mov [esi], dl
    inc ecx
    test eax, eax
    jnz .loop
    ; Rellenar con espacios
    mov al, ' '
.fill:
    dec esi
    mov [esi], al
    inc ecx
    cmp ecx, 10
    jb .fill
    ret        
