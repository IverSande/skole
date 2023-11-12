; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene ,
; forutsatt at summen er mindre enn 10.

; Konstanter
    cr equ 13; Carriage Return
    lf equ 10; Line Feed
    SYS_EXIT equ 1 ; System call nummer for å avslutte programmet
    SYS_READ equ 3 ; System call nummer for å lese fra en fil
    SYS_WRITE equ 4 ; System call nummer for å skrive til en fil
    STDIN equ 0 ; Nummer for standard input
    STDOUT equ 1 ; Nummer for standard output
    STDERR equ 2 ; Nummer for standard error

; Datasegment
section .bss
    siffer resb 4 ; Reserverer 4 bytes i bss-segmentet for å lagre et ensifret tall

; Datasegment
section .data 
    meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf ; Melding som skal skrives ut til brukeren
    meldlen equ $-meld ; Lengden av meldingen
    feilmeld db cr,lf, "Skriv kun sifre!",cr,lf ; Feilmelding som skal skrives ut hvis brukeren skriver inn ugyldige tegn
    feillen equ $-feilmeld ; Lengden av feilmeldingen
    crlf db cr,lf ; Carriage return og line feed
    crlflen equ $-crlf ; Lengden av crlf



; Kodesegment med program
section .text
    
global _start ; Startpunktet for programmet
_start:
    mov edx, meldlen    ; Sett lengden av meldingen i edx
    mov ecx, meld       ; Sett startadressen til meldingen i ecx
    mov ebx, STDOUT     ; Sett filnummeret til skjermen i ebx
    mov eax, SYS_WRITE  ; Sett system call nummeret for skriving i eax
    int 80h             ; Utfør system call for å skrive meldingen til skjermen

    ; Les tall, innlest tall returneres i ecx.
    ; Vellykket retur dersom edx = 0.
    call lessiffer      ; Kall funksjonen lesssiffer for å lese inn to ensifrede tall fra brukeren
    cmp edx, 0          ; Sjekk om lesing var vellykket
    jne Slutt           ; Hvis lesing ikke var vellykket, hopp til Slutt
    mov eax, ecx        ; Sett summen av tallene i ebx

    ; Les andre tall/siffer
    ; Vellykket retur dersom edx=0
    call lessiffer
    cmp edx, 0          ; Sjekk om lesing var vellykket
    jne Slutt           ; Hvis lesing ikke var vellykket, hopp til Slutt
    mov ebx, ecx        ; Sett summen av tallene i ebx

    call nylinje ; Skriv ut en ny linje
    add eax, ebx ; Legg sammen eax og ebx

    mov ecx, eax ; Sett summen av tallene i ecx
    call skrivsiffer ; Skriv ut summen av tallene som et ensifret tall

Slutt:
    mov eax, SYS_EXIT ; Sett system call nummeret for å avslutte programmet i eax
    mov ebx, 0 ; Sett returverdien til 0
    int 80h ; Utfør system call for å avslutte programmet


skrivsiffer:
    ; Skriver ut tallet lagret i eax som et tosifret tall mellom 10 og 18
    push eax ; Lagre tallet på stacken
    mov ebx, 10 ; Sett ebx til 10
    div ebx ; Del tallet i eax på 10
    add al, 48 ; Legg til 48 for å få ASCII-verdien til første siffer
    mov [siffer], al ; Lagre første siffer i siffer-variabelen
    mov eax, edx ; Sett resten av divisjonen i eax
    add al, 48 ; Legg til 48 for å få ASCII-verdien til andre siffer
    mov [siffer+1], al ; Lagre andre siffer i siffer-variabelen
    mov edx, 2 ; Sett lengden av tallet til 2
    mov ecx, siffer ; Sett startadressen til tallet i ecx
    mov ebx, STDOUT ; Sett filnummeret til skjermen i ebx
    mov eax, SYS_WRITE ; Sett system call nummeret for skriving i eax
    int 80h ; Utfør system call for å skrive tallet til skjermen
    pop eax ; Hent tallet fra stacken
    call nylinje ; Skriv ut en ny linje
    ret

lessiffer:
    ; Leter forbi alle blanke til neste ikke-blank.
    ; Neste ikke-blanke returneres i ecx.
    push eax
    push ebx

Lokke:
    ; Leser et tegn fra tastaturet
    mov eax , SYS_READ
    mov ebx , STDIN
    mov ecx , siffer
    mov edx ,1
    int 80h
    mov ecx ,[ siffer ]

    cmp ecx , ' '
    je Lokke
    cmp ecx , '0' ; Sjekk at tast er i område 0 -9
    jb Feil
    cmp ecx , '9'
    ja Feil
    sub ecx , '0' ; Konverter ascii til tall .
    mov edx ,0 ; signaliser vellykket innlesning
    pop ebx
    pop eax
    ret

Feil:
    mov edx, feillen
    mov ecx, feilmeld
    mov ebx, STDERR
    mov eax, SYS_WRITE
    int 80h
    mov edx, 1  ; Signaliserer mislykket innlesing av tall.
    pop ebx
    pop eax
    ret



nylinje:
    push eax
    push ebx
    push ecx
    push edx
    mov edx, crlflen ; Sett lengden av crlf i edx
    mov ecx, crlf ; Sett startadressen til crlf i ecx
    mov ebx, STDOUT ; Sett filnummeret til skjermen i ebx
    mov eax, SYS_WRITE ; Sett system call nummeret for skriving i eax
    int 80h ; Utfør system call for å skrive crlf til skjermen
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; End _start