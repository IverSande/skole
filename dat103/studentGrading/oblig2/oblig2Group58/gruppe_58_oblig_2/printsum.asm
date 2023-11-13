; Inndata Programmet leser inn to sire skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene.
; forutsatt at summen er mindre enn 10

; Konstanter
	cr	equ	13 ; Vognretur
	lf	equ	10 ; Linjeskift
	SYS_EXIT	equ 1
	SYS_READ	equ 3
	SYS_WRITE	equ 4
	STDIN		equ 0
	STDOUT		equ 1
	STDERR		equ 2

; Datasegment
section .bss
    siffer resb 4
    forste resb 4
    siste resb 4

; Skrivsegment
section .text
    undergrense db "Sum er for lavt, sum må vøre mer enn 10",cr,lf
    uglen equ $ - undergrense
    overgrense db "Sum er for høy, sum må være under 18",cr,lf
    oglen equ $ - overgrense
    ikkegyldig db "Sum er ikke gyldig",cr,lf
    iglen equ $ - ikkegyldig

; Datasegment
section .data
	meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
	db "summen av tallene maa vaere mindre større en 10 og mindre enn 18.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	crlf db cr,lf
	crlflen equ $ -crlf


global _start
_start:
	mov edx ,meldlen
	mov ecx ,meld
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h

	; Les tall, innlest tall returneres i ecx
	; Vellykket retur dersom edx=0
	call LesSiffer
	cmp edx,0 		;Test om vellykket innlesning
	jne Slutt 		; Hopp til avslutning ved feil i innlesning
	mov eax,ecx		;Første tall/siffer lagres i reg eax

	; Les andre tall/siffer
	; Vellykket: edx=0, tall i ecx
	call LesSiffer
	cmp edx,0		;Test om vellykket innlesning
	jne Slutt
	mov ebx,ecx		; andre tall/siffer lagres i reg ebx

	call Nylinje
	add eax,ebx
    mov ecx,eax
	call SkrivSiffer ; Skriver ut verdi i en ecx som ensifret tall

Slutt:
	mov eax,SYS_EXIT
	mov ebx,0
	int 80h


;------------------------------------------------------------------------------
SkrivSiffer:
    push eax
    push ebx
    push ecx
    push edx

    ; Lagrer original tallet vårt i siffer
    mov [siffer], ecx

    ; Hvis tall er mer enn ti, gjør vi hele koden
    cmp ecx, 10
    jae MerEnnTi

    ;Hvis tall er under ti skriver vi kunn siste siffer
    add ecx, '0'
    mov [siste], ecx
    jmp SkrivEn

MerEnnTi: ;skriver ut tall mer enn ti
    ; lagrer en'er verdi som siste siffer i sum
    sub ecx, 10
    add ecx, '0'
    mov [siste], ecx ; Sum lagres i siste for senere sammenlikning


    SkrivTi: ; Henter ut 10'er tall
    mov eax, [siffer] ; Legger siffer i register eax for operasjoner
    xor edx, edx ; Fjerner edx for å kunne gjøre divisjon
    mov ebx, 10 ; Legger 10 i ebx for div å bruke til å dele med
    div ebx ; Deler eax med 10
    add eax, '0' ; Konverterer svar til ASCII
    mov [forste], eax ; Legger svar fra eax til forste

    ; Skriver ut ti'er tall
    mov ecx, forste
    mov edx, 1
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 80h
    ;skriver så ut en'er tallet

SkrivEn: ; Skriver ut en'er tall
    mov ecx, siste
    mov edx, 1
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 80h

    ; Sjekker at siffer er innenfor grense
    mov ecx, [siffer]
    cmp ecx, 10
    jbe FeilSkrivUnder ; FeilInput hvis feiler
    cmp ecx, 18
    jae FeilSkrivOver ; FeilInput hvis feiler

    ; Balanserer stack
    pop eax
    pop ebx
    pop ecx
    pop edx
    ret

FeilSkrivUnder:
    ; Hvis verdi ikke over 10
    mov edx, uglen
    mov ecx, undergrense
    mov ebx, STDERR
    mov eax, SYS_WRITE
    int 80h

    ; Balanserer stack
    pop eax
    pop ebx
    pop ecx
    pop edx
    ret

FeilSkrivOver:
    mov edx, oglen
    mov ecx, overgrense
    mov ebx, STDERR
    mov eax, SYS_WRITE
    int 80h

    ; Balanserer stack
    pop eax
    pop ebx
    pop ecx
    pop edx
    ret

;---------------------------------------------------------------------------


LesSiffer:
	; Leter forbi alle blante til neste ikke-blank
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

    ;Sjekker for space hvis space går vi gjennom til neste til vi finner noe annet enn space
    cmp ecx, ' '
    je Lokke

    ;hvis vi har verdi sjekk om gyldig
    cmp ecx, '0'	; Sjekk ta tast er i område 0-9
    jb FeilLes
    cmp ecx, '9'
    ja FeilLes

    ;hvis gylidg konverter
    sub ecx, '0'	; Konverterer ascii til tall
    mov edx,0		; Signaliserer vellykket innlesning
    pop ebx
    pop eax
    ret 			; Vellykket retur

FeilLes:
    mov edx, feillen
    mov ecx, feilmeld
    mov ebx, STDERR
    mov eax, SYS_WRITE
    int 80h
    mov edx, 1
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------
; Flytt cursor helt til venstre på neste Linje
Nylinje:
	push eax
	push ebx
	push ecx
	push edx
	mov edx, crlflen
	mov ecx, crlf
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
; End _start