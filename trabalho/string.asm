extern _printf
extern _GetStdHandle@4
extern _ReadFile@20
extern _exit
extern _scanf

section .data
    menu_msg db 10, "==== MENU ====", 10
            db "1. Inverter uma frase", 10
            db "2. Verificar se eh palindromo", 10
            db "3. Contar palavras", 10
            db "4. Cifra de Cesar", 10
            db "5. Decifrar Cesar", 10
            db "0. Sair", 10
            db "Escolha uma opcao: ", 0
    
    prompt_msg db "Digite sua frase (max 255 caracteres): ", 10, 0 
    output_prefix db 10, "Frase original: ", 0
    output_inverted db 10, "Frase invertida: ", 0
    output_encrypted db 10, "Frase cifrada: ", 0
    output_decrypted db 10, "Frase decifrada: ", 0
    msg_is_palindrome db 10, "A frase EH um palindromo!", 10, 0
    msg_not_palindrome db 10, "A frase NAO eh um palindromo!", 10, 0
    msg_word_count db 10, "Numero de palavras: %d", 10, 0
    
    fmt_num db "%d", 0
    newline db 10, 0
    
    MAX_CHARS equ 255

section .bss
    stdin_handle resd 1         ; Standard Input Handle
    bytes_read resd 1           ; Number of bytes read
    option resd 1               ; Selected option
    word_count resd 1           ; Word counter
    input_buffer resb 256       ; Input buffer (256 bytes)
    inverted_buffer resb 256    ; Buffer for inverted string
    cipher_buffer resb 256      ; Buffer for encrypted/decrypted string
    clean_buffer resb 256       ; Buffer for cleaned string (palindrome check)

section .text
    global _main    

_main:
    ; --- 1. GET STDIN HANDLE ---
    PUSH dword -10
    CALL _GetStdHandle@4
    mov [stdin_handle], eax 

menu_loop:
    ; Display menu
    PUSH menu_msg
    CALL _printf
    ADD ESP, 4
    
    ; Read user option
    PUSH option
    PUSH fmt_num
    CALL _scanf
    ADD ESP, 8

    ; Check selected option
    mov eax, [option]
    cmp eax, 0
    je exit_program
    
    cmp eax, 1
    je reverse_string
    
    cmp eax, 2
    je check_palindrome
    
    cmp eax, 3
    je count_words
    
    cmp eax, 4
    je encrypt_caesar

    cmp eax, 5
    je decrypt_caesar
    
    ; Invalid option, return to menu
    jmp menu_loop

; Common function to read input string
read_input:
    ; Save registers
    push eax
    push ecx
    
    ; --- 2. DISPLAY PROMPT ---
    PUSH dword prompt_msg
    CALL _printf
    ADD ESP, 4

    ; --- 3. READ USER INPUT (ReadFile) ---
    PUSH dword 0                ; lpOverlapped (NULL)
    PUSH dword bytes_read       ; lpNumberOfBytesRead
    PUSH dword MAX_CHARS        ; nNumberOfBytesToRead (255 limit)
    PUSH dword input_buffer     ; lpBuffer
    PUSH dword [stdin_handle]   ; hFile (STDIN handle)
    CALL _ReadFile@20
    
    ; --- 4. ADJUST AND TERMINATE STRING ---
    mov ecx, [bytes_read]       ; ECX = total bytes read (includes CR+LF)
    sub ecx, 2                  ; Remove 2 bytes (CR and LF)
    mov byte [input_buffer + ecx], 0 ; Add null terminator
    
    mov [bytes_read], ecx       ; Update bytes_read with actual size
    
    ; Restore registers
    pop ecx
    pop eax
    ret

; Option 1: Reverse string
reverse_string:
    call read_input
    
    ; Show original string
    PUSH output_prefix
    CALL _printf
    ADD ESP, 4
    
    PUSH input_buffer
    CALL _printf
    ADD ESP, 4
    
    ; Reverse the string
    mov esi, input_buffer       ; Source (original string)
    mov edi, inverted_buffer    ; Destination (reversed string)
    mov ecx, [bytes_read]       ; String length
    add esi, ecx                ; Point to end
    dec esi                     ; Adjust to last character
    
