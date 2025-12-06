section .data
    ; Declarar aquí las variables globales que necesites
    ; Ejemplos:
    ; variable_bool:      db  0       ; bool (1 byte)
    ; variable_ptr:       dq  0       ; puntero (8 bytes)
    ; variable_uint32:    dd  0       ; uint32_t (4 bytes)
    ; variable_uint64:    dq  0       ; uint64_t (8 bytes)
    ; variable_float:     dd  0.0     ; float (4 bytes)

section .text

; ------------------------
; Offsets de Structs
; ------------------------

; ------------------------
; Constantes útiles
; ------------------------
FALSE       EQU     0
TRUE        EQU     1

; ------------------------
; Signatura de la función
; ------------------------
; Parámetros según System V AMD64 ABI:
;   rdi: primer parámetro
;   rsi: segundo parámetro
;   rdx: tercer parámetro
;   rcx: cuarto parámetro
;   r8:  quinto parámetro
;   r9:  sexto parámetro
;
; Valor de retorno:
;   rax: return value
global  miFuncion
miFuncion:
.prologo:
    push    rbp
    mov     rbp, rsp

    push    r12
    push    r13
    push    r14
    push    r15

.reinicializaciones:
    ; Reinicializar variables globales en .data
    ; Ejemplo:
    ; mov     byte    [variable_bool],    0
    ; mov     qword   [variable_ptr],     0
    ; mov     dword   [variable_uint32],  0

.cuerpo:
    ; ========================================================================
    ; EJEMPLO: Llamar a una función externa guardando registros volátiles
    ; ========================================================================
    ; Supongamos que tenés valores importantes en r8, r9, r10
    ; y necesitás llamar a: void otraFuncion(int a, int b)
    
    ; --- Guardar registros volátiles que contienen valores importantes ---
    ; push    r8          ; Guardar valor importante en r8
    ; push    r9          ; Guardar valor importante en r9
    ; push    r10         ; Guardar valor importante en r10
    ; push    r11         ; Guardar si lo usás
    ; 
    ; ; Después de 4 pushes (32 bytes), revisar alineación del stack
    ; ; Si el stack ya estaba alineado, ahora está alineado también (32 es múltiplo de 16)
    ; ; Si estaba desalineado, agregá: sub rsp, 8
    ; 
    ; ; --- Configurar parámetros para la llamada ---
    ; mov     rdi, 10     ; Primer parámetro = 10
    ; mov     rsi, 20     ; Segundo parámetro = 20
    ; 
    ; ; --- Llamar a la función ---
    ; call    otraFuncion
    ; 
    ; ; --- Restaurar registros volátiles ---
    ; pop     r11
    ; pop     r10         ; Restaurar valor original de r10
    ; pop     r9          ; Restaurar valor original de r9
    ; pop     r8          ; Restaurar valor original de r8
    ; 
    ; ; Ahora podés seguir usando r8, r9, r10 con sus valores originales
    ; ; y rax tiene el valor de retorno de otraFuncion() si es que devuelve algo
    ; ========================================================================

.epilogo:
    ; Preparar valor de retorno (si es necesario)
    ; Ejemplo:
    ; mov     rax,    r8                  ; return valor_en_r8
    ; movzx   rax,    byte [variable]     ; return bool (extender a 64 bits)

    pop     r15
    pop     r14
    pop     r13
    pop     r12

    pop     rbp

    ret

