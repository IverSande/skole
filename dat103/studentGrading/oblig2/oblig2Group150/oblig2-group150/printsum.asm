; Inndata programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata programmet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10.

; Konstanter

	cr 	  equ 13 ; Vognretur
	lf 	  equ 10 ; linjeskift
	SYS_EXIT  equ 1
	SYS_READ  equ 3
	SYS_WRITE equ 4
	STDIN 	  equ 0
	STDOUT 	  equ 1
	STDERR	  equ 2

;Datasegment
section .bss
	siffer	  resb 4

;Datasegment
section .data
	meld db "Skriv to ensifrede tall med mellomrom.",cr,lf
	     db "Summen av tallene maa vaere mindre enn 10.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, 	"Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	crlf db cr,lf
	crlflen equ $ - crlf

; Kodesegment med program
section .text

global _start
_start:
	mov edx,meldlen
	mov ecx,meld
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h

	; Les tall, innlest tall returneres i exc
	; Vellykket retur dersom edx = 0
	
	call lessiffer
	cmp edx,0	;Test om vellykket innlesning
	jne Slutt	;Hopp til avslutning ved feil i innlesing
	mov eax,ecx	;Foerste tall/siffer lagres i reg eax

	;Les andre tall/siffer
	;Velllykket: edx=0, tall i ecx

	call lessiffer
	cmp edx,0 	;Test om vellykket innlesning
	jne Slutt
	mov ebx,ecx	;Andre tall/siffer lagres i reg ebx
	
	add eax, ebx
	cmp eax, 10
	jle Slutt
	cmp eax, 18
	jg Slutt

	mov ecx,eax
	call skrivsiffer ;Skriv ut verdi i ecx som ensifret tall
	call nylinje

Slutt:
	mov eax,SYS_EXIT
	mov ebx,0
	int 80h

;---------------------------------------------------
skrivsiffer:
    ;Skriver ut sifferet lagret i ecx. Ingen sjekk på verdiområde
    push eax
    push ebx
    push ecx
    push edx

    mov eax, ecx
    xor edx, edx
    mov ebx, 10
    div ebx

	; lagre koefisient og rest i minne
	mov [siffer], al
	mov [siffer+1], dl

    ; printer tierplass / koefisient 
    add byte [siffer], '0'
	mov ecx, siffer
	mov edx, 1
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 80h

    ; printer enerplass / rest
    add byte [siffer+1], '0'
    mov ecx, siffer+1
    mov edx, 1
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 80h

    ; resturerer stack
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
;---------------------------------------------------
lessiffer:
	;Leter forbi alle blanke til neste ikke-blanke
	;NEste ikke-blank returneres i ecx
	push eax
	push ebx

Lokke:
	;Leser et tegn fra tastaturet
	mov eax,SYS_READ
	mov ebx,STDIN
	mov ecx,siffer
	mov edx,1
	int 80h
	mov ecx,[siffer]

	cmp ecx,' '
	je Lokke
	cmp ecx,'0'	;Sjekk at tast er i omraade 0-9
	jb Feil
	cmp ecx,'9'
	ja Feil
	sub ecx,'0'	;Konverter ascii til tall.
	mov edx,0	;Signaliser vellykket innlesing
	pop ebx
	pop eax
	ret			;Vellykket retur

Feil:
	mov edx,feillen
	mov ecx,feilmeld
	mov ebx,STDERR
	mov eax,SYS_WRITE
	int 80h
	mov edx,1	;Singaliser mislykket innlesning av tall
	pop ebx
	pop eax
	ret			;Mislykket retur

;-----------------------------------------------------

;Flytt cursor helt til venstre på neste linje
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

;End _start