reverse_loop:
    mov al, [esi]               ; Get character from source
    mov [edi], al               ; Put in destination
    dec esi                     ; Move backwards in source
    inc edi                     ; Move forward in destination
    loop reverse_loop           ; Continue until ECX = 0
    
    mov byte [edi], 0           ; Add null terminator
    
    ; Show reversed string
    PUSH output_inverted
    CALL _printf
    ADD ESP, 4
    
    PUSH inverted_buffer
    CALL _printf
    ADD ESP, 4
    
    PUSH newline
    CALL _printf
    ADD ESP, 4
    
    jmp menu_loop

; Option 2: Check if palindrome (ignoring spaces and punctuation)
check_palindrome:
    call read_input
    
    ; Show original string
    PUSH output_prefix
    CALL _printf
    ADD ESP, 4
    
    PUSH input_buffer
    CALL _printf
    ADD ESP, 4
    
    ; Clean string: remove spaces and convert to lowercase
    mov esi, input_buffer       ; Source
    mov edi, clean_buffer       ; Destination (cleaned string)
    xor ecx, ecx                ; Clean string length counter
    
clean_string_loop:
    mov al, [esi]               ; Get current character
    test al, al                 ; Check if end of string
    jz clean_done
    
    ; Skip spaces and punctuation
    cmp al, ' '
    je skip_char
    cmp al, '!'
    je skip_char
    cmp al, '?'
    je skip_char
    cmp al, '.'
    je skip_char
    cmp al, ','
    je skip_char
    
    ; Convert to lowercase if uppercase
    cmp al, 'A'
    jb store_char
    cmp al, 'Z'
    ja check_lower
    add al, 32                  ; Convert to lowercase
    jmp store_char
    
check_lower:
    cmp al, 'a'
    jb skip_char
    cmp al, 'z'
    ja skip_char
    
store_char:
    mov [edi], al               ; Store cleaned character
    inc edi
    inc ecx                     ; Increment clean length
    
skip_char:
    inc esi
    jmp clean_string_loop
    
clean_done:
    mov byte [edi], 0           ; Add null terminator
    
    ; Check if cleaned string is empty or has only 1 character
    cmp ecx, 1
    jbe is_palindrome           ; Strings with 0 or 1 char are palindromes
    
    ; Compare characters from start and end
    mov esi, clean_buffer       ; Pointer to start
    mov edi, clean_buffer       ; Pointer to end
    add edi, ecx                ; Move to end
    dec edi                     ; Adjust to last character
    
    mov ebx, ecx                ; Counter = length/2
    shr ebx, 1                  ; Divide by 2
    
compare_palindrome:
    mov al, [esi]               ; Character from start
    mov ah, [edi]               ; Character from end
    cmp al, ah                  ; Compare
    jne not_palindrome          ; If different, not a palindrome
    
    inc esi                     ; Next character from start
    dec edi                     ; Next character from end
    dec ebx
    jnz compare_palindrome      ; Continue until middle
    
is_palindrome:
    ; It is a palindrome
    PUSH msg_is_palindrome
    CALL _printf
    ADD ESP, 4
    jmp menu_loop
    
not_palindrome:
    ; It is not a palindrome
    PUSH msg_not_palindrome
    CALL _printf
    ADD ESP, 4
    jmp menu_loop

; Option 3: Count words
count_words:
    call read_input
    
    ; Show original string
    PUSH output_prefix
    CALL _printf
    ADD ESP, 4
    
    PUSH input_buffer
    CALL _printf
    ADD ESP, 4
    
    ; Initialize word counter
    mov dword [word_count], 0   ; Zero counter
    mov esi, input_buffer       ; String pointer
    mov ebx, 1                  ; Flag: 1 = at start or after space
    
count_loop:
    mov al, [esi]               ; Get current character
    test al, al                 ; Check if end of string (0)
    jz count_done               ; If 0, done
    
    cmp al, ' '                 ; Compare with space
    je found_space
    
    ; If not space and ebx=1, we found start of word
    cmp ebx, 1
    jne continue_counting
    
    inc dword [word_count]      ; Increment word counter
    mov ebx, 0                  ; Mark that we're inside a word
    
continue_counting:
    inc esi                     ; Next character
    jmp count_loop
    
found_space:
    mov ebx, 1                  ; Mark that next char can be start of word
    inc esi                     ; Next character
    jmp count_loop
    
count_done:
    ; Show word count
    PUSH dword [word_count]
    PUSH msg_word_count
    CALL _printf
    ADD ESP, 8
    jmp menu_loop