; ================================================================================
; NOTAS IMPORTANTES
; ================================================================================
;
; 1. TAMAÑOS DE REGISTROS:
;    - 64 bits: rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp, r8-r15
;    - 32 bits: eax, ebx, ecx, edx, esi, edi, ebp, esp, r8d-r15d
;    - 16 bits: ax, bx, cx, dx, si, di, bp, sp, r8w-r15w
;    - 8 bits:  al, bl, cl, dl, sil, dil, bpl, spl, r8b-r15b
;
; 2. MODOS DE DIRECCIONAMIENTO CON LEA:
;    - lea dst, [base + index*scale + offset]
;    - scale solo puede ser: 1, 2, 4, u 8
;    - Para otros valores: usar imul + movsx/movzx + lea
;      Ejemplo:
;        imul    r8d,    132             ; multiplicar por 132
;        movsx   r8,     r8d             ; extender a 64 bits
;        lea     r9,     [r9 + r8]       ; sumar al puntero base
;
; 3. EXTENSIÓN DE REGISTROS:
;    - movsx dst, src    ; Sign extend (para valores signed)
;    - movzx dst, src    ; Zero extend (para valores unsigned)
;    - movsxd rax, eax   ; Específico para 32→64 bits
;
; 4. ACCESO A MEMORIA:
;    - Especificar tamaño cuando sea ambiguo:
;      mov     byte [variable], 1        ; 1 byte
;      mov     word [variable], 1        ; 2 bytes
;      mov     dword [variable], 1       ; 4 bytes
;      mov     qword [variable], 1       ; 8 bytes
;
; 5. COMPARACIONES:
;    - Siempre especificar tamaño:
;      cmp     byte [variable], 0
;      cmp     dword [variable], 99
;      cmp     qword [variable], 0
;
; 6. INSTRUCCIONES ÚTILES:
;    - xor   reg, reg     ; Poner registro en 0 (más eficiente que mov reg, 0)
;    - test  reg, reg     ; Verificar si reg == 0 (sin modificar)
;    - inc/dec reg        ; Incrementar/decrementar
;    - lea   dst, [...]   ; Load Effective Address (calcular dirección)
;    - imul  dst, src     ; Multiplicación con signo
;
; 7. SALTOS CONDICIONALES:
;    - je/jz    ; Jump if Equal / Zero
;    - jne/jnz  ; Jump if Not Equal / Not Zero
;    - jg       ; Jump if Greater (signed)
;    - jge      ; Jump if Greater or Equal (signed)
;    - jl       ; Jump if Less (signed)
;    - jle      ; Jump if Less or Equal (signed)
;    - ja       ; Jump if Above (unsigned)
;    - jb       ; Jump if Below (unsigned)
;
; 8. ALINEACIÓN DEL STACK:
;    - El stack debe estar alineado a 16 bytes antes de un CALL
;    - Al entrar a una función, RSP está desalineado (por el CALL mismo)
;    - El PUSH RBP lo alinea nuevamente
;    - Si hacés más PUSHs, asegurate de mantener alineación de 16 bytes
;
; 9. LLAMADAS A FUNCIONES - GUARDAR REGISTROS VOLÁTILES:
;
;    Registros VOLÁTILES (caller-saved) - La función llamada puede modificarlos:
;      rax, rcx, rdx, rsi, rdi, r8, r9, r10, r11
;
;    Registros NO-VOLÁTILES (callee-saved) - La función llamada debe preservarlos:
;      rbx, rbp, r12, r13, r14, r15
;
;    EJEMPLO: Guardar TODOS los registros volátiles antes de llamar a una función:
;
;    ; --- ANTES DE LA LLAMADA ---
;    ; Guardar registros volátiles que contengan valores importantes
;    push    rax         ; Si rax tiene un valor que necesitás después
;    push    rcx         ; Parámetro 4 (si no lo usás para la llamada)
;    push    rdx         ; Parámetro 3 (si no lo usás para la llamada)
;    push    rsi         ; Parámetro 2 (si no lo usás para la llamada)
;    push    rdi         ; Parámetro 1 (si no lo usás para la llamada)
;    push    r8          ; Parámetro 5 (si no lo usás para la llamada)
;    push    r9          ; Parámetro 6 (si no lo usás para la llamada)
;    push    r10         ; Registro temporal
;    push    r11         ; Registro temporal
;    
;    ; IMPORTANTE: Después de 9 pushes (72 bytes), el stack está desalineado!
;    ; Necesitás un push más O restar 8 bytes para alinear a 16 bytes
;    sub     rsp, 8      ; Alinear stack a 16 bytes (72 + 8 = 80 = múltiplo de 16)
;    
;    ; --- CONFIGURAR PARÁMETROS ---
;    ; mov     rdi, valor_param1    ; Primer parámetro
;    ; mov     rsi, valor_param2    ; Segundo parámetro
;    ; mov     rdx, valor_param3    ; Tercer parámetro
;    ; mov     rcx, valor_param4    ; Cuarto parámetro
;    ; mov     r8,  valor_param5    ; Quinto parámetro
;    ; mov     r9,  valor_param6    ; Sexto parámetro
;    
;    ; --- LLAMADA A LA FUNCIÓN ---
;    call    otraFuncion
;    
;    ; --- DESPUÉS DE LA LLAMADA ---
;    ; El valor de retorno está en rax (no lo restaures si lo necesitás!)
;    
;    ; Restaurar alineación
;    add     rsp, 8
;    
;    ; Restaurar registros volátiles en orden inverso
;    pop     r11
;    pop     r10
;    pop     r9
;    pop     r8
;    pop     rdi
;    pop     rsi
;    pop     rdx
;    pop     rcx
;    ; NO restaurar rax si necesitás el valor de retorno!
;    ; Si no lo necesitás: pop rax
;    
;    ; Ahora podés usar el valor de retorno en rax
;    ; y todos los demás registros tienen sus valores originales
;
;    NOTA: En la práctica, solo guardás los registros que:
;      1. Tienen valores que necesitás después de la llamada
;      2. NO son usados para pasar parámetros a la función
;      3. NO son rax si necesitás el valor de retorno
;
; ================================================================================
