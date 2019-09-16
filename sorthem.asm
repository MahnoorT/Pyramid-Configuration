%include "asm_io.inc"

SECTION .data

msg1: db "The program must have one command line argument", 10, 0
msg2: db "Incorrect integer, the number must be between 2 and 9.", 10, 0
tri1: db "        o|o", 10, 0
tri2: db "       oo|oo", 10, 0
tri3: db "      ooo|ooo", 10, 0
tri4: db "     oooo|oooo", 10, 0
tri5: db "    ooooo|ooooo", 10, 0
tri6: db "   oooooo|oooooo", 10, 0
tri7: db "  ooooooo|ooooooo", 10, 0
tri8: db " oodooooo|oooooooo", 10, 0
tri9: db "ooooooooo|ooooooooo", 10, 0
peg: dd 0, 0, 0, 0, 0, 0, 0, 0, 0
initial: db "Initial Configuration", 10, 0
final: db "Final Configuration", 10, 0
exes: db "XXXXXXXXXXXXXXXXXXXXXXX", 10, 0
discs: dd 0

SECTION .bss

SECTION .text
    global asm_main

showp:
    enter 0,0
    pusha
    
    mov ecx, dword [ebp+8] ;; pointer to array
    mov eax, dword [ebp+12] ;; number of disks
    mov ebx, dword 32
    add ecx, ebx

    mov esi, dword 1 ;; setting a counter of 1
    LOOP:
      cmp [ecx], dword 1
      jne check2
      mov eax, tri1
      call print_string
      jmp all_checked

      check2:
      cmp [ecx], dword 2
      jne check3
      mov eax, tri2
      call print_string
      jmp all_checked

      check3:
      cmp [ecx], dword 3
      jne check4
      mov eax, tri3
      call print_string
      jmp all_checked

      check4:
      cmp [ecx], dword 4
      jne check5
      mov eax, tri4
      call print_string
      jmp all_checked

      check5:
      cmp [ecx], dword 5
      jne check6
      mov eax, tri5
      call print_string
      jmp all_checked

      check6:
      cmp [ecx], dword 6
      jne check7
      mov eax, tri6
      call print_string
      jmp all_checked

      check7:
      cmp [ecx], dword 7
      jne check8
      mov eax, tri7
      call print_string
      jmp all_checked

      check8:
      cmp [ecx], dword 8
      jne check9
      mov eax, tri8
      call print_string
      jmp all_checked

      check9:
      cmp [ecx], dword 9
      jne all_checked
      mov eax, tri9
      call print_string
      jmp all_checked

      all_checked:
      cmp esi, dword 9
      je loop_end
      sub ecx, 4
      add esi, dword 1
      jmp LOOP
     
    loop_end:
    mov eax, exes
    call print_string
    popa
    leave
    ret

sorthem:
    enter 0, 0
    pusha 
    
    
    mov ebx, dword [ebp+8] ;; array pointer
    mov ecx, dword [ebp+12] ;; number of discs

    cmp ecx, dword 1 ;;checking to see if the # of discs is 1
    je sort_done  ;; if it is, then the function has reached its base case

    add ebx, 4 ;; if its not, the the pointer to the array moves up to the next disc
    dec ecx ;; decrease the number of discs
    push ecx ;; pushes this on top
    push ebx
    call sorthem ;; calls the function again
    add esp, 8
    mov ebx, dword [ebp+8]
    mov ecx, dword [ebp+12]

    mov esi, dword 0 ;; begining counter for loop
    sub ecx, dword 1

    LOOP_SORT:
        cmp esi, ecx
        je sort_done
    	mov eax, [ebx]
        mov edi, [ebx+4]
        cmp eax, edi
        ja loop_end2
        cmp eax, edi
        jb swap
        jmp LOOP_SORT

        swap:
        mov [ebx], edi
        mov [ebx+4], eax
        add ebx, dword 4
        add esi, dword 1
        jmp LOOP_SORT

        loop_end2:
        mov eax, [discs]
        push eax
        mov eax, peg
        push eax
        call showp
        add esp, 8
        call read_char
        jmp sort_done

    sort_done:
    popa
    leave
    ret     
      


asm_main:
    enter 0, 0 ;; setup routine

    mov eax, [ebp+8]
    cmp eax, 2
    je check_digit
    mov eax, msg1
    call print_string
    jmp asm_end

    check_digit:
    mov ebx, [ebp+12]
    mov ecx, [ebx+4]
    cmp byte [ecx+1], byte '0'
    je not_digit
    cmp byte [ecx], '2'
    jb not_digit
    cmp byte [ecx], '9'
    ja not_digit
    jmp All_ok

    not_digit:
    mov eax, msg2
    call print_string
    jmp asm_end

    All_ok: ;;generate random numbers
    mov al, byte [ecx]
    sub eax, dword '0'
    mov [discs], eax
    push eax 
    mov eax, peg
    push eax ;; push stack on top
    call rconf ;; call the function
    add esp, 8 ;; add spaces for 8 bytes

    ;;for showing initial configuration
    mov eax, initial
    call print_string
    mov eax, [discs]
    push eax
    push peg
    call showp
    add esp, 8
    call read_char
    
    ;;For Swapping
    mov eax, [discs]
    push eax
    push peg
    call sorthem
    add esp, 8

    ;;For Final configuration
    mov eax, final
    call print_string
    mov eax, [discs]
    push eax
    push peg
    call showp
    add esp, 8

    asm_end:
    leave
    ret