; Option 4: Caesar Cipher (fixed shift of 3)
encrypt_caesar:
    call read_input
    
    ; Show original string
    PUSH output_prefix
    CALL _printf
    ADD ESP, 4
    
    PUSH input_buffer
    CALL _printf
    ADD ESP, 4
    
    ; Prepare to encrypt
    mov esi, input_buffer       ; Source (original text)
    mov edi, cipher_buffer      ; Destination (encrypted text)
    mov ecx, [bytes_read]       ; String length
    mov bl, 3                   ; Fixed shift of 3
    
encrypt_loop:
    mov al, [esi]               ; Get current character
    
    ; Check if uppercase letter (A-Z)
    cmp al, 'A'
    jb no_encrypt
    cmp al, 'Z'
    jbe encrypt_upper
    
    ; Check if lowercase letter (a-z)
    cmp al, 'a'
    jb no_encrypt
    cmp al, 'z'
    jbe encrypt_lower
    
    ; If not a letter, copy without modification
    jmp no_encrypt
    
encrypt_upper:
    sub al, 'A'                 ; Convert to 0-25
    add al, bl                  ; Apply shift
    cmp al, 26
    jb .upper_ok
    sub al, 26                  ; Wrap-around if >=26
.upper_ok:
    add al, 'A'                 ; Convert back to ASCII
    jmp copy_char
    
encrypt_lower:
    sub al, 'a'                 ; Convert to 0-25
    add al, bl                  ; Apply shift
    cmp al, 26
    jb .lower_ok
    sub al, 26                  ; Wrap-around if >=26
.lower_ok:
    add al, 'a'                 ; Convert back to ASCII
    jmp copy_char
    
no_encrypt:
    ; Copy character without modification
copy_char:
    mov [edi], al               ; Save character to destination
    inc esi                     ; Next source character
    inc edi                     ; Next destination character
    loop encrypt_loop           ; Continue until entire string processed
    
    mov byte [edi], 0           ; Add null terminator
    
    ; Show encrypted string
    PUSH output_encrypted
    CALL _printf
    ADD ESP, 4
    
    PUSH cipher_buffer
    CALL _printf
    ADD ESP, 4
    
    PUSH newline
    CALL _printf
    ADD ESP, 4
    
    jmp menu_loop

; Option 5: Decrypt Caesar Cipher (fixed shift of 3, inverse operation)
decrypt_caesar:
    call read_input

    ; Show original string
    PUSH output_prefix
    CALL _printf
    ADD ESP, 4

    PUSH input_buffer
    CALL _printf
    ADD ESP, 4

    ; Prepare to decrypt
    mov esi, input_buffer       ; Source (encrypted text)
    mov edi, cipher_buffer      ; Destination (decrypted text)
    mov ecx, [bytes_read]       ; String length
    mov bl, 3                   ; Fixed shift of 3

decrypt_loop:
    mov al, [esi]               ; Get current character

    ; Check if uppercase letter (A-Z)
    cmp al, 'A'
    jb no_decrypt
    cmp al, 'Z'
    jbe decrypt_upper

    ; Check if lowercase letter (a-z)
    cmp al, 'a'
    jb no_decrypt
    cmp al, 'z'
    jbe decrypt_lower

    ; If not a letter, copy without modification
    jmp no_decrypt

decrypt_upper:
    sub al, 'A'                 ; Convert to 0-25
    cmp al, bl
    jb .upper_wrap
    sub al, bl                  ; Subtract shift
    jmp .upper_ok
.upper_wrap:
    add al, 26
    sub al, bl
.upper_ok:
    add al, 'A'                 ; Convert back to ASCII
    jmp copy_decrypt_char

decrypt_lower:
    sub al, 'a'                 ; Convert to 0-25
    cmp al, bl
    jb .lower_wrap
    sub al, bl                  ; Subtract shift
    jmp .lower_ok
.lower_wrap:
    add al, 26
    sub al, bl
.lower_ok:
    add al, 'a'                 ; Convert back to ASCII
    jmp copy_decrypt_char

no_decrypt:
    ; Copy character without modification
copy_decrypt_char:
    mov [edi], al               ; Save character to destination
    inc esi                     ; Next source character
    inc edi                     ; Next destination character
    loop decrypt_loop           ; Continue until entire string processed

    mov byte [edi], 0           ; Add null terminator

    ; Show decrypted string
    PUSH output_decrypted
    CALL _printf
    ADD ESP, 4

    PUSH cipher_buffer
    CALL _printf
    ADD ESP, 4

    PUSH newline
    CALL _printf
    ADD ESP, 4

    jmp menu_loop

exit_program:
    ; --- 7. EXIT PROGRAM ---
    PUSH dword 0
    CALL _exit