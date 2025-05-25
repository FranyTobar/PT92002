section .data
    msg1 db 'Ingrese primer numero: ',0
    len1 equ $-msg1
    msg2 db 10, 'Ingrese segundo numero: ',0
    len2 equ $-msg2
    msg3 db 10, 'Ingrese tercer numero: ',0
    len3 equ $-msg3
    msg_res db 10, 'Resultado: ',0
    len_res equ $-msg_res
    newline db 10,0
    buffer times 11 db 0  ; Buffer ampliado para garantizar espacio
    resultado times 11 db 0

section .text
    global _start

_start:
    ; Limpiar buffers inicialmente
    call clear_buffers

    ; Primer número
    call mostrar_mensaje1
    call leer_entrada
    call atoi
    push eax

    ; Segundo número
    call mostrar_mensaje2
    call leer_entrada
    call atoi
    push eax

    ; Tercer número
    call mostrar_mensaje3
    call leer_entrada
    call atoi

    ; Calcular (num1 - num2 - num3)
    pop ebx
    pop ecx
    sub ecx, ebx
    sub ecx, eax

    ; Convertir y mostrar resultado
    mov eax, ecx
    call mostrar_resultado

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --------------------------------------------------
; SUBRUTINAS VERIFICADAS
; --------------------------------------------------

mostrar_mensaje1:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80
    ret

mostrar_mensaje2:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80
    ret

mostrar_mensaje3:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 0x80
    ret

leer_entrada:
    mov eax, 3
    xor ebx, ebx
    mov ecx, buffer
    mov edx, 11
    int 0x80
    ret

clear_buffers:
    mov edi, buffer
    mov ecx, 11
    xor eax, eax
    rep stosb
    mov edi, resultado
    mov ecx, 11
    rep stosb
    ret

atoi:
    xor eax, eax
    xor ebx, ebx
    mov esi, buffer
.conversion:
    mov bl, [esi]
    test bl, bl
    jz .fin
    cmp bl, 10
    je .fin
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .conversion
.fin:
    ret

itoa:
    mov edi, resultado
    mov ebx, 10
    xor ecx, ecx
    
    test eax, eax
    jnz .no_cero
    mov byte [edi], '0'
    inc edi
    jmp .terminar
.no_cero:
    cmp eax, 0
    jge .positivo
    neg eax
    mov byte [edi], '-'
    inc edi
.positivo:
    xor edx, edx
    div ebx
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz .positivo
.almacenar:
    pop dx
    mov [edi], dl
    inc edi
    loop .almacenar
.terminar:
    mov byte [edi], 0
    ret

mostrar_resultado:
    mov edi, resultado
    call itoa
    
    ; Mostrar mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, len_res
    int 0x80
    
    ; Mostrar número
    mov ecx, resultado
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    ; Nueva línea final
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

strlen:
    xor eax, eax
.contar:
    cmp byte [ecx+eax], 0
    je .fin
    inc eax
    jmp .contar                        
.fin:
    ret                              
