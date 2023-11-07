; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene ,
; forutsatt at summen er mindre enn 10.

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
	tier resb 4
	
; Datasegment
section .data
	meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
		db "Summen av tallene maa vaere mer enn 10, men mindre enn 18.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	undermeld db "Summen er mindre enn 10!",cr,lf
	underlen equ $ - undermeld
	crlf db cr,lf
	crlflen equ $ - crlf
	
; kodesegment med program
section .text

global _start

; --------------------------------------------------------------------------------
_start:
	mov edx,meldlen
	mov ecx,meld
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h
	
	; Les tall, innlest tall returneres i ecx
	; Vellykket retur dersom edx = 0
	call lessiffer
	cmp edx,0		; Test om vallykket innlesning
	jne Slutt       ; Hopp tilavslutning ved feil innlesning
	mov eax, ecx 	; Foerste tall/siffer lagres i reg eax
	
	; Les tall, innlest tall returners i ecx
	; Vellykket: edx = 0, tall i ecx
	call lessiffer
	cmp edx,0		; Test om vellykket innlesning
	jne Slutt       ; Hopp tilavslutning ved feil innlesning
	mov ebx, ecx 	; Andre tall/siffer lagres i reg ebx
	
	call nylinje

	add eax, ebx
	
	;sjekker om summen er over 10
	sub eax,10 
	cmp eax, 0
    jge Over10
	
    ; hvis summen er under 10 printes det ut en feil melding
    mov edx,underlen
	mov ecx,undermeld
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h
    call Slutt
; ------------------------------------------------------------------------------
Over10:

	mov ecx, eax
	mov edx,1
	cmp edx,0
    call skrivsiffer
	
; --------------------------------------------------------------------------------
Slutt:
	mov eax, SYS_EXIT
	mov ebx,0
	int 80h
; --------------------------------------------------------------------------------
skrivsiffer:
	; Skriver ut sifferet lagret ecx. Ingen sjekk paa verdiomraade
	push eax
	push ebx
	push ecx
	push edx
	
	add edx,'0'	; konventerer tall til ascii.
	add ecx,'0'	; konventerer tall til ascii.
	mov [siffer],ecx
	mov [tier], edx
	
	; printer ut sifferet paa tier-plassen
	mov ecx,tier
	mov edx,1
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h
	
	; printer ut sifferet paa ener-plassen
	mov ecx,siffer
	mov edx,1
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
	
; --------------------------------------------------------------------------------
lessiffer:
	; Leter forbi alle blanke til neste ikke-blanke
	; Neste ikke-blanke returneres i ecx
	push eax
	push ebx

Lokke:
	; Leser et tergn fra tastaturet
	mov eax,SYS_READ
	mov ebx,STDIN
	mov ecx,siffer
	mov edx,1
	int 80h
	mov ecx,[siffer]
	
	cmp ecx,' '
	je Lokke
	cmp ecx,'0' ; Sjekk at tast er i omraadet 0-9
	jb Feil
	
	cmp ecx,'9'
	ja Feil
	sub ecx,'0' ; Konverterer ascii yil tall.
	mov edx,0	; Signaliserer vellykket innlesning
	pop ebx
	pop eax
	ret 		; Vellykket retur
	
Feil:
	mov edx,feillen
	mov ecx,feilmeld
	mov ebx,STDERR
	mov eax,SYS_WRITE
	int 80h
	mov edx,1	;Signaliserer mislykket innlesning av tall
	pop ebx
	pop eax 
	ret			; Misslykket retur
	
; --------------------------------------------------------------------------------
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
	
; End _startbb   