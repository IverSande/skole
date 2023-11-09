; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Porgrammet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10.

; Konstanter
    cr equ 13  ; Vognretur
    lf equ 10  ; Linjeskift
    SYS_EXIT   equ 1
    SYS_READ   equ 3
    SYS_WRITE  equ 4
    STDIN      equ 0
    STDOUT     equ 1
    STDERR     equ 2

; Datasegment
section .bss
    siffer resb  4

; Datasegment
section .data
    meld db "Skriv to ensifrede tall skilt med mellomrom.", cr,lf
         db "Summen av tallene maa vaere stoore enn 10 og mindre enn 18.", cr,lf
    meldlen equ $ - meld
    feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
    
    display12 db "12",cr,lf
    display12len equ $ - display12
    
    display13 db "13",cr,lf
    display13len equ $ - display13
    
    display14 db "14",cr,lf
    display14len equ $ - display14
    
    display15 db "15",cr,lf
    display15len equ $ - display15
    
    display16 db "16",cr,lf
    display16len equ $ - display16
    
    display17 db "17",cr,lf
    display17len equ $ - display17
    
    feillen equ $ - feilmeld
    crlf db cr,lf
    crlflen equ $ - crlf


; Kodesegment med program
section .text

global _start
_start:
    mov edx,meldlen
    mov ecx,meld
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 80h
  
    ; Les tall, innlest tall returneres i ecx
    ; Vellykket retur dersom edx=0
    call lessiffer
    cmp edx,0     ; Test om vellykket innlesning
    jne Slutt     ; Hopp tilavslutning ved feil i innlesing
    mov eax,ecx   ; Forste tall/siffer lagres i reg eax

    ; Les andre tall/siffer
    ; Vellykket : edx = 0, tall i ecx
    call lessiffer
    cmp edx,0     ; Test om vellykket innlesning
    jne Slutt
    mov ebx,ecx   ; andre tall/siffer lagres i reg ebx

    call nylinje
    add eax,ebx
    mov ecx, eax

   
    cmp ecx,11
    jl Slutt

    cmp ecx,12
    je Print12

    cmp ecx,13
    je Print13

    cmp ecx,14
    je Print14

    cmp ecx,15
    je Print15

    cmp ecx,16
    je Print16

    cmp ecx,17
    je Print17

    

    cmp ecx,18
    jge Slutt
    
                      ; Skriv ut verdi i ecx som ensifret


Slutt:
    mov eax, SYS_EXIT
    mov ebx,0
    int 80h

; -------------------------------------------------------------------------
skrivsiffer:
    ; Skriver ut sifferet lagret i ecx. Ingen sjekk pa verdiomrade
    push eax
    push ebx
    push ecx
    push edx
    add ecx,'0'    ; converter tall til ascii.
    mov [siffer],ecx
    mov ecx,siffer
    mov edx,1
    mov ebx,STDOUT
    mov eax, SYS_WRITE
    int 80h
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret 

; -------------------------------------------------------------------------
lessiffer:
    ; Leter forbi alle blanke til neste ikke-blank
    ; Neste ikke-blank returneres i ecx
    push eax
    push ebx

Lokke:
    ; Leser et tegn fra tastaturet
    mov eax,SYS_READ
    mov ebx, STDIN
    mov ecx,siffer
    mov edx,1
    int 80h
    mov ecx, [siffer]

    cmp ecx,' '
    je Lokke
                  ; Sjekk at tast er i omrade 0-9
  
    sub ecx,'0'   ; Konverter ascii til tall.
    mov edx,0    ; signaliser vellykket innlesning
    pop ebx
    pop eax
    ret          ; Vellykket retur



     
  Feil :
     mov edx,feillen
     mov ecx, feilmeld
     mov ebx,STDERR
     mov eax,SYS_WRITE
     int 80h
     jmp end_program      ; Mislykket retur

; ---------------------------------------------------------------------
; Flytt cursor helt til venstre pa neste linje

Print12:
    mov edx,display12len
    mov ecx,display12
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 80h
    jmp end_program

Print13:
    mov edx,display13len
    mov ecx,display13
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 80h
    jmp end_program

Print14:
    mov edx,display14len
    mov ecx,display14
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 80h
    jmp end_program


Print15:
    mov edx,display15len
    mov ecx,display15
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 80h
    jmp end_program

Print16:
    mov edx,display16len
    mov ecx,display16
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 80h
    jmp end_program

Print17:
    mov edx,display17len
    mov ecx,display17
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 80h
    jmp end_program

nylinje:
    push eax
    push ebx
    push ecx
    push edx
    mov edx,crlflen
    mov ecx,crlf
    mov ebx,STDOUT
    mov eax,SYS_WRITE
    int 80h
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

end_program:
    mov eax,1
    xor ebx,ebx
    int 80h

;End _start
