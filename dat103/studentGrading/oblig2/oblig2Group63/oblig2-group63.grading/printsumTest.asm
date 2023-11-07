; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10

; Konstanter
    cr equ 13 ; Vognretur
    lf equ 10 ; Linjeskift
    SYS_EXIT equ 1
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    STDERR equ 2

; Datasegment
  section .bss
    siffer resb 4

; Datasegment
section .data
    meld db "Skriv to ensifrede tall skilt med mellomrom."
         db "Summen av tallene maa vaere mindre enn 18 og stoerre enn 10.", cr, lf
    meldlen equ $ - meld
    feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
    feillen equ $ - feilmeld
    crlf db cr,lf
    crlflen equ $ - crlf
    errmsg db "Error: ugyldige tall, sum ikke mindre enn 18 eller stoerre enn 10", lf
    errlen equ $ - errmsg

; Kodesegment med program
section .text

global _start
_start:
    mov edx,meldlen
    mov ecx,meld
    mov ebx,STDOUT
    mov eax,SYS_WRITE
    int 80h

    ; Les tall, innlest tall returneres i ecx
    ; Vellykket retur dersom edx=0
    call lessiffer
    cmp edx,0      ; Test om vellykket innlesgning
    jne Slutt      ; Hopp tilavslutning ved feil i innlesning
    mov eax,ecx    ; Foerste tall/siffer lagres i reg eax

    ; Les andre tall/siffer
    ; vellykket:  edx=0, tall i ecx
    call lessiffer
    cmp edx,0      ; Test om vellykket innlesning
    jne Slutt
    mov ebx,ecx    ; andre tall/siffer lagres i reg ebx

    call nylinje
    add eax,ebx
    cmp eax, 10
    jbe Error
    cmp eax, 18
    jge Error
    xor edx, edx
    mov ecx,10
    div ecx
    push edx

    add eax, '0'
    mov [siffer], al
    mov ecx, siffer
    call skrivsiffer ; Skriv ut verdi i ecx som ensifret tall

    pop eax
    add eax, '0'
    mov [siffer], al
    mov ecx, siffer
    call skrivsiffer

Slutt:
      mov eax,SYS_EXIT
      mov ebx,0
      int 80h
;--------------------------------------------------------------------------------------------------------------
Error:
mov edx, errlen
mov ecx, errmsg
mov ebx, STDOUT
mov eax, SYS_WRITE
int 80h
jmp Slutt
; -------------------------------------------------------------------------------------------------------------
skrivsiffer:
    ; Skriver ut sifferet lagret i ecx. Ingen sjekk paa verdiomraede
    push eax
    push ebx
    push ecx
    push edx
    mov ecx, siffer
    mov edx, 2
    mov ebx,STDOUT
    mov eax,SYS_WRITE
    int 80h
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
; ---------------------------------------------------------------------------------------------------------------
lessiffer:
    ; Leter forbi alle blanke til neste ikke-blank
    ; Neste ikke-blank returneres i ecx
    push eax
    push ebx

Lokke:
    ; Leser et tegn fra tastaturet
    mov eax,SYS_READ
    mov ebx,STDIN
    mov ecx,siffer
    mov edx,1
    int 80h
    mov ecx,[siffer]

    cmp ecx,' '
    je Lokke
    cmp ecx,'0' ; Sjekk at tast er i omraede 0-9
    jb Feil
    cmp ecx,'9'
    ja Feil
    sub ecx,'0' ; Konverterer ascii til tall
    mov edx,0   ; signaliserer vellykket innlesning
    pop ebx
    pop eax
    ret         ; Vellykket retur

Feil:
   mov edx,feillen
   mov ecx,feilmeld
   mov ebx,STDERR
   mov eax,SYS_WRITE
   int 80h
   mov edx,1   ; signalisrer mislykket innlesning av tall
   pop ebx
   pop eax
   ret         ; Mislykket retur

; --------------------------------------------------------------------------------------------------------------
; Flytt cursor helt til venstre paa neste linje
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

; End _start
